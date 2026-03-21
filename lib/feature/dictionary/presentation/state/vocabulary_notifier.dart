import 'package:elia/feature/call/data/models/conversation_response.dart';
import 'package:elia/feature/dictionary/data/repositories/vocabulary_repository.dart';
import 'package:elia/feature/dictionary/domain/models/vocabulary_word.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class VocabularyNotifier extends Notifier<List<VocabularyWord>> {
  late final VocabularyRepository _repo;
  final _uuid = const Uuid();

  @override
  List<VocabularyWord> build() {
    _repo = ref.watch(vocabularyRepositoryProvider);
    return _repo.getAll();
  }

  Future<void> addFromVocabWord(VocabWord word) async {
    final entry = VocabularyWord(
      id: _uuid.v4(),
      word: word.word,
      translation: word.translation,
      partOfSpeech: word.partOfSpeech,
      example: word.example,
      addedAt: DateTime.now(),
    );
    await _repo.add(entry);
    state = _repo.getAll();
  }

  Future<void> addWord(VocabularyWord word) async {
    await _repo.add(word);
    state = _repo.getAll();
  }

  Future<void> removeWord(String id) async {
    await _repo.remove(id);
    state = _repo.getAll();
  }
}

final vocabularyProvider =
    NotifierProvider<VocabularyNotifier, List<VocabularyWord>>(
  VocabularyNotifier.new,
);
