import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

/// Resolves a brand logo for an entry name via the logo.dev image API, backed by
/// a hydrated, persistent cache so the (external) logo API is called at most
/// once per brand - ever, across sessions and devices.
///
/// logo.dev serves logos keyed by *domain* (`https://img.logo.dev/{domain}`),
/// so all we need on the client is the free, publishable token - the name based
/// search endpoint requires a *secret* key that must never ship in client code.
/// We therefore guess a domain from the entry name (e.g. "Netflix" ->
/// netflix.com) and ask logo.dev for that logo with `fallback=404`, so a brand
/// we can't resolve returns a 404 instead of a generated monogram.
///
/// The result (a URL, or "not found") is written to the `logo_cache` Firestore
/// collection keyed by domain and [hydrate]d into memory on startup. A repeat
/// creation of the same brand is then served from the cache with no network
/// call. The UI still falls back to the category icon while a logo loads or if
/// it ever fails to load.
class LogoService {
  LogoService({http.Client? client, FirebaseFirestore? firestore})
      : _client = client ?? http.Client(),
        _db = firestore;

  final http.Client _client;

  // Resolved lazily so constructing the service never touches Firestore (which
  // needs an initialised Firebase app) - only hydrate() / findLogo do.
  FirebaseFirestore? _db;
  FirebaseFirestore get _dbRef => _db ??= FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _cacheCol => _dbRef.collection('logo_cache');

  /// logo.dev publishable token (`pk_...`). Safe to ship in the client. Provide
  /// it at build time with `--dart-define=LOGO_DEV_TOKEN=pk_xxx`, or drop it into
  /// [_fallbackToken] below for local runs.
  static const _token = String.fromEnvironment('LOGO_DEV_TOKEN', defaultValue: _fallbackToken);

  /// logo.dev *publishable* token. Safe to keep in client source (that is what
  /// "publishable" means) - unlike the secret `sk_` key, which must never ship
  /// in an app. Override at build time with --dart-define=LOGO_DEV_TOKEN if you
  /// prefer to keep it out of the repo.
  static const _fallbackToken = 'pk_e1NbNdDSROmYN2S0z1GOvQ';

  /// Rendered logo size in px. logo.dev supports 32-512.
  static const _size = 128;

  bool get _hasToken => _token.isNotEmpty && !_token.startsWith('pk_REPLACE');

  /// Domain -> resolved logo URL (null = looked up, no logo found). We use
  /// `containsKey` to tell "already looked up" from "never looked up", so both
  /// hits and misses are cached and the logo API is hit at most once per domain.
  final Map<String, String?> _cache = {};

  Future<void>? _hydrating;

  /// Loads the persisted logo cache into memory. Idempotent - concurrent and
  /// repeat callers share one in-flight run. Safe (and cheap) to call at
  /// startup; tolerates being offline by starting from an empty cache.
  Future<void> hydrate() => _hydrating ??= _hydrate();

  Future<void> _hydrate() async {
    if (!_hasToken) return;
    try {
      final snap = await _cacheCol.get();
      for (final doc in snap.docs) {
        _cache[doc.id] = doc.data()['url'] as String?;
      }
    } catch (_) {
      // Offline / unavailable: start empty and resolve live as entries are made.
    }
  }

  /// Returns a ready-to-render logo URL for [name], or null when no brand logo
  /// exists (or lookup fails / no token is configured) so the caller keeps its
  /// default icon. The first lookup of a domain hits logo.dev and is cached
  /// (persisted to Firestore); every later lookup of the same domain is served
  /// from the cache without a network call.
  Future<String?> findLogo(String name) async {
    if (!_hasToken) return null;
    final domain = _domainFor(name);
    if (domain == null) return null;
    return _resolve(domain);
  }

  /// Resolves (and caches) the logo URL for a single [domain]: served from the
  /// in-memory / persistent cache when known, otherwise looked up once and
  /// persisted. Shared by [findLogo] and [searchLogos].
  Future<String?> _resolve(String domain) async {
    await hydrate();
    if (_cache.containsKey(domain)) return _cache[domain];

    final url = await _lookup(domain);
    _cache[domain] = url;
    // Persist so the lookup is never repeated on a later session / device. The
    // in-memory cache is already updated, so a slow or failed write must never
    // block the caller - fire it and forget.
    unawaited(_cacheCol.doc(domain).set({'url': url}).catchError((_) {}));
    return url;
  }

  /// Searches brand logos for [query] by probing likely domains (or the domain
  /// the user typed directly), returning the distinct logo URLs that resolve -
  /// best guess first - for the logo picker's tile grid. Empty when none resolve
  /// or no token is configured. Each probe is cached like [findLogo].
  Future<List<String>> searchLogos(String query) async {
    if (!_hasToken) return const [];
    final domains = _candidateDomains(query);
    if (domains.isEmpty) return const [];
    final results = await Future.wait(domains.map(_resolve));
    final seen = <String>{};
    return [
      for (final url in results)
        if (url != null && seen.add(url)) url,
    ];
  }

  /// Candidate domains for a free-text [query]. A query that already looks like a
  /// domain (contains a dot) is used as-is; otherwise the cleaned name is tried
  /// against a handful of common TLDs so well-known brands resolve.
  List<String> _candidateDomains(String query) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) return const [];
    if (trimmed.contains('.')) {
      final domain = trimmed.replaceAll(RegExp(r'\s'), '');
      return domain.isEmpty ? const [] : [domain];
    }
    final base = trimmed.replaceAll(RegExp(r'[^a-z0-9]'), '');
    if (base.isEmpty) return const [];
    return ['$base.com', '$base.io', '$base.co', '$base.app', '$base.net', '$base.org'];
  }

  /// Asks logo.dev for [domain]'s logo and returns the URL when it really exists
  /// (HTTP 200), or null on a 404 / error / timeout.
  Future<String?> _lookup(String domain) async {
    final url = _logoUrl(domain);
    try {
      final res = await _client.get(Uri.parse(url)).timeout(const Duration(seconds: 5));
      if (res.statusCode == 200 && res.bodyBytes.isNotEmpty) return url;
    } catch (_) {
      // Offline / slow network / bad response: treat as "no logo".
    }
    return null;
  }

  String _logoUrl(String domain) =>
      'https://img.logo.dev/$domain?token=$_token&size=$_size&format=png&fallback=404';

  /// Derives a best-guess domain from a free-text entry name: strip everything
  /// but letters and digits and append `.com`. "Netflix" -> netflix.com,
  /// "HBO Max" -> hbomax.com, "Coffee" -> coffee.com. Returns null when nothing
  /// usable remains.
  String? _domainFor(String name) {
    final cleaned = name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return cleaned.isEmpty ? null : '$cleaned.com';
  }
}
