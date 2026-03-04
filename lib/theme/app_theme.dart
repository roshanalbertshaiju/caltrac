import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData buildDark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: kBackground,
      primaryColor: kPrimary,
      colorScheme: const ColorScheme.dark(
        primary: kPrimary,
        secondary: kSecondary,
        surface: kSurface,
        error: kError,
      ),
      cardTheme: const CardThemeData(
        color: kSurface,
        shape: RoundedRectangleBorder(
          borderRadius: kCardRadius,
          side: BorderSide(color: kBorder, width: 1),
        ),
        elevation: 4,
      ),
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: kTextPrimary,
        displayColor: kTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: kSurface,
        contentTextStyle: TextStyle(color: kTextPrimary),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: kPrimary,
      ),
      useMaterial3: true,
    );
  }
}

