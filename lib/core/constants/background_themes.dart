/// A selectable wallpaper the user can set as the app background. Each theme is
/// a bundled landscape image; the special [BackgroundThemes.none] entry means
/// "no wallpaper" and restores the app's plain solid surfaces.
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

/// The catalogue of background themes offered in Settings. Order here is the
/// order shown to the user, with [none] first as the default.
class BackgroundThemes {
  BackgroundThemes._();

  static const none = BackgroundTheme(id: 'none', name: 'None', asset: '');

  // ----- Photographic (raster) wallpapers -----
  static const moonlitStag =
      BackgroundTheme(id: 'moonlit_stag', name: 'Moonlit Stag', asset: 'assets/backgrounds/moonlit_stag.jpg');
  static const forest =
      BackgroundTheme(id: 'forest', name: 'Forest', asset: 'assets/backgrounds/forest.jpg');
  static const foggyMountains =
      BackgroundTheme(id: 'foggy_mountains', name: 'Foggy Mountains', asset: 'assets/backgrounds/foggy_mountains.jpg');
  static const foggy =
      BackgroundTheme(id: 'foggy', name: 'Foggy', asset: 'assets/backgrounds/foggy.jpg');
  static const waterMountains =
      BackgroundTheme(id: 'water_mountains', name: 'Water Mountains', asset: 'assets/backgrounds/water-mountains.jpg');
  static const boatWater =
      BackgroundTheme(id: 'boat_water', name: 'Boat Water', asset: 'assets/backgrounds/boat_water.jpg');
  static const japan =
      BackgroundTheme(id: 'japan', name: 'Japan', asset: 'assets/backgrounds/japan.jpg');
  static const colourful =
      BackgroundTheme(id: 'colourful', name: 'Colourful', asset: 'assets/backgrounds/colourful.jpg');
  static const starryNight =
      BackgroundTheme(id: 'starry_night', name: 'Starry Night', asset: 'assets/backgrounds/starry_night.jpg');
  static const darkDusk =
      BackgroundTheme(id: 'dark_dusk', name: 'Dark Dusk', asset: 'assets/backgrounds/dark_dusk.jpg');
  static const mistySunset =
      BackgroundTheme(id: 'misty_sunset', name: 'Misty Sunset', asset: 'assets/backgrounds/misty_sunset.jpg');
  static const violetHills =
      BackgroundTheme(id: 'violet_hills', name: 'Violet Hills', asset: 'assets/backgrounds/violet_hills.jpg');
  static const pastelSunrise =
      BackgroundTheme(id: 'pastel_sunrise', name: 'Pastel Sunrise', asset: 'assets/backgrounds/pastel_sunrise.jpg');

  // ----- Vector (SVG) gradient wallpapers -----
  static const midnightIndigo =
      BackgroundTheme(id: 'midnight_indigo', name: 'Midnight Indigo', asset: 'assets/backgrounds/midnight-indigo.svg');
  static const tealTwilight =
      BackgroundTheme(id: 'teal_twilight', name: 'Teal Twilight', asset: 'assets/backgrounds/teal-twilight.svg');
  static const amberDawn =
      BackgroundTheme(id: 'amber_dawn', name: 'Amber Dawn', asset: 'assets/backgrounds/amber-dawn.svg');
  static const coralGlow =
      BackgroundTheme(id: 'coral_glow', name: 'Coral Glow', asset: 'assets/backgrounds/coral-glow.svg');
  static const roseHorizon =
      BackgroundTheme(id: 'rose_horizon', name: 'Rose Horizon', asset: 'assets/backgrounds/rose-horizon.svg');
  static const desertGlow =
      BackgroundTheme(id: 'desert_glow', name: 'Desert Glow', asset: 'assets/backgrounds/desert-glow.svg');
  static const autumnRidge =
      BackgroundTheme(id: 'autumn_ridge', name: 'Autumn Ridge', asset: 'assets/backgrounds/autumn-ridge.svg');
  static const forestMist =
      BackgroundTheme(id: 'forest_mist', name: 'Forest Mist', asset: 'assets/backgrounds/forest-mist.svg');
  static const sageHollow =
      BackgroundTheme(id: 'sage_hollow', name: 'Sage Hollow', asset: 'assets/backgrounds/sage-hollow.svg');
  static const seaHorizon =
      BackgroundTheme(id: 'sea_horizon', name: 'Sea Horizon', asset: 'assets/backgrounds/sea-horizon.svg');
  static const granitePeaks =
      BackgroundTheme(id: 'granite_peaks', name: 'Granite Peaks', asset: 'assets/backgrounds/granite-peaks.svg');
  static const snowfallPeaks =
      BackgroundTheme(id: 'snowfall_peaks', name: 'Snowfall Peaks', asset: 'assets/backgrounds/snowfall-peaks.svg');

  /// All themes in display order (None first, photos, then SVG gradients).
  static const all = <BackgroundTheme>[
    none,
    moonlitStag,
    forest,
    foggyMountains,
    foggy,
    waterMountains,
    boatWater,
    japan,
    colourful,
    starryNight,
    darkDusk,
    mistySunset,
    violetHills,
    pastelSunrise,
    midnightIndigo,
    tealTwilight,
    amberDawn,
    coralGlow,
    roseHorizon,
    desertGlow,
    autumnRidge,
    forestMist,
    sageHollow,
    seaHorizon,
    granitePeaks,
    snowfallPeaks,
  ];

  /// Resolves a persisted [id] back to its theme, falling back to [none] for an
  /// unknown or missing value.
  static BackgroundTheme byId(String? id) =>
      all.firstWhere((t) => t.id == id, orElse: () => none);
}
