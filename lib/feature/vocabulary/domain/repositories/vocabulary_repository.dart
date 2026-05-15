import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elia/feature/vocabulary/domain/models/word_entry.dart';

abstract interface class VocabularyRepository {

  Future<WordEntry> getWord(String word);
}