import 'dart:convert';

import 'package:elia/feature/dictionary/domain/models/vocabulary_word.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/di/shared_preferences_provider.dart';

class VocabularyRepository {
  VocabularyRepository(this._prefs);

  final SharedPreferences _prefs;
  static const _key = 'vocabulary_words';

  List<VocabularyWord> getAll() {
    final raw = _prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => VocabularyWord.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.addedAt.compareTo(a.addedAt));
  }

  Future<void> add(VocabularyWord word) async {
    final words = getAll();
    if (words.any((w) => w.id == word.id)) return;
    words.insert(0, word);
    await _save(words);
  }

  Future<void> remove(String id) async {
    final words = getAll()..removeWhere((w) => w.id == id);
    await _save(words);
  }

  Future<void> _save(List<VocabularyWord> words) async {
    await _prefs.setString(_key, jsonEncode(words.map((w) => w.toJson()).toList()));
  }
}

final vocabularyRepositoryProvider = Provider<VocabularyRepository>((ref) {
  return VocabularyRepository(ref.watch(sharedPreferencesProvider));
});
