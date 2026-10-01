import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color primaryGoldLight = Color(0xFFE8C547);
  static const Color primaryGoldDark = Color(0xFFB8960F);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFAF8F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF2D2D2D);
  static const Color lightTextSecondary = Color(0xFF6B6B6B);
  static const Color lightDivider = Color(0xFFE8E4DF);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceVariant = Color(0xFF2A2A2A);
  static const Color darkText = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkDivider = Color(0xFF3A3A3A);

  // Accent Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE57373);
  static const Color info = Color(0xFF64B5F6);

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGoldLight, primaryGold, primaryGoldDark],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [darkSurface, darkBackground],
  );

  static const LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [lightSurface, lightBackground],
  );

  // Text Styles
  static TextStyle get arabicDisplayStyle => GoogleFonts.amiri(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get arabicTitleStyle => GoogleFonts.amiri(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get arabicBodyStyle => GoogleFonts.amiri(
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );

  static TextStyle get counterStyle => GoogleFonts.cairo(
    fontSize: 72,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get goalStyle => GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  // Light Theme
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryGold,
    scaffoldBackgroundColor: lightBackground,
    colorScheme: const ColorScheme.light(
      primary: primaryGold,
      secondary: primaryGoldLight,
      surface: lightSurface,
      error: error,
      onPrimary: lightText,
      onSecondary: lightText,
      onSurface: lightText,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: lightSurface,
      foregroundColor: lightText,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.amiri(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: lightText,
      ),
    ),
    cardTheme: CardThemeData(
      color: lightSurface,
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryGold,
      foregroundColor: Colors.white,
      elevation: 8,
    ),
    dividerTheme: const DividerThemeData(
      color: lightDivider,
      thickness: 1,
    ),
    iconTheme: const IconThemeData(
      color: primaryGold,
    ),
    textTheme: TextTheme(
      displayLarge: arabicDisplayStyle.copyWith(color: lightText),
      titleLarge: arabicTitleStyle.copyWith(color: lightText),
      bodyLarge: arabicBodyStyle.copyWith(color: lightText),
      bodyMedium: arabicBodyStyle.copyWith(
          color: lightTextSecondary, fontSize: 16),
    ),
  );

  // Dark Theme
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryGold,
    scaffoldBackgroundColor: darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: primaryGold,
      secondary: primaryGoldLight,
      surface: darkSurface,
      error: error,
      onPrimary: darkText,
      onSecondary: darkText,
      onSurface: darkText,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkSurface,
      foregroundColor: darkText,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.amiri(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: darkText,
      ),
    ),
    cardTheme: CardThemeData(
      color: darkSurface,
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryGold,
      foregroundColor: darkBackground,
      elevation: 8,
    ),
    dividerTheme: const DividerThemeData(
      color: darkDivider,
      thickness: 1,
    ),
    iconTheme: const IconThemeData(
      color: primaryGold,
    ),
    textTheme: TextTheme(
      displayLarge: arabicDisplayStyle.copyWith(color: darkText),
      titleLarge: arabicTitleStyle.copyWith(color: darkText),
      bodyLarge: arabicBodyStyle.copyWith(color: darkText),
      bodyMedium:
      arabicBodyStyle.copyWith(color: darkTextSecondary, fontSize: 16),
    ),
  );

  // Box Decorations
  static BoxDecoration get lightCardDecoration => BoxDecoration(
    color: lightSurface,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.08),
        blurRadius: 20,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration get darkCardDecoration => BoxDecoration(
    color: darkSurface,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.3),
        blurRadius: 20,
        offset: const Offset(0, 4),
      ),
    ],
    border: Border.all(
      color: darkDivider,
      width: 0.5,
    ),
  );

  static BoxDecoration counterButtonDecoration(bool isDark) => BoxDecoration(
    gradient: goldGradient,
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: primaryGold.withValues(alpha: isDark ? 0.4 : 0.3),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  );
}