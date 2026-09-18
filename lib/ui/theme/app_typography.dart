import 'package:flutter/material.dart';

/// Global typography scale for Wadger.
///
/// A single source of truth for every text style in the app, modelled on the
/// Revolut type system (role → weight → size) but set in **Office Code Pro**
/// instead of Aeonik. Use the named roles directly in widgets, e.g.
///
/// ```dart
/// Text('Netflix', style: AppTypography.listItemTitle.copyWith(color: context.neutrals.textPrimary))
/// ```
///
/// The styles are colour-agnostic on purpose: pick the colour at the call site
/// from `context.neutrals` so the same role works in light and dark themes. The
/// Material [TextTheme] is also derived from these roles (see [buildTextTheme])
/// so `Theme.of(context).textTheme.*` stays in sync.
class AppTypography {
  AppTypography._();

  /// The one and only typeface. There is no fallback: the app requires the
  /// Office Code Pro `.ttf` files to be bundled (loaded and verified at startup
  /// in `main`), and fails fast if they are missing.
  static const String fontFamily = 'Office Code Pro';

  // ----- Weights (Revolut usage) -----
  /// Normal text, descriptions, subtitles, captions.
  static const FontWeight regular = FontWeight.w400;

  /// Headings, balances, buttons, navigation and important values.
  static const FontWeight medium = FontWeight.w500;

  /// Occasional stronger emphasis.
  static const FontWeight semibold = FontWeight.w600;

  /// Rarely used - prefer a larger size over heavier weight.
  static const FontWeight bold = FontWeight.w700;

  static TextStyle _style(double size, FontWeight weight, {double spacing = 0, double? height}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: size,
        fontWeight: weight,
        letterSpacing: spacing,
        height: height,
      );

  // ----- Roles (role · weight · size, from the Revolut scale) -----

  /// Hero balance - the single largest number in the app (the dashboard net
  /// balance). Above the documented scale; a deliberate display size.
  static TextStyle get displayBalance => _style(46, bold, spacing: -1.5, height: 1.0);

  /// Large amount entry - the centred numeric input on the add-entry flows.
  static TextStyle get amountInput => _style(44, bold, spacing: -1.5);

  /// Compact amount entry - secondary numeric inputs (e.g. per-currency stock
  /// balances) that sit inline rather than as the screen's hero figure.
  static TextStyle get amountInputCompact => _style(20, semibold, spacing: -0.3);

  /// Large balance - Medium 500, 32-40 sp.
  static TextStyle get largeBalance => _style(34, medium, spacing: -0.5, height: 1.05);

  /// Large page title - Medium 500, 28-32 sp.
  static TextStyle get largePageTitle => _style(30, medium, spacing: -0.5, height: 1.1);

  /// Section / page heading - Medium 500, 22-24 sp.
  static TextStyle get sectionHeading => _style(23, medium, spacing: -0.3, height: 1.15);

  /// Modal / sheet title - Medium 500, 20-22 sp.
  static TextStyle get modalTitle => _style(21, medium, spacing: -0.3, height: 1.15);

  /// Card title - Medium 500, 17-18 sp.
  static TextStyle get cardTitle => _style(18, medium, height: 1.2);

  /// List-item title - Medium 500, 16-17 sp.
  static TextStyle get listItemTitle => _style(16, medium, height: 1.2);

  /// Body text - Regular 400, 15-17 sp.
  static TextStyle get body => _style(16, regular, height: 1.35);

  /// Subtitle / secondary text - Regular 400, 14-15 sp.
  static TextStyle get subtitle => _style(14, regular, height: 1.3);

  /// Button text - Medium 500, 15-17 sp.
  static TextStyle get button => _style(16, medium);

  /// Tab / navigation label - Medium 500, 12-13 sp.
  static TextStyle get tabLabel => _style(12, medium);

  /// Caption / helper text - Regular 400, 12-13 sp.
  static TextStyle get caption => _style(12, regular, height: 1.3);

  /// Badge / chip label - Medium 500, 11-13 sp.
  static TextStyle get badge => _style(12, medium, spacing: 0.2);

  /// Transaction amount - Medium 500, 15-17 sp.
  static TextStyle get transactionAmount => _style(16, medium);

  /// Small monetary details (exchange rate / converted amount) - Regular 400, 13-14 sp.
  static TextStyle get smallMonetary => _style(13, regular);

  /// Maps the app's typography roles onto the Material [TextTheme] so that
  /// widgets reading `Theme.of(context).textTheme.*` inherit the same scale,
  /// coloured with [textColor].
  static TextTheme buildTextTheme(Color textColor) {
    final theme = TextTheme(
      displayLarge: largeBalance,
      displayMedium: largePageTitle,
      displaySmall: sectionHeading,
      headlineMedium: sectionHeading,
      headlineSmall: modalTitle,
      titleLarge: modalTitle,
      titleMedium: cardTitle,
      titleSmall: listItemTitle,
      bodyLarge: body,
      bodyMedium: subtitle,
      bodySmall: caption,
      labelLarge: button,
      labelMedium: tabLabel,
      labelSmall: badge,
    );
    return theme.apply(
      bodyColor: textColor,
      displayColor: textColor,
      fontFamily: fontFamily,
    );
  }
}
