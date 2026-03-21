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
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);
