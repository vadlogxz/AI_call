import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {
  AppGradients._();

  // Primary CTA button gradient
  static const primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, Color(0xFFB14DFF)],
  );

  // Blue → Purple (secondary actions, accents)
  static const bluePurple = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.secondary, AppColors.primary],
  );

  // AI card background
  static const aiCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A1F3D), Color(0xFF11162C)],
  );

  // Subtle surface depth
  static const surfaceGlow = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1C2440), Color(0xFF131A30)],
  );
}
