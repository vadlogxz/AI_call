import 'package:elia/core/di/shared_preferences_provider.dart';
import 'package:elia/feature/settings/domain/models/app_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _kSpeakingLanguage = 'speaking_language';
  static const _kAutoSend = 'auto_send';
  static const _kHapticFeedback = 'haptic_feedback';
  static const _kSaveHistory = 'save_history';
  static const _kStreak = 'streak';
  static const _kLastActivityDate = 'last_activity_date';

  AppSettings load() {
    return AppSettings(
      speakingLanguage: _prefs.getString(_kSpeakingLanguage) ?? 'uk',
      autoSend: _prefs.getBool(_kAutoSend) ?? true,
      hapticFeedback: _prefs.getBool(_kHapticFeedback) ?? true,
      saveHistory: _prefs.getBool(_kSaveHistory) ?? false,
      streak: _prefs.getInt(_kStreak) ?? 0,
      lastActivityDate: _prefs.getString(_kLastActivityDate),
    );
  }

  Future<void> save(AppSettings settings) async {
    await _prefs.setString(_kSpeakingLanguage, settings.speakingLanguage);
    await _prefs.setBool(_kAutoSend, settings.autoSend);
    await _prefs.setBool(_kHapticFeedback, settings.hapticFeedback);
    await _prefs.setBool(_kSaveHistory, settings.saveHistory);
    await _prefs.setInt(_kStreak, settings.streak);
    if (settings.lastActivityDate != null) {
      await _prefs.setString(_kLastActivityDate, settings.lastActivityDate!);
    }
  }
}

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(sharedPreferencesProvider));
});
