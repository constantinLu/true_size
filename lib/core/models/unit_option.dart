import '../enums/unit.dart';
import 'custom_unit.dart';

/// A pickable unit - either one of the built-in [Unit] enum values or a
/// user-created [CustomUnit]. This is the single currency the unit picker and
/// [MeasurementSize] deal in, so built-in and custom units are treated
/// uniformly. Equality is by [id] so it plugs straight into the selection sheet.
class UnitOption {
  const UnitOption({
    required this.id,
    required this.label,
    required this.symbol,
    required this.builtIn,
  });

  /// Stable identity: the [Unit] enum name for built-ins (e.g. `cm`), or the
  /// Firestore document id for custom units.
  final String id;

  /// Full display name, e.g. `Centimeters` or `US shoe size`.
  final String label;

  /// Short symbol shown on the size row, e.g. `cm` or `US` (may be empty).
  final String symbol;

  /// True for the fixed built-in catalogue (not deletable); false for
  /// user-created units (deletable from the picker).
  final bool builtIn;

  factory UnitOption.fromBuiltin(Unit u) => UnitOption(
        id: u.name,
        label: u.displayName,
        symbol: u.symbol,
        builtIn: true,
      );

  factory UnitOption.fromCustom(CustomUnit c) => UnitOption(
        id: c.id,
        label: c.name,
        symbol: c.symbol,
        builtIn: false,
      );

  /// Rebuilds a unit from a stored [MeasurementSize]. Prefers the denormalized
  /// [symbol]/[label]/[builtIn] persisted on the reading, falling back to the
  /// built-in catalogue by [id]. This keeps legacy data (which stored only the
  /// enum name) and readings whose custom unit was later deleted rendering
  /// correctly.
  factory UnitOption.fromStored({
    required String id,
    String? symbol,
    String? label,
    bool? builtIn,
  }) {
    final builtin = _builtinById(id);
    return UnitOption(
      id: id,
      symbol: symbol ?? builtin?.symbol ?? '',
      label: label ?? builtin?.displayName ?? id,
      builtIn: builtIn ?? (builtin != null),
    );
  }

  static Unit? _builtinById(String id) {
    for (final u in Unit.values) {
      if (u.name == id) return u;
    }
    return null;
  }

  /// What to show when space is tight: the symbol, or the label when the unit
  /// has no symbol (e.g. clothing sizes).
  String get shortLabel => symbol.isEmpty ? label : symbol;

  @override
  bool operator ==(Object other) => other is UnitOption && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
