import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ota_update/ota_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// A newer app build advertised by the DEV Play store catalog.
class UpdateInfo {
  const UpdateInfo({
    required this.versionName,
    required this.versionCode,
    required this.apkUrl,
  });

  /// Human-readable name shown on the update screen, e.g. "1.0.3".
  final String versionName;

  /// Monotonic build number compared against the running APK's versionCode.
  final int versionCode;

  /// Absolute URL of the APK to download and install.
  final String apkUrl;
}

/// Self-update for the sideloaded Android APK, sourced from the DEV Play store
/// on Cloudflare R2.
///
/// The store publishes `apps/truesize/latest.json` alongside `latest.apk` from
/// the same release, so the manifest and the binary can never drift. On launch
/// and on resume the app fetches that manifest, compares its `versionCode`
/// against the running build number, and - if the store is ahead - drives a
/// forced update that downloads and installs `latest.apk`.
///
/// Only the Android APK self-updates: [check] is a no-op off Android. Every
/// failure path returns null ("fail open") - a missing manifest, a bad response,
/// or an offline device must never lock the user out of the app.
class UpdateService {
  static const _manifestUrl =
      'https://devplay.devsite.ro/dl/apps/truesize/latest.json';
  static const _timeout = Duration(seconds: 5);

  /// Returns update details when the store's build is newer than this one, else
  /// null (including on web/iOS and on any error).
  Future<UpdateInfo?> check() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return null;
    try {
      final info = await PackageInfo.fromPlatform();
      final running = int.tryParse(info.buildNumber) ?? 0;

      // Cache-bust so a CDN edge never hands back a stale manifest.
      final url = Uri.parse('$_manifestUrl?t=${running}_check');
      final res = await http.get(url).timeout(_timeout);
      if (res.statusCode != 200) return null;

      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final latest = (json['versionCode'] as num?)?.toInt();
      if (latest == null || latest <= running) return null;

      // downloadUrl is store-relative (/dl/...); resolve it against the manifest
      // URL so it becomes absolute for the installer.
      final apkUrl = Uri.parse(_manifestUrl)
          .resolve(json['downloadUrl'] as String)
          .toString();
      return UpdateInfo(
        versionName: (json['version'] as String?) ?? '',
        versionCode: latest,
        apkUrl: apkUrl,
      );
    } catch (_) {
      // Fail open - never strand the user because the update check went wrong.
      return null;
    }
  }

  /// Downloads the APK (progress reported via [OtaEvent]) and launches the
  /// Android package-installer intent. `ota_update` bundles its own
  /// FileProvider; the app declares REQUEST_INSTALL_PACKAGES and the user grants
  /// "install unknown apps" for TrueSize once, on first update.
  Stream<OtaEvent> install(String apkUrl) =>
      OtaUpdate().execute(apkUrl, destinationFilename: 'truesize.apk');
}
