import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF169790);
  static const Color primaryDark = Color(0xFF0C615B);
  static const Color secondary = Color(0xFF6366F1);
  static const Color accent = Color(0xFF10B981);

  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F4F6);

  static const Color textPrimary = Color(0xFF9CA3AF);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF1A1A1A);

  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF0F0F0);

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // ----- Wadger-derived accent palette (ported design system) -----
  // Muted / washed accents so icons, tags and chips read as soft tints rather
  // than saturated blocks. The brand color that drives buttons and the hero
  // gradient is chosen by the user (see SettingsService) and read from
  // Theme.of(context).colorScheme.primary - not from here.
  static const Color positive = Color(0xFF4B966E); // added / in-stock (darkened for legibility)
  static const Color negative = Color(0xFFB36273); // removed / destructive (darkened for legibility)

  /// Vivid palette (brighter than [categoryPalette]) used where a swatch must
  /// read at a glance. Referenced by the ported form widgets.
  static const List<Color> cardPalette = [
    Color(0xFF5AC8FA), // light blue
    Color(0xFF2E6BF6), // blue
    Color(0xFF7C6CF0), // indigo
    Color(0xFF9B59B6), // purple
    Color(0xFFE5342B), // red
    Color(0xFFFF7A00), // orange
    Color(0xFFF6C518), // yellow
    Color(0xFF34C759), // green
    Color(0xFF14B8A6), // teal
    Color(0xFFEC6EA0), // pink
  ];

  /// A broad set of muted, natural hues cycled through when a new group needs a
  /// colour, so each group's icon medallion gets a soft, desaturated tint.
  static const List<Color> categoryPalette = [
    Color(0xFFA8A0E6), // lavender
    Color(0xFF9198D9), // periwinkle
    Color(0xFFAD92E2), // lilac
    Color(0xFFB79BCB), // mauve
    Color(0xFF7A97DC), // cornflower
    Color(0xFF6C8AB8), // dusty blue
    Color(0xFF7FA6C4), // steel
    Color(0xFF57B4A8), // teal
    Color(0xFF5CB595), // seafoam
    Color(0xFF6FB3A6), // aqua
    Color(0xFF58B182), // green
    Color(0xFF7DA47A), // sage
    Color(0xFF93B06E), // moss
    Color(0xFFB0B36A), // olive
    Color(0xFFD9AC79), // sand
    Color(0xFFD2A757), // amber
    Color(0xFFCBB56A), // gold
    Color(0xFFD89C6E), // clay
    Color(0xFFCC8A63), // terracotta
    Color(0xFFC98F6E), // copper
    Color(0xFFD37387), // rose
    Color(0xFFD88DB6), // pink
    Color(0xFFC97F92), // dusty rose
    Color(0xFFB98BB0), // orchid
  ];

  // Category colors
  static const Color shoesColor = Color(0xFF10B981);
  static const Color bodyColor = Color(0xFFF59E0B);
  static const Color jeansColor = Color(0xFF3B82F6);
  static const Color underwearColor = Color(0xFFEF4444);
  static const Color beddingColor = Color(0xFF8B5CF6);
  static const Color glassesColor = Color(0xFF06B6D4);
  static const Color bikeColor = Color(0xFF84CC16);
  static const Color customColor = Color(0xFF6B7280);

  // Blacks
  static const blackFull = Color(0xFF000000);
  static const blackErie = Color(0xFF252525);
  static const blackJet = Color(0xFF333333);
  static const blackCard = Color(0xFF0D0D0D);
  static const blackCard2 = Color(0xFF101010);
  static const backgroundColor = Color(0xFF1C1C1E);
  static const disabledBackgroundColor = Color(0xFF4B5563);
  static const buttonColor = Color(0xFF2C2C2E);

// Whites
  static const whiteFull = Color(0xFFFFFFFF);
  static const whiteSnow = Color(0xFFF8F8F7);
  static const whiteCultured = Color(0xFFDDDDD8);

// Greys
  static const kColorGrey = Color(0xFF676767);
  static const kColorLightGrey = Color(0xFFF7F6F6);
  static const greyPlatinum = Color(0xFFE4E4E4);
  static const greySpanish = Color(0xFF949494);
  static const greyDim = Color(0xFF6A6A6A);

  // Netflix-inspired
  static const Color netflixRed = Color(0xFFE50914);
  static const Color netflixBlack = Color(0xFF141414);

// Spotify-inspired
  static const Color spotifyGreen = Color(0xFF1DB954);
  static const Color spotifyBlack = Color(0xFF191414);

// Instagram-inspired
  static const Color instagramPink = Color(0xFFE4405F);
  static const Color instagramPurple = Color(0xFF833AB4);
}
