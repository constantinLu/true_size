import 'package:flutter_test/flutter_test.dart';
import 'package:true_size/core/models/measurement_size.dart';
import 'package:true_size/core/models/unit_option.dart';

void main() {
  group('UnitOption.fromStored', () {
    test('a legacy enum-name id resolves to the built-in symbol and label', () {
      final u = UnitOption.fromStored(id: 'cm');
      expect(u.symbol, 'cm');
      expect(u.label, 'Centimeters');
      expect(u.builtIn, isTrue);
    });

    test('an unknown id keeps its denormalized symbol/label (deleted custom unit)', () {
      final u = UnitOption.fromStored(
          id: 'u_123', symbol: 'US', label: 'US shoe size', builtIn: false);
      expect(u.symbol, 'US');
      expect(u.label, 'US shoe size');
      expect(u.builtIn, isFalse);
    });

    test('an unknown id with nothing stored falls back to the id', () {
      final u = UnitOption.fromStored(id: 'u_999');
      expect(u.symbol, '');
      expect(u.label, 'u_999');
      expect(u.builtIn, isFalse);
    });
  });

  group('MeasurementSize serialization', () {
    test('a custom-unit reading round-trips without needing the catalogue', () {
      const size = MeasurementSize(
        value: '42',
        unit: UnitOption(
            id: 'u_1', label: 'US shoe size', symbol: 'US', builtIn: false),
      );
      final restored = MeasurementSize.fromMap(size.toMap());
      expect(restored.value, '42');
      expect(restored.unit.symbol, 'US');
      expect(restored.unit.label, 'US shoe size');
      expect(restored.unit.builtIn, isFalse);
      expect(restored.label, '42 US');
    });

    test('a legacy map with only the enum name still reads correctly', () {
      final restored = MeasurementSize.fromMap({'value': '40', 'unit': 'shoeSize'});
      expect(restored.unit.symbol, 'EU');
      expect(restored.unit.builtIn, isTrue);
    });
  });
}
