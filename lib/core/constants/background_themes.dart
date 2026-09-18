/// A selectable wallpaper the user can set as the app background. Each theme is
/// a bundled measurement / manufacturing themed vector; the special
/// [BackgroundThemes.none] entry means "no wallpaper" and restores the app's
/// plain solid surfaces.
///
/// On the dashboard the [asset] is shown sharp at the top and fades into the
/// dark background as you scroll; on every other screen it is blurred and
/// darkened behind the content (see the rendering in the UI layer).
class BackgroundTheme {
  const BackgroundTheme({required this.id, required this.name, required this.asset});

  /// Stable identifier persisted to Firestore (`settings/app.backgroundTheme`).
  final String id;

  /// Human label shown under the thumbnail in Settings.
  final String name;

  /// Bundled asset path, or empty for [BackgroundThemes.none].
  final String asset;

  bool get isNone => asset.isEmpty;

  /// True when [asset] is a vector (.svg) and must be drawn with flutter_svg
  /// rather than [Image.asset]. See [BackgroundImage].
  bool get isVector => asset.toLowerCase().endsWith('.svg');
}

/// The catalogue of background themes offered in Settings. Deliberately
/// measurement / making themed (blueprints, graph paper, tailoring, workshop)
/// rather than landscapes. Order here is the order shown, with [none] first.
class BackgroundThemes {
  BackgroundThemes._();

  static const none = BackgroundTheme(id: 'none', name: 'None', asset: '');

  static const blueprint =
      BackgroundTheme(id: 'blueprint', name: 'Blueprint', asset: 'assets/backgrounds/blueprint.svg');
  static const graph =
      BackgroundTheme(id: 'graph', name: 'Graph Paper', asset: 'assets/backgrounds/graph.svg');
  static const tailor =
      BackgroundTheme(id: 'tailor', name: 'Tailor', asset: 'assets/backgrounds/tailor.svg');
  static const atelier =
      BackgroundTheme(id: 'atelier', name: 'Atelier', asset: 'assets/backgrounds/atelier.svg');
  static const workshop =
      BackgroundTheme(id: 'workshop', name: 'Workshop', asset: 'assets/backgrounds/workshop.svg');
  static const millimeter =
      BackgroundTheme(id: 'millimeter', name: 'Millimeter', asset: 'assets/backgrounds/millimeter.svg');

  /// All themes in display order (none first, as the default).
  static const all = <BackgroundTheme>[
    none,
    blueprint,
    graph,
    tailor,
    atelier,
    workshop,
    millimeter,
  ];

  /// Resolves a persisted [id] back to its theme, or [none] when unknown/null.
  static BackgroundTheme byId(String? id) =>
      all.firstWhere((t) => t.id == id, orElse: () => none);
}
