import 'package:elia/feature/settings/data/repositories/settings_repository.dart';
import 'package:elia/feature/settings/domain/models/app_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsNotifier extends Notifier<AppSettings> {
  late final SettingsRepository _repo;

  @override
  AppSettings build() {
    _repo = ref.watch(settingsRepositoryProvider);
    return _repo.load();
  }

  Future<void> setSpeakingLanguage(String code) async {
    state = state.copyWith(speakingLanguage: code);
    await _repo.save(state);
  }

  Future<void> setAutoSend(bool value) async {
    state = state.copyWith(autoSend: value);
    await _repo.save(state);
  }

  Future<void> setHapticFeedback(bool value) async {
    state = state.copyWith(hapticFeedback: value);
    await _repo.save(state);
  }

  Future<void> setSaveHistory(bool value) async {
    state = state.copyWith(saveHistory: value);
    await _repo.save(state);
  }

  /// Call after a session completes to update the daily streak.
  Future<void> recordSession() async {
    final today = _todayStr();
    final last = state.lastActivityDate;

    int newStreak;
    if (last == null) {
      newStreak = 1;
    } else if (last == today) {
      // Already recorded today, no change.
      return;
    } else if (_isYesterday(last, today)) {
      newStreak = state.streak + 1;
    } else {
      // Gap > 1 day → reset.
      newStreak = 1;
    }

    state = state.copyWith(streak: newStreak, lastActivityDate: today);
    await _repo.save(state);
  }

  static String _todayStr() {
    final d = DateTime.now();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  static bool _isYesterday(String last, String today) {
    try {
      final l = DateTime.parse(last);
      final t = DateTime.parse(today);
      return t.difference(l).inDays == 1;
    } catch (_) {
      return false;
    }
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);
