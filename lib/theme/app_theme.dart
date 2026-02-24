import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Kitahack Brand Color Palette
  static const Color primaryColor = Color(0xFF8C5535); // Brown
  static const Color primaryDarkColor = Color(0xFF8C4C35); // Darker Brown
  static const Color secondaryColor = Color(0xFFBF8E63); // Tan / Ochre
  static const Color backgroundColor = Color(0xFFD9BFA0); // Beige / Light Tan
  static const Color surfaceColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF0D0D0D); // Almost Black
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

  static ThemeData get darkTheme {
    const Color darkBgColor = Color(0xFF09090B); // Zinc 950
    const Color darkSurfaceColor = Color(0xFF18181B); // Zinc 900
    const Color darkTextPrimary = Color(0xFFFAFAFA); // Zinc 50
    const Color darkTextSecondary = Color(0xFFA1A1AA); // Zinc 400
    const Color darkBorderColor = Color(0xFF27272A); // Zinc 800

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: darkSurfaceColor,
        background: darkBgColor,
      ),
      scaffoldBackgroundColor: darkBgColor,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontSize: 56,
          fontWeight: FontWeight.w800,
          color: darkTextPrimary,
          letterSpacing: -1.0,
        ),
        displayMedium: GoogleFonts.plusJakartaSans(
          fontSize: 40,
          fontWeight: FontWeight.w800,
          color: darkTextPrimary,
          letterSpacing: -0.5,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: darkTextPrimary,
          letterSpacing: -0.3,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: darkTextPrimary,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: darkTextSecondary,
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
          foregroundColor: primaryColor, // Brighter for dark mode
          side: const BorderSide(color: darkBorderColor, width: 1.5),
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
        color: darkSurfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: darkBorderColor, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: darkBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: darkBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        hintStyle: GoogleFonts.inter(color: darkTextSecondary),
      ),
    );
  }
}
