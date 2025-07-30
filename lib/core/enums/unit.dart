enum Unit {
  // Metric Length
  m,
  cm,
  mm,

  // Metric Volume
  lt,
  ml,

  // Metric Weight
  kg,
  g,

  // Imperial Length
  inch,
  ft,
  yd,

  // Imperial Volume
  gal,
  fl_oz,

  // Imperial Weight
  lb,
  oz;

  // Display name for UI
  String get displayName {
    switch (this) {
      // Metric Length
      case Unit.m:
        return 'Meters';
      case Unit.cm:
        return 'Centimeters';
      case Unit.mm:
        return 'Millimeters';

      // Metric Volume
      case Unit.lt:
        return 'Liters';
      case Unit.ml:
        return 'Milliliters';

      // Metric Weight
      case Unit.kg:
        return 'Kilograms';
      case Unit.g:
        return 'Grams';

      // Imperial Length
      case Unit.inch:
        return 'Inches';
      case Unit.ft:
        return 'Feet';
      case Unit.yd:
        return 'Yards';

      // Imperial Volume
      case Unit.gal:
        return 'Gallons';
      case Unit.fl_oz:
        return 'Fluid Ounces';

      // Imperial Weight
      case Unit.lb:
        return 'Pounds';
      case Unit.oz:
        return 'Ounces';
    }
  }

  // Short abbreviation
  String get symbol {
    switch (this) {
      // Metric Length
      case Unit.m:
        return 'm';
      case Unit.cm:
        return 'cm';
      case Unit.mm:
        return 'mm';

      // Metric Volume
      case Unit.lt:
        return 'L';
      case Unit.ml:
        return 'mL';

      // Metric Weight
      case Unit.kg:
        return 'kg';
      case Unit.g:
        return 'g';

      // Imperial Length
      case Unit.inch:
        return 'in';
      case Unit.ft:
        return 'ft';
      case Unit.yd:
        return 'yd';

      // Imperial Volume
      case Unit.gal:
        return 'gal';
      case Unit.fl_oz:
        return 'fl oz';

      // Imperial Weight
      case Unit.lb:
        return 'lb';
      case Unit.oz:
        return 'oz';
    }
  }

  // Unit type
  UnitType get type {
    switch (this) {
      case Unit.m:
      case Unit.cm:
      case Unit.mm:
      case Unit.inch:
      case Unit.ft:
      case Unit.yd:
        return UnitType.length;

      case Unit.lt:
      case Unit.ml:
      case Unit.gal:
      case Unit.fl_oz:
        return UnitType.volume;

      case Unit.kg:
      case Unit.g:
      case Unit.lb:
      case Unit.oz:
        return UnitType.weight;
    }
  }

  // Unit system
  UnitSystem get system {
    switch (this) {
      case Unit.m:
      case Unit.cm:
      case Unit.mm:
      case Unit.lt:
      case Unit.ml:
      case Unit.kg:
      case Unit.g:
        return UnitSystem.metric;

      case Unit.inch:
      case Unit.ft:
      case Unit.yd:
      case Unit.gal:
      case Unit.fl_oz:
      case Unit.lb:
      case Unit.oz:
        return UnitSystem.imperial;
    }
  }

  // Convert from string
  static Unit? fromString(String unitString) {
    final normalizedString = unitString.toLowerCase().trim();

    for (Unit unit in Unit.values) {
      if (unit.name.toLowerCase() == normalizedString ||
          unit.symbol.toLowerCase() == normalizedString ||
          unit.displayName.toLowerCase() == normalizedString) {
        return unit;
      }
    }
    return null;
  }

  // Check if this is metric
  bool get isMetric => system == UnitSystem.metric;

  // Check if this is imperial
  bool get isImperial => system == UnitSystem.imperial;

  // Format value with unit
  String formatValue(double value, {int decimals = 1}) {
    return '${value.toStringAsFixed(decimals)} ${symbol}';
  }
}

// Supporting enums
enum UnitType {
  length,
  volume,
  weight;

  String get displayName {
    switch (this) {
      case UnitType.length:
        return 'Length';
      case UnitType.volume:
        return 'Volume';
      case UnitType.weight:
        return 'Weight';
    }
  }
}

enum UnitSystem {
  metric,
  imperial;

  String get displayName {
    switch (this) {
      case UnitSystem.metric:
        return 'Metric';
      case UnitSystem.imperial:
        return 'Imperial';
    }
  }
}

// Helper methods to get units by type or system
extension UnitFilters on List<Unit> {
  List<Unit> byType(UnitType type) {
    return where((unit) => unit.type == type).toList();
  }

  List<Unit> bySystem(UnitSystem system) {
    return where((unit) => unit.system == system).toList();
  }

  List<Unit> get lengthUnits => byType(UnitType.length);
  List<Unit> get volumeUnits => byType(UnitType.volume);
  List<Unit> get weightUnits => byType(UnitType.weight);
  List<Unit> get metricUnits => bySystem(UnitSystem.metric);
  List<Unit> get imperialUnits => bySystem(UnitSystem.imperial);
}

// Usage examples
void main() {
  // Basic usage
  Unit unit = Unit.cm;
  print('Unit: ${unit.displayName}'); // Unit: Centimeters
  print('Symbol: ${unit.symbol}'); // Symbol: cm
  print('System: ${unit.system.displayName}'); // System: Metric
  print('Type: ${unit.type.displayName}'); // Type: Length

  // Format value
  print('Formatted: ${unit.formatValue(150.5)}'); // Formatted: 150.5 cm

  // Get units by category
  List<Unit> lengthUnits = Unit.values.lengthUnits;
  print('Length units: ${lengthUnits.map((u) => u.symbol).join(', ')}');
  // Length units: m, cm, mm, in, ft, yd

  List<Unit> metricUnits = Unit.values.metricUnits;
  print('Metric units: ${metricUnits.map((u) => u.symbol).join(', ')}');
  // Metric units: m, cm, mm, L, mL, kg, g

  // Parse from string
  Unit? parsed = Unit.fromString('cm');
  print('Parsed: ${parsed?.displayName}'); // Parsed: Centimeters

  // Check system
  print('Is metric: ${unit.isMetric}'); // Is metric: true
  print('Is imperial: ${unit.isImperial}'); // Is imperial: false
}
