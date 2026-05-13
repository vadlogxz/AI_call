import 'package:elia/feature/auth/domain/models/auth_state.dart';

abstract class AuthRepository {
  Stream<AuthState> get authStateChanges;
  Future<void> signInWithGoogle();
  Future<void> signOut();
}