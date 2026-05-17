import 'package:elia/core/di/core_providers.dart';
import 'package:elia/feature/vocabulary/data/repositories/vocabulary_repository_impl.dart';
import 'package:elia/feature/vocabulary/domain/repositories/vocabulary_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final vocabularyRepositoryProvider = Provider<VocabularyRepository>((ref) {
  return VocabularyRepositoryImpl(
    firestore: ref.watch(firestoreProvider),
    apiClient: ref.watch(apiClientProvider),
    firebaseAuth: ref.watch(firebaseAuthProvider),
  );
});
