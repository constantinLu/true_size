/// Body silhouette shown on the Body-measurements tab.
enum Gender {
  male,
  female;

  String get label => this == Gender.male ? 'Male' : 'Female';

  /// Folder + filename-prefix for this gender's bundled body assets, e.g.
  /// `assets/body/male/m_*.png` and `assets/body/female/f_*.png`.
  String get _dir => this == Gender.male ? 'male' : 'female';
  String get _prefix => this == Gender.male ? 'm' : 'f';

  /// The bundled silhouette asset for this gender.
  String get silhouetteAsset => 'assets/body/$_dir/$_dir.png';

  /// The bundled illustration for a body part, e.g. `partAsset('bicep_left')`
  /// resolves to `assets/body/female/f_bicep_left.png` for [Gender.female].
  String partAsset(String partKey) => 'assets/body/$_dir/${_prefix}_$partKey.png';

  /// Display width / height of the silhouette image (matches the cropped PNG so
  /// it renders without distortion and marker positions stay consistent).
  double get silhouetteAspect => this == Gender.male ? 0.531 : 0.667;
}
