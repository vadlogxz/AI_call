import 'package:elia/core/theme/app_colors.dart';
import 'package:elia/core/theme/app_radius.dart';
import 'package:elia/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppTheme {
  AppTheme._();

  static ShadThemeData get dark => ShadThemeData(
    brightness: Brightness.dark,
    colorScheme: const ShadColorScheme(
      background: AppColors.background,
      foreground: AppColors.textPrimary,
      card: AppColors.surface,
      cardForeground: AppColors.textPrimary,
      popover: AppColors.surfaceLight,
      popoverForeground: AppColors.textPrimary,
      primary: AppColors.primary,
      primaryForeground: Colors.white,
      secondary: AppColors.surfaceLight,
      secondaryForeground: AppColors.textSecondary,
      muted: AppColors.surfaceLight,
      mutedForeground: AppColors.textMuted,
      accent: AppColors.surfaceLight,
      accentForeground: AppColors.textPrimary,
      destructive: AppColors.error,
      destructiveForeground: Colors.white,
      border: AppColors.surfaceBorder,
      input: AppColors.surfaceBorder,
      ring: AppColors.primary,
      selection: AppColors.primaryDark,
    ),
    radius: BorderRadius.circular(AppRadius.medium),
  );

  static ShadThemeData get light => ShadThemeData(
    brightness: Brightness.light,
    colorScheme: const ShadZincColorScheme.light(),
    radius: BorderRadius.circular(AppRadius.medium),
  );

  // Підкладка під Material-віджети (передається в materialThemeBuilder у ShadApp)
  static ThemeData get materialDark => ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Inter',
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      error: AppColors.error,
    ),
    textTheme: const TextTheme(
      headlineLarge: AppTextStyles.heading1,
      headlineMedium: AppTextStyles.heading2,
      headlineSmall: AppTextStyles.heading3,
      bodyLarge: AppTextStyles.body,
      bodyMedium: AppTextStyles.body,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.button,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
        borderSide: const BorderSide(color: AppColors.surfaceBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
        borderSide: const BorderSide(color: AppColors.surfaceBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      hintStyle: const TextStyle(color: AppColors.textMuted),
    ),
  );

  static ThemeData get materialLight => ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: 'Inter',
  );
}
