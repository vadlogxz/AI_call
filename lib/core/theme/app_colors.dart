import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Background
  static const background          = Color(0xFF070B16);
  static const backgroundSecondary = Color(0xFF0D1324);

  // Surface
  static const surface         = Color(0xFF131A30);
  static const surfaceElevated = Color(0xFF1A2240);
  static const surfaceLight    = Color(0xFF1A2240); // alias
  static const surfaceBorder   = Color(0xFF26304F);

  // Primary Purple
  static const primary      = Color(0xFF7B61FF);
  static const primaryLight = Color(0xFF9B84FF);
  static const primaryGlow  = Color(0xFFA855F7);
  static const primaryDark  = Color(0xFF6B52F5);

  // Blue Accent
  static const secondary     = Color(0xFF4DA3FF);
  static const secondaryGlow = Color(0xFF60A5FA);

  // Green Accent
  static const success     = Color(0xFFAAFF5C);
  static const successGlow = Color(0xFF84CC16);

  // Orange Accent
  static const warning     = Color(0xFFFFB547);
  static const warningGlow = Color(0xFFF59E0B);

  // Pink Accent
  static const pink     = Color(0xFFFF4DDF);
  static const pinkGlow = Color(0xFFE879F9);

  // Error
  static const error = Color(0xFFFF5C7A);

  // Text
  static const textPrimary   = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFAAB3D1);
  static const textMuted     = Color(0xFF6F7898);

  // Icon backgrounds
  static const tintPrimary = Color(0xFF241B47);
  static const tintBlue    = Color(0xFF142845);
  static const tintSuccess = Color(0xFF132E24);
  static const tintWarning = Color(0xFF3A2812);
  static const tintError   = Color(0xFF4A1020);
  static const tintPink    = Color(0xFF35133A);

  // Glow colors — alpha baked in, use directly in BoxShadow
  static const glowPrimary = Color(0x597B61FF); // rgba(123,97,255, 0.35)
  static const glowBlue    = Color(0x4C4DA3FF); // rgba(77,163,255,  0.30)
  static const glowSuccess = Color(0x4759FF8D); // rgba(89,255,141,  0.28)
  static const glowWarning = Color(0x47FFB547); // rgba(255,181,71,  0.28)
  static const glowPink    = Color(0x47FF4DDF); // rgba(255,77,223,  0.28)

  // Misc legacy (used in existing widgets)
  static const surfaceSuccess = Color(0xFF132E24);
  static const surfaceWarning = Color(0xFF3A2812);
  static const surfaceDanger  = Color(0xFF4A1020);
  static const surfaceAccent  = Color(0xFF1A2240);
  static const borderAccent   = Color(0xFF26304F);
  static const streakBackground = Color(0xFF281C04);
  static const streakBorder     = Color(0xFF4E3008);
}
