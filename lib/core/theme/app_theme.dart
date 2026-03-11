import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryCoral    = Color(0xFFEF5350);
  static const Color primaryCoralLight = Color(0xFFFF6F61);
  static const Color primaryCoralDark  = Color(0xFFB71C1C);
  static const Color bgPrimary       = Color(0xFF121212);
  static const Color bgSecondary     = Color(0xFF1E1E1E);
  static const Color bgCard          = Color(0xFF1F1F1F);
  static const Color textPrimary     = Color(0xFFFFFFFF);
  static const Color textSecondary   = Color(0xFFB0B0B0);
  static const Color textMuted       = Color(0xFF666666);
  static const Color accentGreen     = Color(0xFF66BB6A);
  static const Color accentBlue      = Color(0xFF42A5F5);

  static const LinearGradient coralGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryCoralLight, primaryCoral, primaryCoralDark],
  );

  static ThemeData get darkTheme {
    final base = GoogleFonts.interTextTheme();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgPrimary,
      colorScheme: const ColorScheme.dark(
        primary: primaryCoral,
        secondary: primaryCoralLight,
        surface: bgSecondary,
        error: Color(0xFFCF6679),
      ),
      textTheme: base.copyWith(
        displayLarge: base.displayLarge?.copyWith(fontSize: 32, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: -0.5),
        displayMedium: base.displayMedium?.copyWith(fontSize: 24, fontWeight: FontWeight.w700, color: textPrimary, letterSpacing: -0.3),
        titleLarge: base.titleLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w600, color: textPrimary),
        titleMedium: base.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w500, color: textPrimary),
        bodyLarge: base.bodyLarge?.copyWith(fontSize: 16, color: textSecondary),
        bodyMedium: base.bodyMedium?.copyWith(fontSize: 14, color: textSecondary),
        labelLarge: base.labelLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

