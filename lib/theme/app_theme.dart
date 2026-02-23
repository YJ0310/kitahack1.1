import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Premium Next.js / Vite style color palette
  static const Color primaryColor = Color(0xFF6366F1); // Indigo 500
  static const Color primaryDarkColor = Color(0xFF4F46E5); // Indigo 600
  static const Color secondaryColor = Color(0xFF14B8A6); // Teal 500
  static const Color backgroundColor = Color(
    0xFFF4F4F5,
  ); // Zinc 100 for subtle contrast
  static const Color surfaceColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF18181B); // Zinc 900
  static const Color textSecondaryColor = Color(0xFF71717A); // Zinc 500

  // Accent colors for dynamic dashboard
  static const Color accentPurple = Color(0xFFA855F7);
  static const Color accentPink = Color(0xFFEC4899);
  static const Color accentOrange = Color(0xFFF97316);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        background: backgroundColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontSize: 56,
          fontWeight: FontWeight.w800,
          color: textPrimaryColor,
          letterSpacing: -1.0,
        ),
        displayMedium: GoogleFonts.plusJakartaSans(
          fontSize: 40,
          fontWeight: FontWeight.w800,
          color: textPrimaryColor,
          letterSpacing: -0.5,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textPrimaryColor,
          letterSpacing: -0.3,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: textPrimaryColor,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: textSecondaryColor,
          height: 1.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryDarkColor,
          side: const BorderSide(
            color: Color(0xFFE4E4E7),
            width: 1.5,
          ), // Zinc 200
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: 0.2,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(
            color: Color(0xFFE4E4E7),
            width: 1,
          ), // Zinc 200 border
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE4E4E7)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE4E4E7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        hintStyle: GoogleFonts.inter(
          color: const Color(0xFFA1A1AA),
        ), // Zinc 400
      ),
    );
  }
}
