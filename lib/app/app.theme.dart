import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Custom colors from your Material Theme Builder export
  static const Color primaryLight = Color(0xFF496268);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color primaryContainerLight = Color(0xFFC4DFE6);
  static const Color onPrimaryContainerLight = Color(0xFF4A6369);

  static const Color secondaryLight = Color(0xFF23676F);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color secondaryContainerLight = Color(0xFF66A5AD);
  static const Color onSecondaryContainerLight = Color(0xFF00393E);

  static const Color tertiaryLight = Color(0xFF5D5E60);
  static const Color onTertiaryLight = Color(0xFFFFFFFF);
  static const Color tertiaryContainerLight = Color(0xFFF1F1F2);
  static const Color onTertiaryContainerLight = Color(0xFF6C6D6F);

  static const Color surfaceLight = Color(0xFFFAF9F9);
  static const Color onSurfaceLight = Color(0xFF1A1C1C);
  static const Color surfaceContainerLight = Color(0xFFEFEDED);

  // Dark theme colors
  static const Color primaryDark = Color(0xFFE8FAFF);
  static const Color onPrimaryDark = Color(0xFF1B343A);
  static const Color primaryContainerDark = Color(0xFFC4DFE6);
  static const Color onPrimaryContainerDark = Color(0xFF4A6369);

  static const Color secondaryDark = Color(0xFF92D1D9);
  static const Color onSecondaryDark = Color(0xFF00363B);
  static const Color secondaryContainerDark = Color(0xFF66A5AD);
  static const Color onSecondaryContainerDark = Color(0xFF00393E);

  static const Color tertiaryDark = Color(0xFFFFFFFF);
  static const Color onTertiaryDark = Color(0xFF2F3132);
  static const Color tertiaryContainerDark = Color(0xFFE2E2E3);
  static const Color onTertiaryContainerDark = Color(0xFF636466);

  static const Color surfaceDark = Color(0xFF121414);
  static const Color onSurfaceDark = Color(0xFFE3E2E2);
  static const Color surfaceContainerDark = Color(0xFF1F2020);

  static TextTheme createTextTheme(BuildContext context, String bodyFontString, String displayFontString) {
    TextTheme baseTextTheme = Theme.of(context).textTheme;
    TextTheme bodyTextTheme = GoogleFonts.getTextTheme(bodyFontString, baseTextTheme);
    TextTheme displayTextTheme = GoogleFonts.getTextTheme(displayFontString, baseTextTheme);
    TextTheme textTheme = displayTextTheme.copyWith(
      bodyLarge: bodyTextTheme.bodyLarge,
      bodyMedium: bodyTextTheme.bodyMedium,
      bodySmall: bodyTextTheme.bodySmall,
      labelLarge: bodyTextTheme.labelLarge,
      labelMedium: bodyTextTheme.labelMedium,
      labelSmall: bodyTextTheme.labelSmall,
    );
    return textTheme;
  }

  // Light Theme using FlexColorScheme with your custom colors
  static ThemeData get lightTheme {
    return FlexThemeData.light(
      colors: const FlexSchemeColor(
        primary: primaryLight,
        primaryContainer: primaryContainerLight,
        secondary: secondaryLight,
        secondaryContainer: secondaryContainerLight,
        tertiary: tertiaryLight,
        tertiaryContainer: tertiaryContainerLight,
        appBarColor: primaryLight,
        error: Color(0xFFBA1A1A),
      ),
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 2,
      // Reduced to preserve your exact colors
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 5,
        // Reduced to preserve your exact colors
        blendOnColors: false,
        useTextTheme: true,
        useM2StyleDividerInM3: true,
        alignedDropdown: true,
        useInputDecoratorThemeInDialogs: true,
        inputDecoratorSchemeColor: SchemeColor.primary,
        inputDecoratorBorderSchemeColor: SchemeColor.primary,
        inputDecoratorRadius: 12.0,
        inputDecoratorUnfocusedHasBorder: true,
        elevatedButtonSchemeColor: SchemeColor.primary,
        elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
        fabSchemeColor: SchemeColor.primary,
        fabUseShape: true,
        fabAlwaysCircular: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
    );
  }

  // Dark Theme using FlexColorScheme with your custom colors
  static ThemeData get darkTheme {
    return FlexThemeData.dark(
      colors: const FlexSchemeColor(
        primary: primaryDark,
        primaryContainer: primaryContainerDark,
        secondary: secondaryDark,
        secondaryContainer: secondaryContainerDark,
        tertiary: tertiaryDark,
        tertiaryContainer: tertiaryContainerDark,
        appBarColor: Color(0xFF1F2020),
        // Using surface container color
        error: Color(0xFFFFB4AB),
      ),
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 8,
      // Moderate blending for dark theme
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 15,
        useTextTheme: true,
        useM2StyleDividerInM3: true,
        alignedDropdown: true,
        useInputDecoratorThemeInDialogs: true,
        inputDecoratorSchemeColor: SchemeColor.primary,
        inputDecoratorBorderSchemeColor: SchemeColor.primary,
        inputDecoratorRadius: 12.0,
        inputDecoratorUnfocusedHasBorder: true,
        elevatedButtonSchemeColor: SchemeColor.primary,
        elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
        fabSchemeColor: SchemeColor.primary,
        fabUseShape: true,
        fabAlwaysCircular: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
    );
  }

  // Alternative: High contrast versions if needed
  static ThemeData get lightHighContrastTheme {
    return FlexThemeData.light(
      colors: const FlexSchemeColor(
        primary: Color(0xFF163035),
        // High contrast primary
        primaryContainer: Color(0xFF344D53),
        secondary: Color(0xFF003236),
        // High contrast secondary
        secondaryContainer: Color(0xFF005159),
        tertiary: Color(0xFF2A2C2D),
        tertiaryContainer: Color(0xFF48494A),
        appBarColor: Color(0xFF163035),
        error: Color(0xFF600004),
      ),
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 0,
      // No blending for high contrast
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 0,
        blendOnColors: false,
        useTextTheme: true,
        useM2StyleDividerInM3: true,
        alignedDropdown: true,
        useInputDecoratorThemeInDialogs: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
    );
  }

  static ThemeData get darkHighContrastTheme {
    return FlexThemeData.dark(
      colors: const FlexSchemeColor(
        primary: Color(0xFFE8FAFF),
        primaryContainer: Color(0xFFC4DFE6),
        secondary: Color(0xFFC8F9FF),
        secondaryContainer: Color(0xFF8ECDD5),
        tertiary: Color(0xFFFFFFFF),
        tertiaryContainer: Color(0xFFE2E2E3),
        appBarColor: Color(0xFF121414),
        error: Color(0xFFFFECE9),
      ),
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 0,
      // No blending for high contrast
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 0,
        useTextTheme: true,
        useM2StyleDividerInM3: true,
        alignedDropdown: true,
        useInputDecoratorThemeInDialogs: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
    );
  }

  // Helper method to get theme based on brightness and contrast
  static ThemeData getTheme({
    required Brightness brightness,
    bool highContrast = false,
  }) {
    if (brightness == Brightness.light) {
      return highContrast ? lightHighContrastTheme : lightTheme;
    } else {
      return highContrast ? darkHighContrastTheme : darkTheme;
    }
  }
}
