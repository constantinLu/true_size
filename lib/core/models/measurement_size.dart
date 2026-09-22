import 'unit_option.dart';

/// A single size reading for a measurement: a [value] in a given [unit].
/// A measurement can hold several of these - e.g. a shoe recorded as both
/// `42 EU` and `25.5 cm`.
class MeasurementSize {
  const MeasurementSize({required this.value, required this.unit});

  final String value;
  final UnitOption unit;

  /// Compact label, e.g. `42 EU` or `25.5 cm`.
  String get label => '$value ${unit.symbol}';

  double? get numericValue => double.tryParse(value);

  /// The unit is denormalized onto the reading (id + symbol + label) so a
  /// custom unit that is later deleted still renders, and built-in/legacy data
  /// (which stored only the enum name in `unit`) keeps working.
  Map<String, dynamic> toMap() => {
        'value': value,
        'unit': unit.id,
        'unitSymbol': unit.symbol,
        'unitLabel': unit.label,
        'unitBuiltIn': unit.builtIn,
      };

  factory MeasurementSize.fromMap(Map<String, dynamic> map) {
    return MeasurementSize(
      value: (map['value'] ?? '').toString(),
      unit: UnitOption.fromStored(
        id: (map['unit'] ?? 'shoeSize').toString(),
        symbol: map['unitSymbol'] as String?,
        label: map['unitLabel'] as String?,
        builtIn: map['unitBuiltIn'] as bool?,
      ),
    );
  }

  MeasurementSize copyWith({String? value, UnitOption? unit}) =>
      MeasurementSize(value: value ?? this.value, unit: unit ?? this.unit);
}
