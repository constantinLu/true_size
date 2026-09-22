import 'package:flutter_test/flutter_test.dart';
import 'package:true_size/core/enums/gender.dart';
import 'package:true_size/core/models/body_part.dart';

void main() {
  group('BodyPart catalogue', () {
    test('every part resolves by key and exposes a marker per gender', () {
      expect(BodyPart.all, isNotEmpty);
      for (final part in BodyPart.all) {
        expect(BodyPart.byKey(part.key), same(part));
        for (final gender in Gender.values) {
          final (mx, my) = part.markerFor(gender);
          expect(mx, inInclusiveRange(0.0, 1.0));
          expect(my, inInclusiveRange(0.0, 1.0));
        }
      }
    });

    test('byKey returns null for an unknown key', () {
      expect(BodyPart.byKey('not_a_part'), isNull);
    });
  });

  group('Hip marker position', () {
    final hips = BodyPart.byKey('hips')!;
    final waist = BodyPart.byKey('waist')!;
    final inseam = BodyPart.byKey('inseam')!;

    // Guards the fix that lifted the hips marker off the groin: it must sit
    // below the waist and above the inseam/crotch for both silhouettes.
    test('sits between the waist and the inseam for both genders', () {
      for (final gender in Gender.values) {
        final hipY = hips.markerFor(gender).$2;
        expect(hipY, greaterThan(waist.markerFor(gender).$2),
            reason: 'hip marker must be below the waist ($gender)');
        expect(hipY, lessThan(inseam.markerFor(gender).$2),
            reason: 'hip marker must be above the inseam/crotch ($gender)');
      }
    });

    test('is lifted clear of the groin line (y < 0.5)', () {
      expect(hips.male.$2, lessThan(0.5));
      expect(hips.female.$2, lessThan(0.5));
    });
  });
}
