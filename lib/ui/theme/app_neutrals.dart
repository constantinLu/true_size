import 'package:flutter/material.dart';

/// Theme-dependent surface & text colors. Accent/category colors live in
/// [AppColors] because they are identical in light and dark; only these
/// neutral tones flip between themes. Registered as a [ThemeExtension] so it
/// is read via `context.neutrals` and lerps smoothly on theme change.
@immutable
class AppNeutrals extends ThemeExtension<AppNeutrals> {
  const AppNeutrals({
    required this.background,
    required this.surface,
    required this.surfaceHigh,
    required this.stroke,
    required this.textPrimary,
    required this.textSecondary,
    required this.textFaint,
  });

  final Color background;
  final Color surface;
  final Color surfaceHigh;

  /// Hairline border for cards, fields and dividers. Deliberately set to the
  /// same value as [surface] so borders blend into the card and read as
  /// seamless rather than outlined. Elements that need to stay visible (e.g.
  /// bottom-sheet grab handles, the stock timeline spine) use [surfaceHigh].
  final Color stroke;
  final Color textPrimary;
  final Color textSecondary;
  final Color textFaint;

  static const dark = AppNeutrals(
    background: Color(0xFF0A0B0D),
    surface: Color(0xFF161719),
    surfaceHigh: Color(0xFF202124),
    stroke: Color(0xFF161719), // == surface: borders blend into the card

    textPrimary: Color(0xFFFFFFFF),
    // Brightened for legibility over translucent cards on busy wallpapers.
    textSecondary: Color(0xFFB6BAC3),
    textFaint: Color(0xFF8F949E),
  );

  static const light = AppNeutrals(
    background: Color(0xFFF5F5F7),
    surface: Color(0xFFFFFFFF),
    surfaceHigh: Color(0xFFEFEFF3),
    stroke: Color(0xFFFFFFFF), // == surface: borders blend into the card

    textPrimary: Color(0xFF12131A),
    textSecondary: Color(0xFF6A6F7A),
    textFaint: Color(0xFF868B95),
  );

  @override
  AppNeutrals copyWith({
    Color? background,
    Color? surface,
    Color? surfaceHigh,
    Color? stroke,
    Color? textPrimary,
    Color? textSecondary,
    Color? textFaint,
  }) {
    return AppNeutrals(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceHigh: surfaceHigh ?? this.surfaceHigh,
      stroke: stroke ?? this.stroke,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textFaint: textFaint ?? this.textFaint,
    );
  }

  @override
  AppNeutrals lerp(ThemeExtension<AppNeutrals>? other, double t) {
    if (other is! AppNeutrals) return this;
    return AppNeutrals(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceHigh: Color.lerp(surfaceHigh, other.surfaceHigh, t)!,
      stroke: Color.lerp(stroke, other.stroke, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textFaint: Color.lerp(textFaint, other.textFaint, t)!,
    );
  }
}

extension AppNeutralsX on BuildContext {
  /// Shorthand for the current theme's Wadger surface/text colors.
  AppNeutrals get neutrals => Theme.of(this).extension<AppNeutrals>() ?? AppNeutrals.dark;
}
