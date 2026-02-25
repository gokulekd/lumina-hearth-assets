import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette — inspired by fire, wood, and midnight ambience
  static const Color backgroundDark = Color(0xFF0A0A0F);
  static const Color backgroundMid = Color(0xFF12121A);
  static const Color backgroundCard = Color(0xFF1A1A26);
  static const Color surfaceGlass = Color(0x1AFFFFFF);

  static const Color emberOrange = Color(0xFFFF6B35);
  static const Color amberGold = Color(0xFFFFA500);
  static const Color warmCream = Color(0xFFFFF8E7);
  static const Color softWhite = Color(0xFFEAE4D8);
  static const Color mutedGray = Color(0xFF6B6880);
  static const Color deepSlate = Color(0xFF2D2B3D);

  static const Gradient fireGradient = LinearGradient(
    colors: [Color(0xFFFF4500), Color(0xFFFF8C00), Color(0xFFFFD700)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static const Gradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E1B2E), Color(0xFF252237)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient sceneSelectorGradient = LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const String _fontFamily = 'Outfit';

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      fontFamily: _fontFamily,
      colorScheme: const ColorScheme.dark(
        primary: emberOrange,
        secondary: amberGold,
        surface: backgroundCard,
        onPrimary: warmCream,
        onSecondary: backgroundDark,
        onSurface: softWhite,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: _fontFamily,
          color: warmCream,
          fontSize: 48,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.5,
        ),
        displayMedium: TextStyle(
          fontFamily: _fontFamily,
          color: warmCream,
          fontSize: 36,
          fontWeight: FontWeight.w600,
          letterSpacing: -1,
        ),
        headlineLarge: TextStyle(
          fontFamily: _fontFamily,
          color: warmCream,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontFamily: _fontFamily,
          color: warmCream,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          fontFamily: _fontFamily,
          color: warmCream,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          fontFamily: _fontFamily,
          color: softWhite,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          fontFamily: _fontFamily,
          color: softWhite,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          fontFamily: _fontFamily,
          color: amberGold,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
        labelMedium: TextStyle(
          fontFamily: _fontFamily,
          color: mutedGray,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: emberOrange,
        inactiveTrackColor: deepSlate,
        thumbColor: amberGold,
        overlayColor: amberGold.withAlpha(30),
        trackHeight: 3,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      ),
      iconTheme: const IconThemeData(color: softWhite, size: 24),
      dividerColor: deepSlate,
      useMaterial3: true,
    );
  }
}
