import 'package:flutter/material.dart';

/// Returns [c] darkened by [amount] (0..1) in HSL lightness.
Color darken(Color c, [double amount = 0.1]) {
  final hsl = HSLColor.fromColor(c);
  return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
}

/// Returns [c] lightened by [amount] (0..1) in HSL lightness.
Color lighten(Color c, [double amount = 0.1]) {
  final hsl = HSLColor.fromColor(c);
  return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
}

/// The brand gradient derived from a single [primary] seed - used for the
/// hero, the add button, and the logo so they all follow the chosen color.
LinearGradient brandGradient(Color primary) => LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [lighten(primary, 0.06), darken(primary, 0.12)],
    );
