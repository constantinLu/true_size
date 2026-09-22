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
    required this.howTo,
    required this.male,
    required this.female,
    required this.min,
    required this.max,
    required this.initial,
    this.unit = 'cm',
  });

  final String key;
  final String label;

  /// A short, consistent instruction for how to take this measurement, shown in
  /// the "How to measure" section of the detail view.
  final String howTo;

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
        howTo: 'Wrap the tape around the widest part of your head, about a finger above the eyebrows and ears.',
        male: (0.56, 0.055), female: (0.50, 0.055), min: 48, max: 66, initial: 56),
    BodyPart(key: 'neck', label: 'Neck',
        howTo: 'Measure around the base of the neck where a shirt collar sits, keeping one finger under the tape.',
        male: (0.56, 0.125), female: (0.50, 0.125), min: 28, max: 52, initial: 38),
    BodyPart(key: 'shoulder', label: 'Shoulders',
        howTo: 'Measure across the back from the bony tip of one shoulder to the tip of the other.',
        male: (0.56, 0.190), female: (0.50, 0.185), min: 34, max: 62, initial: 46),
    BodyPart(key: 'chest', label: 'Chest',
        howTo: 'Wrap the tape around the fullest part of the chest, under the armpits, keeping it level.',
        male: (0.56, 0.270), female: (0.50, 0.265), min: 70, max: 140, initial: 96),
    BodyPart(key: 'bicep_left', label: 'Left bicep',
        howTo: 'Relax your left arm at your side and measure around the fullest part of the upper arm.',
        male: (0.37, 0.300), female: (0.38, 0.305), min: 20, max: 52, initial: 32),
    BodyPart(key: 'bicep_right', label: 'Right bicep',
        howTo: 'Relax your right arm at your side and measure around the fullest part of the upper arm.',
        male: (0.63, 0.300), female: (0.62, 0.305), min: 20, max: 52, initial: 32),
    BodyPart(key: 'forearm_left', label: 'Left forearm',
        howTo: 'Measure around the widest part of the left forearm, just below the elbow.',
        male: (0.31, 0.430), female: (0.33, 0.435), min: 18, max: 40, initial: 27),
    BodyPart(key: 'forearm_right', label: 'Right forearm',
        howTo: 'Measure around the widest part of the right forearm, just below the elbow.',
        male: (0.69, 0.430), female: (0.67, 0.435), min: 18, max: 40, initial: 27),
    BodyPart(key: 'waist', label: 'Waist',
        howTo: 'Measure around your natural waist, the narrowest point above the belly button, without pulling tight.',
        male: (0.56, 0.400), female: (0.50, 0.410), min: 58, max: 130, initial: 82),
    BodyPart(key: 'hips', label: 'Hips',
        howTo: 'Measure around the fullest part of the hips and seat, keeping the tape level.',
        male: (0.56, 0.455), female: (0.50, 0.465), min: 70, max: 140, initial: 96),
    BodyPart(key: 'inseam', label: 'Inseam',
        howTo: 'Measure along the inner leg from the crotch straight down to the ankle bone.',
        male: (0.56, 0.600), female: (0.50, 0.600), min: 60, max: 100, initial: 82),
    BodyPart(key: 'thigh_left', label: 'Left thigh',
        howTo: 'Measure around the fullest part of the left thigh, just below the buttock.',
        male: (0.45, 0.630), female: (0.42, 0.620), min: 38, max: 80, initial: 55),
    BodyPart(key: 'thigh_right', label: 'Right thigh',
        howTo: 'Measure around the fullest part of the right thigh, just below the buttock.',
        male: (0.67, 0.630), female: (0.58, 0.620), min: 38, max: 80, initial: 55),
    BodyPart(key: 'calf_left', label: 'Left calf',
        howTo: 'Measure around the widest part of the left calf.',
        male: (0.43, 0.820), female: (0.42, 0.820), min: 25, max: 55, initial: 38),
    BodyPart(key: 'calf_right', label: 'Right calf',
        howTo: 'Measure around the widest part of the right calf.',
        male: (0.69, 0.820), female: (0.58, 0.820), min: 25, max: 55, initial: 38),
  ];

  static BodyPart? byKey(String key) {
    for (final p in all) {
      if (p.key == key) return p;
    }
    return null;
  }
}
