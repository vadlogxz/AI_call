import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elia/feature/vocabulary/domain/models/user_word.dart';
import 'package:elia/feature/vocabulary/domain/models/word_entry.dart';
import 'package:elia/feature/vocabulary/domain/repositories/user_words_repository.dart';

class UserWordsRepositoryImpl implements UserWordsRepository {
  UserWordsRepositoryImpl({
    required FirebaseFirestore firestore,
    required String userId,
  })  : _firestore = firestore,
        _userId = userId;

  final FirebaseFirestore _firestore;
  final String _userId;

  @override
  Future<void> addWord(WordEntry word) async {
    final ref = _firestore
        .collection('users')
        .doc(_userId)
        .collection('user_words')
        .doc(word.id);

    final existing = await ref.get();
    if (existing.exists) return;

    final now = DateTime.now();
    final userWord = UserWord(
      wordId: word.id,
      addedAt: now,
      repetitions: 0,
      easeFactor: 2.5,
      interval: 0,
      nextReview: now.add(const Duration(days: 1)),
    );

    await ref.set(userWord.toJson());
  }
}
