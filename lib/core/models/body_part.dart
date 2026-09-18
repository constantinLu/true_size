import 'package:flutter/material.dart';

/// A predefined body part shown as a card on the Body tab. The catalogue is
/// fixed in code (not stored in Firestore); only the recorded values are
/// persisted (see BodyMeasurement).
class BodyPart {
  const BodyPart({
    required this.key,
    required this.label,
    required this.icon,
    required this.markerX,
    required this.markerY,
    required this.min,
    required this.max,
    required this.initial,
    this.unit = 'cm',
  });

  final String key;
  final String label;
  final IconData icon;

  /// Marker position on the silhouette (0..1 of width / height).
  final double markerX;
  final double markerY;

  /// Slider range and a sensible starting value (cm).
  final double min;
  final double max;
  final double initial;
  final String unit;

  static const List<BodyPart> all = [
    BodyPart(key: 'neck', label: 'Neck', icon: Icons.accessibility_new_rounded,
        markerX: 0.50, markerY: 0.15, min: 28, max: 52, initial: 38),
    BodyPart(key: 'shoulders', label: 'Shoulders', icon: Icons.open_in_full_rounded,
        markerX: 0.50, markerY: 0.22, min: 34, max: 62, initial: 46),
    BodyPart(key: 'chest', label: 'Chest', icon: Icons.favorite_border_rounded,
        markerX: 0.50, markerY: 0.30, min: 70, max: 140, initial: 96),
    BodyPart(key: 'bicep', label: 'Bicep', icon: Icons.fitness_center_rounded,
        markerX: 0.30, markerY: 0.34, min: 20, max: 52, initial: 32),
    BodyPart(key: 'wrist', label: 'Wrist', icon: Icons.watch_rounded,
        markerX: 0.25, markerY: 0.50, min: 12, max: 24, initial: 17),
    BodyPart(key: 'waist', label: 'Waist', icon: Icons.straighten_rounded,
        markerX: 0.50, markerY: 0.42, min: 58, max: 130, initial: 82),
    BodyPart(key: 'hips', label: 'Hips', icon: Icons.crop_square_rounded,
        markerX: 0.50, markerY: 0.50, min: 70, max: 140, initial: 96),
    BodyPart(key: 'inseam', label: 'Inseam', icon: Icons.height_rounded,
        markerX: 0.50, markerY: 0.55, min: 60, max: 100, initial: 82),
    BodyPart(key: 'thigh', label: 'Thigh', icon: Icons.airline_seat_legroom_normal_rounded,
        markerX: 0.42, markerY: 0.64, min: 38, max: 80, initial: 55),
    BodyPart(key: 'calf', label: 'Calf', icon: Icons.directions_walk_rounded,
        markerX: 0.42, markerY: 0.82, min: 25, max: 55, initial: 38),
  ];

  static BodyPart? byKey(String key) {
    for (final p in all) {
      if (p.key == key) return p;
    }
    return null;
  }
}
