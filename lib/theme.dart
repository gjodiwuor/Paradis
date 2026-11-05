import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Every colour used in the app, taken from the canvas designs.
class AppColors {
  static const ink = Color(0xFF0E1B33);
  static const muted = Color(0xFF5A6780);
  static const ground = Color(0xFFF3F5FA);
  static const line = Color(0xFFE3E8F2);
  static const fieldBorder = Color(0xFFC9D2E3);
  static const blue = Color(0xFF336BDB);
  static const blueDark = Color(0xFF2456BE);
  static const paleBlue = Color(0xFFE6EEFC);
  static const lightBlue = Color(0xFF8CBDFF);
  static const softBlue = Color(0xFFB8CCF2);
  static const offerText = Color(0xFFDCE5F5);
  static const offerLine = Color(0xFF2B3D60);
  static const amber = Color(0xFFF5A524);
  static const starEmpty = Color(0xFFD6DEED);
  static const black = Color(0xFF1C1C1E);
  static const tabActive = Color(0xFF3A3A3C);
  static const tabIcon = Color(0xFFD1D1D6);
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.blue,
      surface: AppColors.ground,
    ),
    scaffoldBackgroundColor: AppColors.ground,
  );
  return base.copyWith(
    textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    ),
  );
}
