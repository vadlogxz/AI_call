import 'package:elia/core/theme/elia_theme_extension.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const EliaThemeColors lightColors = EliaThemeColors(
    surfacePrimary: Color(0xFFF7F9FC),
    surfaceSecondary: Colors.white,
    surfaceTertiary: Color(0xFFEFF4FB),
    surfaceInverse: Color(0xFF0F172A),
    surfaceAccent: Color(0xFFE8F0FF),
    surfaceSuccess: Color(0xFFEAFBF0),
    surfaceWarning: Color(0xFFFFF5E8),
    surfaceDanger: Color(0xFFFEECEC),
    borderPrimary: Color(0xFFD9E1EC),
    borderAccent: Color(0xFFBFD4FF),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF475569),
    textMuted: Color(0xFF64748B),
    textOnAccent: Colors.white,
    accentPrimary: Color(0xFF2563EB),
    accentSecondary: Color(0xFF0F766E),
    success: Color(0xFF16A34A),
    warning: Color(0xFFD97706),
    danger: Color(0xFFDC2626),
    navBackground: Colors.white,
    navSelectedBackground: Color(0xFFE8F0FF),
    navSelectedForeground: Color(0xFF0F172A),
    navIdleForeground: Color(0xFF64748B),
    inputFill: Colors.white,
    inputHint: Color(0xFF94A3B8),
    userBubble: Color(0xFFDCE8FF),
    assistantBubble: Colors.white,
    bottomSheetBackground: Color(0xFFF7F9FC),
    streakBackground: Color(0xFFFFF5E8),
    streakBorder: Color(0xFFFCD9A6),
    streakText: Color(0xFFD97706),
  );

  static const EliaThemeColors darkColors = EliaThemeColors(
    surfacePrimary: Color(0xFF0A0D14),
    surfaceSecondary: Color(0xFF0F172A),
    surfaceTertiary: Color(0xFF141C2B),
    surfaceInverse: Color(0xFFE8EAF5),
    surfaceAccent: Color(0xFF1E2A50),
    surfaceSuccess: Color(0xFF0D2018),
    surfaceWarning: Color(0xFF451A03),
    surfaceDanger: Color(0xFF3F1518),
    borderPrimary: Color(0xFF1E293B),
    borderAccent: Color(0xFF2A3A6A),
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFFC8D0E8),
    textMuted: Color(0xFF64748B),
    textOnAccent: Colors.white,
    accentPrimary: Color(0xFF5B78D4),
    accentSecondary: Color(0xFF8AAAF5),
    success: Color(0xFF3CB56A),
    warning: Color(0xFFF59E0B),
    danger: Color(0xFFEF4444),
    navBackground: Color(0xFF080F1E),
    navSelectedBackground: Color(0xFF1E293B),
    navSelectedForeground: Color(0xFFF8FAFC),
    navIdleForeground: Color(0xFF475569),
    inputFill: Color(0xFF111827),
    inputHint: Color(0xFF4A5680),
    userBubble: Color(0xFF1A2550),
    assistantBubble: Color(0xFF13192E),
    bottomSheetBackground: Color(0xFF0C1020),
    streakBackground: Color(0xFF1A1200),
    streakBorder: Color(0xFF3A2800),
    streakText: Color(0xFFE8A030),
  );

  static ThemeData light() => _buildTheme(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF2563EB),
      secondary: Color(0xFF0F766E),
      surface: Color(0xFFF7F9FC),
      onSurface: Color(0xFF0F172A),
    ),
    colors: lightColors,
  );

  static ThemeData dark() => _buildTheme(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF5B78D4),
      secondary: Color(0xFF3CB56A),
      surface: Color(0xFF0A0D14),
      onSurface: Color(0xFFF8FAFC),
    ),
    colors: darkColors,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required EliaThemeColors colors,
  }) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
    );

    final textTheme = base.textTheme.apply(
      bodyColor: colors.textPrimary,
      displayColor: colors.textPrimary,
    );

    return base.copyWith(
      scaffoldBackgroundColor: colors.surfacePrimary,
      cardColor: colors.surfaceSecondary,
      dividerColor: colors.borderPrimary,
      textTheme: textTheme,
      extensions: [colors],
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surfacePrimary,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: colors.textPrimary,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.bottomSheetBackground,
        modalBackgroundColor: colors.bottomSheetBackground,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.accentPrimary,
          foregroundColor: colors.textOnAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.inputFill,
        hintStyle: TextStyle(color: colors.inputHint),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.borderPrimary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.borderPrimary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.accentPrimary),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.success;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.black),
        side: BorderSide(color: colors.borderPrimary),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return colors.navSelectedForeground;
            }
            return colors.textSecondary;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return colors.navSelectedBackground;
            }
            return colors.surfaceSecondary;
          }),
          side: WidgetStateProperty.all(
            BorderSide(color: colors.borderPrimary),
          ),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.accentPrimary,
        linearTrackColor: colors.surfaceTertiary,
      ),
    );
  }
}
