import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_palette.dart';

class AppTheme {
  static ThemeData light([AppPalette p = AppPalette.active]) {
    final scheme = ColorScheme.fromSeed(
      seedColor: p.primary,
      primary: p.primary,
      secondary: p.accent,
      surface: p.surface,
    );

    // Ask google_fonts only for the font's name, then let Flutter apply it everywhere
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
    );
    final text = base.textTheme
        .apply(bodyColor: p.textPrimary, displayColor: p.textPrimary);

    OutlineInputBorder border([Color? color, double width = 1.6]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: color == null
              ? BorderSide.none
              : BorderSide(color: color, width: width),
        );

    return base.copyWith(
      scaffoldBackgroundColor: p.background,
      textTheme: text,
      extensions: [p],
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        prefixIconColor: p.textMuted,
        suffixIconColor: p.textMuted,
        labelStyle: TextStyle(color: p.textMuted),
        border: border(),
        enabledBorder: border(),
        focusedBorder: border(p.primary),
        errorBorder: border(scheme.error, 1),
        focusedErrorBorder: border(scheme.error),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: p.primary.withValues(alpha: 0.6),
          disabledForegroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.primary,
          textStyle: text.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}