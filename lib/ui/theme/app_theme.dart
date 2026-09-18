import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_colors.dart';
import 'app_neutrals.dart';
import 'app_typography.dart';
import 'color_utils.dart';

ThemeData buildDarkTheme(Color primary) => _theme(Brightness.dark, AppNeutrals.dark, primary);
ThemeData buildLightTheme(Color primary) => _theme(Brightness.light, AppNeutrals.light, primary);

ThemeData _theme(Brightness brightness, AppNeutrals neutrals, Color primary) {
  final isDark = brightness == Brightness.dark;
  final scheme = ColorScheme(
    brightness: brightness,
    primary: primary,
    onPrimary: Colors.white,
    secondary: darken(primary, 0.12),
    onSecondary: Colors.white,
    error: AppColors.negative,
    onError: Colors.white,
    surface: neutrals.background,
    onSurface: neutrals.textPrimary,
  );

  // Office Code Pro is the primary typeface (loaded at startup in main()).
  // Typography roles live in [AppTypography].
  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: neutrals.background,
    splashFactory: InkSparkle.splashFactory,
    fontFamily: AppTypography.fontFamily,
  );

  return base.copyWith(
    extensions: [neutrals],
    textTheme: AppTypography.buildTextTheme(neutrals.textPrimary),
    appBarTheme: AppBarTheme(
      backgroundColor: neutrals.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    ),
  );
}
