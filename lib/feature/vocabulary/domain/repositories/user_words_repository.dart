import 'package:elia/feature/vocabulary/domain/models/word_entry.dart';

abstract interface class UserWordsRepository {
  Future<void> addWord(WordEntry word) async {
  }
}