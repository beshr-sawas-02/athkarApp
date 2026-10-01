import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color primaryGoldLight = Color(0xFFE8C547);
  static const Color primaryGoldDark = Color(0xFFB8960F);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF7F3EC);
  static const Color lightSurface = Color(0xFFFFFCF8);
  static const Color lightText = Color(0xFF2D2D2D);
  static const Color lightTextSecondary = Color(0xFF6B6B6B);
  static const Color lightDivider = Color(0xFFE8E4DF);

  // Dark Theme — deep teal/navy spiritual tone
  static const Color darkBackground = Color(0xFF0B1418);
  static const Color darkSurface = Color(0xFF132026);
  static const Color darkSurfaceVariant = Color(0xFF1C2E36);
  static const Color darkText = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkDivider = Color(0xFF2A3D46);

  // Accent Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE57373);
  static const Color info = Color(0xFF64B5F6);

  // Unified radii
  static const double radiusSm = 12;
  static const double radiusMd = 16;
  static const double radiusLg = 20;

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGoldLight, primaryGold, primaryGoldDark],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF162A32), darkBackground],
  );

  static const LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFCF8), lightBackground],
  );

  static List<BoxShadow> softShadow(bool isDark) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static BorderRadius get radiusAllMd => BorderRadius.circular(radiusMd);
  static BorderRadius get radiusAllLg => BorderRadius.circular(radiusLg);

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
          shape: RoundedRectangleBorder(borderRadius: radiusAllLg),
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
        iconTheme: const IconThemeData(color: primaryGold),
        textTheme: TextTheme(
          displayLarge: arabicDisplayStyle.copyWith(color: lightText),
          titleLarge: arabicTitleStyle.copyWith(color: lightText),
          bodyLarge: arabicBodyStyle.copyWith(color: lightText),
          bodyMedium: arabicBodyStyle.copyWith(
            color: lightTextSecondary,
            fontSize: 16,
          ),
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
          shape: RoundedRectangleBorder(borderRadius: radiusAllLg),
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
        iconTheme: const IconThemeData(color: primaryGold),
        textTheme: TextTheme(
          displayLarge: arabicDisplayStyle.copyWith(color: darkText),
          titleLarge: arabicTitleStyle.copyWith(color: darkText),
          bodyLarge: arabicBodyStyle.copyWith(color: darkText),
          bodyMedium: arabicBodyStyle.copyWith(
            color: darkTextSecondary,
            fontSize: 16,
          ),
        ),
      );

  static BoxDecoration get lightCardDecoration => BoxDecoration(
        color: lightSurface,
        borderRadius: radiusAllLg,
        boxShadow: softShadow(false),
      );

  static BoxDecoration get darkCardDecoration => BoxDecoration(
        color: darkSurface,
        borderRadius: radiusAllLg,
        boxShadow: softShadow(true),
        border: Border.all(color: darkDivider, width: 0.5),
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

/// Subtle geometric pattern for spiritual atmosphere.
class AtmospherePainter extends CustomPainter {
  final bool isDark;

  AtmospherePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryGold.withValues(alpha: isDark ? 0.045 : 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const step = 56.0;
    for (double y = -step; y < size.height + step; y += step) {
      for (double x = -step; x < size.width + step; x += step) {
        final cx = x + ((y ~/ step) % 2) * (step / 2);
        _drawStar(canvas, Offset(cx, y), 10, paint);
      }
    }
  }

  void _drawStar(Canvas canvas, Offset center, double r, Paint paint) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4) - math.pi / 2;
      final point = Offset(
        center.dx + r * math.cos(angle),
        center.dy + r * math.sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
    canvas.drawCircle(center, r * 0.35, paint);
  }

  @override
  bool shouldRepaint(covariant AtmospherePainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}

class AtmosphereBackground extends StatelessWidget {
  final bool isDark;
  final Widget child;

  const AtmosphereBackground({
    super.key,
    required this.isDark,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: isDark ? AppTheme.darkGradient : AppTheme.lightGradient,
      ),
      child: CustomPaint(
        painter: AtmospherePainter(isDark: isDark),
        child: child,
      ),
    );
  }
}
