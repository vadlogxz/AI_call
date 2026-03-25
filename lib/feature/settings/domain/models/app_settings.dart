import 'package:elia/feature/settings/domain/models/theme_preference.dart';

class AppSettings {
  const AppSettings({
    this.speakingLanguage = 'uk',
    this.themePreference = ThemePreference.system,
    this.autoSend = true,
    this.hapticFeedback = true,
    this.saveHistory = false,
    this.streak = 0,
    this.lastActivityDate,
  });

  final String speakingLanguage;
  final ThemePreference themePreference;
  final bool autoSend;
  final bool hapticFeedback;
  final bool saveHistory;

  /// Consecutive days with at least one session.
  final int streak;

  /// ISO-8601 date string of the last session day (YYYY-MM-DD).
  final String? lastActivityDate;

  AppSettings copyWith({
    String? speakingLanguage,
    ThemePreference? themePreference,
    bool? autoSend,
    bool? hapticFeedback,
    bool? saveHistory,
    int? streak,
    String? lastActivityDate,
  }) {
    return AppSettings(
      speakingLanguage: speakingLanguage ?? this.speakingLanguage,
      themePreference: themePreference ?? this.themePreference,
      autoSend: autoSend ?? this.autoSend,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      saveHistory: saveHistory ?? this.saveHistory,
      streak: streak ?? this.streak,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
    );
  }
}
