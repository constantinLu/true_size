enum MeasurementType {
  shoes('shoes', '👟', 'Shoes'),
  body('body', '👕', 'Body Measurements'),
  jeans('jeans', '👖', 'Jeans'),
  underwear('underwear', '🩲', 'Underwear'),
  bedding('bedding', '🛏️', 'Bedding'),
  glasses('glasses', '👓', 'Glasses'),
  bike('bike', '🚴', 'Bicycle'),
  custom('custom', '📏', 'Custom');

  const MeasurementType(this.value, this.icon, this.displayName);

  final String value;
  final String icon;
  final String displayName;

  static MeasurementType fromString(String value) {
    return MeasurementType.values.firstWhere(
          (type) => type.value == value,
      orElse: () => MeasurementType.custom,
    );
  }
}