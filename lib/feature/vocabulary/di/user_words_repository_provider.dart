import 'package:elia/core/di/core_providers.dart';
import 'package:elia/feature/auth/di/auth_provider.dart';
import 'package:elia/feature/auth/domain/models/auth_state.dart';
import 'package:elia/feature/vocabulary/data/repositories/user_words_repository_impl.dart';
import 'package:elia/feature/vocabulary/domain/repositories/user_words_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userWordsRepositoryProvider = Provider<UserWordsRepository>((ref) {
  final authState = ref.watch(authStateProvider).requireValue;
  final userId = (authState as Authenticated).user.id;
  return UserWordsRepositoryImpl(
    firestore: ref.watch(firestoreProvider),
    userId: userId,
  );
});
