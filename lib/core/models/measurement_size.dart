import '../enums/unit.dart';

/// A single size reading for a measurement: a [value] in a given [unit].
/// A measurement can hold several of these - e.g. a shoe recorded as both
/// `42 EU` and `25.5 cm`.
class MeasurementSize {
  const MeasurementSize({required this.value, required this.unit});

  final String value;
  final Unit unit;

  /// Compact label, e.g. `42 EU` or `25.5 cm`.
  String get label => '$value ${unit.symbol}';

  double? get numericValue => double.tryParse(value);

  Map<String, dynamic> toMap() => {'value': value, 'unit': unit.name};

  factory MeasurementSize.fromMap(Map<String, dynamic> map) {
    return MeasurementSize(
      value: (map['value'] ?? '').toString(),
      unit: Unit.values.firstWhere(
        (u) => u.name == map['unit'],
        orElse: () => Unit.shoeSize,
      ),
    );
  }

  MeasurementSize copyWith({String? value, Unit? unit}) =>
      MeasurementSize(value: value ?? this.value, unit: unit ?? this.unit);
}
