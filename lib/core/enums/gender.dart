/// Body silhouette shown on the Body-measurements tab.
enum Gender {
  male,
  female;

  String get label => this == Gender.male ? 'Male' : 'Female';

  /// The bundled silhouette asset for this gender.
  String get silhouetteAsset =>
      this == Gender.male ? 'assets/body/male.png' : 'assets/body/female.png';

  /// Display width / height of the silhouette image (matches the cropped PNG so
  /// it renders without distortion and marker positions stay consistent).
  double get silhouetteAspect => this == Gender.male ? 0.531 : 0.667;
}
