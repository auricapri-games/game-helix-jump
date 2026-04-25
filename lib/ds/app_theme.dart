import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Centralised Material 3 theme for Helix Jump using the sunset_brasil
/// palette. All other files reference colors via [AppColors] or
/// `Theme.of(context).colorScheme.*` — never hard-coded.
class AppTheme {
  AppTheme._();

  static ColorScheme get colorScheme => const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primary,
        onPrimary: AppColors.background,
        secondary: AppColors.secondary,
        onSecondary: AppColors.background,
        tertiary: AppColors.accent,
        onTertiary: AppColors.background,
        error: Color(0xFFC83020),
        onError: AppColors.text,
        surface: AppColors.background,
        onSurface: AppColors.text,
        surfaceContainerHigh: AppColors.backgroundAlt,
        surfaceContainerHighest: AppColors.backgroundAlt,
        onSurfaceVariant: AppColors.accent,
        outline: AppColors.accent,
        outlineVariant: AppColors.secondary,
      );

  static ThemeData get themeData {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
    );
    return base.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: AppColors.text,
        displayColor: AppColors.text,
      ),
    );
  }

  /// Vertical sunset gradient used as default screen background.
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.background,
      AppColors.backgroundAlt,
      AppColors.primary,
    ],
    stops: [0.0, 0.6, 1.0],
  );

  /// Game segment colors derived from the palette so painters stay on theme.
  static const Color safeSegment = Color(0xFF76B852);
  static const Color safeSegmentEdge = Color(0xFFBCE085);
  static const Color deadSegment = Color(0xFFC83020);
  static const Color deadSegmentEdge = Color(0xFFFF8A60);
  static const Color gapSegment = Color(0x33000000);
}
