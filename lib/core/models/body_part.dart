import '../enums/gender.dart';

/// A predefined body part shown as a card on the Body tab. The catalogue is
/// fixed in code (not stored in Firestore); only the recorded values are
/// persisted (see BodyMeasurement).
///
/// [key] doubles as the illustration asset name: the bundled PNG for each part
/// is `assets/body/<gender>/<prefix>_<key>.png` (see [Gender.partAsset]). The
/// catalogue is ordered anatomically, head to feet.
class BodyPart {
  const BodyPart({
    required this.key,
    required this.label,
    required this.male,
    required this.female,
    required this.min,
    required this.max,
    required this.initial,
    this.unit = 'cm',
  });

  final String key;
  final String label;

  /// Marker position (x, y) as a 0..1 fraction of the silhouette box, tuned per
  /// gender because the male and female PNGs differ in proportion and centring.
  final (double, double) male;
  final (double, double) female;

  /// Slider range and a sensible starting value (cm).
  final double min;
  final double max;
  final double initial;
  final String unit;

  /// The marker position for [gender].
  (double, double) markerFor(Gender gender) =>
      gender == Gender.male ? male : female;

  static const List<BodyPart> all = [
    BodyPart(key: 'head', label: 'Head',
        male: (0.56, 0.055), female: (0.50, 0.055), min: 48, max: 66, initial: 56),
    BodyPart(key: 'neck', label: 'Neck',
        male: (0.56, 0.125), female: (0.50, 0.125), min: 28, max: 52, initial: 38),
    BodyPart(key: 'shoulder', label: 'Shoulders',
        male: (0.56, 0.190), female: (0.50, 0.185), min: 34, max: 62, initial: 46),
    BodyPart(key: 'chest', label: 'Chest',
        male: (0.56, 0.270), female: (0.50, 0.265), min: 70, max: 140, initial: 96),
    BodyPart(key: 'bicep_left', label: 'Left bicep',
        male: (0.32, 0.300), female: (0.35, 0.305), min: 20, max: 52, initial: 32),
    BodyPart(key: 'bicep_right', label: 'Right bicep',
        male: (0.79, 0.300), female: (0.65, 0.305), min: 20, max: 52, initial: 32),
    BodyPart(key: 'forearm_left', label: 'Left forearm',
        male: (0.27, 0.430), female: (0.30, 0.435), min: 18, max: 40, initial: 27),
    BodyPart(key: 'forearm_right', label: 'Right forearm',
        male: (0.84, 0.430), female: (0.70, 0.435), min: 18, max: 40, initial: 27),
    BodyPart(key: 'waist', label: 'Waist',
        male: (0.56, 0.400), female: (0.50, 0.410), min: 58, max: 130, initial: 82),
    BodyPart(key: 'hips', label: 'Hips',
        male: (0.56, 0.500), female: (0.50, 0.510), min: 70, max: 140, initial: 96),
    BodyPart(key: 'inseam', label: 'Inseam',
        male: (0.56, 0.600), female: (0.50, 0.600), min: 60, max: 100, initial: 82),
    BodyPart(key: 'thigh_left', label: 'Left thigh',
        male: (0.45, 0.630), female: (0.42, 0.620), min: 38, max: 80, initial: 55),
    BodyPart(key: 'thigh_right', label: 'Right thigh',
        male: (0.67, 0.630), female: (0.58, 0.620), min: 38, max: 80, initial: 55),
    BodyPart(key: 'calf_left', label: 'Left calf',
        male: (0.43, 0.820), female: (0.42, 0.820), min: 25, max: 55, initial: 38),
    BodyPart(key: 'calf_right', label: 'Right calf',
        male: (0.69, 0.820), female: (0.58, 0.820), min: 25, max: 55, initial: 38),
  ];

  static BodyPart? byKey(String key) {
    for (final p in all) {
      if (p.key == key) return p;
    }
    return null;
  }
}
