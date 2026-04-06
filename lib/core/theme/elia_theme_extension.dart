import 'package:flutter/material.dart';

@immutable
class EliaThemeColors extends ThemeExtension<EliaThemeColors> {
  const EliaThemeColors({
    required this.surfacePrimary,
    required this.surfaceSecondary,
    required this.surfaceTertiary,
    required this.surfaceInverse,
    required this.surfaceAccent,
    required this.surfaceSuccess,
    required this.surfaceWarning,
    required this.surfaceDanger,
    required this.borderPrimary,
    required this.borderAccent,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textOnAccent,
    required this.accentPrimary,
    required this.accentSecondary,
    required this.success,
    required this.warning,
    required this.danger,
    required this.navBackground,
    required this.navSelectedBackground,
    required this.navSelectedForeground,
    required this.navIdleForeground,
    required this.inputFill,
    required this.inputHint,
    required this.userBubble,
    required this.assistantBubble,
    required this.bottomSheetBackground,
    required this.streakBackground,
    required this.streakBorder,
    required this.streakText,
  });

  final Color surfacePrimary;
  final Color surfaceSecondary;
  final Color surfaceTertiary;
  final Color surfaceInverse;
  final Color surfaceAccent;
  final Color surfaceSuccess;
  final Color surfaceWarning;
  final Color surfaceDanger;
  final Color borderPrimary;
  final Color borderAccent;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textOnAccent;
  final Color accentPrimary;
  final Color accentSecondary;
  final Color success;
  final Color warning;
  final Color danger;
  final Color navBackground;
  final Color navSelectedBackground;
  final Color navSelectedForeground;
  final Color navIdleForeground;
  final Color inputFill;
  final Color inputHint;
  final Color userBubble;
  final Color assistantBubble;
  final Color bottomSheetBackground;
  final Color streakBackground;
  final Color streakBorder;
  final Color streakText;

  @override
  EliaThemeColors copyWith({
    Color? surfacePrimary,
    Color? surfaceSecondary,
    Color? surfaceTertiary,
    Color? surfaceInverse,
    Color? surfaceAccent,
    Color? surfaceSuccess,
    Color? surfaceWarning,
    Color? surfaceDanger,
    Color? borderPrimary,
    Color? borderAccent,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? textOnAccent,
    Color? accentPrimary,
    Color? accentSecondary,
    Color? success,
    Color? warning,
    Color? danger,
    Color? navBackground,
    Color? navSelectedBackground,
    Color? navSelectedForeground,
    Color? navIdleForeground,
    Color? inputFill,
    Color? inputHint,
    Color? userBubble,
    Color? assistantBubble,
    Color? bottomSheetBackground,
    Color? streakBackground,
    Color? streakBorder,
    Color? streakText,
  }) {
    return EliaThemeColors(
      surfacePrimary: surfacePrimary ?? this.surfacePrimary,
      surfaceSecondary: surfaceSecondary ?? this.surfaceSecondary,
      surfaceTertiary: surfaceTertiary ?? this.surfaceTertiary,
      surfaceInverse: surfaceInverse ?? this.surfaceInverse,
      surfaceAccent: surfaceAccent ?? this.surfaceAccent,
      surfaceSuccess: surfaceSuccess ?? this.surfaceSuccess,
      surfaceWarning: surfaceWarning ?? this.surfaceWarning,
      surfaceDanger: surfaceDanger ?? this.surfaceDanger,
      borderPrimary: borderPrimary ?? this.borderPrimary,
      borderAccent: borderAccent ?? this.borderAccent,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      textOnAccent: textOnAccent ?? this.textOnAccent,
      accentPrimary: accentPrimary ?? this.accentPrimary,
      accentSecondary: accentSecondary ?? this.accentSecondary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      navBackground: navBackground ?? this.navBackground,
      navSelectedBackground:
          navSelectedBackground ?? this.navSelectedBackground,
      navSelectedForeground:
          navSelectedForeground ?? this.navSelectedForeground,
      navIdleForeground: navIdleForeground ?? this.navIdleForeground,
      inputFill: inputFill ?? this.inputFill,
      inputHint: inputHint ?? this.inputHint,
      userBubble: userBubble ?? this.userBubble,
      assistantBubble: assistantBubble ?? this.assistantBubble,
      bottomSheetBackground:
          bottomSheetBackground ?? this.bottomSheetBackground,
      streakBackground: streakBackground ?? this.streakBackground,
      streakBorder: streakBorder ?? this.streakBorder,
      streakText: streakText ?? this.streakText,
    );
  }

  @override
  EliaThemeColors lerp(
    covariant ThemeExtension<EliaThemeColors>? other,
    double t,
  ) {
    if (other is! EliaThemeColors) {
      return this;
    }

    Color blend(Color a, Color b) => Color.lerp(a, b, t)!;

    return EliaThemeColors(
      surfacePrimary: blend(surfacePrimary, other.surfacePrimary),
      surfaceSecondary: blend(surfaceSecondary, other.surfaceSecondary),
      surfaceTertiary: blend(surfaceTertiary, other.surfaceTertiary),
      surfaceInverse: blend(surfaceInverse, other.surfaceInverse),
      surfaceAccent: blend(surfaceAccent, other.surfaceAccent),
      surfaceSuccess: blend(surfaceSuccess, other.surfaceSuccess),
      surfaceWarning: blend(surfaceWarning, other.surfaceWarning),
      surfaceDanger: blend(surfaceDanger, other.surfaceDanger),
      borderPrimary: blend(borderPrimary, other.borderPrimary),
      borderAccent: blend(borderAccent, other.borderAccent),
      textPrimary: blend(textPrimary, other.textPrimary),
      textSecondary: blend(textSecondary, other.textSecondary),
      textMuted: blend(textMuted, other.textMuted),
      textOnAccent: blend(textOnAccent, other.textOnAccent),
      accentPrimary: blend(accentPrimary, other.accentPrimary),
      accentSecondary: blend(accentSecondary, other.accentSecondary),
      success: blend(success, other.success),
      warning: blend(warning, other.warning),
      danger: blend(danger, other.danger),
      navBackground: blend(navBackground, other.navBackground),
      navSelectedBackground: blend(
        navSelectedBackground,
        other.navSelectedBackground,
      ),
      navSelectedForeground: blend(
        navSelectedForeground,
        other.navSelectedForeground,
      ),
      navIdleForeground: blend(navIdleForeground, other.navIdleForeground),
      inputFill: blend(inputFill, other.inputFill),
      inputHint: blend(inputHint, other.inputHint),
      userBubble: blend(userBubble, other.userBubble),
      assistantBubble: blend(assistantBubble, other.assistantBubble),
      bottomSheetBackground: blend(
        bottomSheetBackground,
        other.bottomSheetBackground,
      ),
      streakBackground: blend(streakBackground, other.streakBackground),
      streakBorder: blend(streakBorder, other.streakBorder),
      streakText: blend(streakText, other.streakText),
    );
  }
}

extension EliaThemeColorsBuildContextX on BuildContext {
  EliaThemeColors get eliaColors =>
      Theme.of(this).extension<EliaThemeColors>()!;
}
