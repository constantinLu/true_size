/// Body silhouette shown on the Body-measurements tab.
enum Gender {
  male,
  female;

  String get label => this == Gender.male ? 'Male' : 'Female';

  /// The bundled silhouette asset for this gender.
  String get silhouetteAsset =>
      this == Gender.male ? 'assets/body/male.svg' : 'assets/body/female.svg';
}
