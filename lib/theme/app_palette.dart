import 'package:flutter/material.dart';

/// All brand colors in one place.
/// To re-theme the whole app: add a new palette below and point [active] at it.
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.name,
    required this.primary,
    required this.primaryDark,
    required this.accent,
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textMuted,
  });

  final String name;
  final Color primary;     // buttons, links, focused fields
  final Color primaryDark; // gradients, splash background
  final Color accent;      // play button in the logo, highlights
  final Color background;  // screen background, input fields
  final Color surface;     // cards
  final Color textPrimary;
  final Color textMuted;

  static const inkSaffron = AppPalette(
    name: 'Ink & Saffron',
    primary: Color(0xFF3B3FB6),
    primaryDark: Color(0xFF1E1F5C),
    accent: Color(0xFFF5A524),
    background: Color(0xFFF6F5FB),
    surface: Colors.white,
    textPrimary: Color(0xFF1B1B2F),
    textMuted: Color(0xFF6B6B80),
  );

  // A second palette, ready to try: set active = forestMint.
  static const forestMint = AppPalette(
    name: 'Forest & Mint',
    primary: Color(0xFF1F7A5C),
    primaryDark: Color(0xFF0E3B2E),
    accent: Color(0xFF7FE0B5),
    background: Color(0xFFF3F8F5),
    surface: Colors.white,
    textPrimary: Color(0xFF12221B),
    textMuted: Color(0xFF5E6E66),
  );

  /// The palette the whole app uses. Change this one line to re-theme.
  static const active = inkSaffron;

  /// How screens read the current palette.
  static AppPalette of(BuildContext context) =>
      Theme.of(context).extension<AppPalette>() ?? active;

  // Required by ThemeExtension. Palettes are swapped whole, not edited.
  @override
  AppPalette copyWith() => this;

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) =>
      (other is AppPalette && t >= 0.5) ? other : this;
}