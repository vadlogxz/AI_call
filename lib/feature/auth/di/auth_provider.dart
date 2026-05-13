import 'package:elia/feature/auth/data/repositories/firebase_auth_repository.dart';
import 'package:elia/feature/auth/domain/models/auth_state.dart';
import 'package:elia/feature/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => FirebaseAuthRepository(),
);

final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});
