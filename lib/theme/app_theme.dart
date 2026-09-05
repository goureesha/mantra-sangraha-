import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static TextTheme _baseTextTheme(Color color) {
    return GoogleFonts.notoSansKannadaTextTheme().copyWith(
      displayLarge: GoogleFonts.notoSansKannada(color: color),
      displayMedium: GoogleFonts.notoSansKannada(color: color),
      displaySmall: GoogleFonts.notoSansKannada(color: color),
      headlineLarge: GoogleFonts.notoSansKannada(color: color),
      headlineMedium: GoogleFonts.notoSansKannada(color: color),
      headlineSmall: GoogleFonts.notoSansKannada(color: color),
      titleLarge: GoogleFonts.notoSansKannada(color: color),
      titleMedium: GoogleFonts.notoSansKannada(color: color),
      titleSmall: GoogleFonts.notoSansKannada(color: color),
      bodyLarge: GoogleFonts.notoSansKannada(color: color),
      bodyMedium: GoogleFonts.notoSansKannada(color: color),
      bodySmall: GoogleFonts.notoSansKannada(color: color),
      labelLarge: GoogleFonts.notoSansKannada(color: color),
      labelMedium: GoogleFonts.notoSansKannada(color: color),
      labelSmall: GoogleFonts.notoSansKannada(color: color),
    );
  }

  static ThemeData templeTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFFF9933),
        secondary: Color(0xFFCC3333),
        surface: Color(0xFF1A0A0A),
        background: Color(0xFF1A0A0A),
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: Color(0xFFFFE0B2),
        onBackground: Color(0xFFFFE0B2),
        surfaceVariant: Color(0xFF2D1515),
      ),
      scaffoldBackgroundColor: const Color(0xFF1A0A0A),
      cardColor: const Color(0xFF2D1515),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A0A0A),
        foregroundColor: Color(0xFFFF9933),
        elevation: 0,
      ),
      textTheme: _baseTextTheme(const Color(0xFFFFE0B2)),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueGrey,
        brightness: Brightness.dark,
      ),
      textTheme: _baseTextTheme(Colors.white),
    );
  }

  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF800000),
        brightness: Brightness.light,
        surface: const Color(0xFFFFF8F0),
        background: const Color(0xFFFFF8F0),
      ),
      scaffoldBackgroundColor: const Color(0xFFFFF8F0),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF800000),
        foregroundColor: Colors.white,
      ),
      textTheme: _baseTextTheme(Colors.black87),
    );
  }
}
