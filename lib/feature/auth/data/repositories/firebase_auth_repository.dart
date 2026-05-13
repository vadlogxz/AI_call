import 'package:elia/core/config/app_config.dart';
import 'package:elia/feature/auth/domain/models/auth_state.dart';
import 'package:elia/feature/auth/domain/models/user.dart';
import 'package:elia/feature/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';

/// Web Client ID: Firebase Console → Authentication → Sign-in method → Google → Web SDK configuration
const _webClientId = AppConfig.googleWebClientId;

class FirebaseAuthRepository implements AuthRepository {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;


  @override
  Future<void> signInWithGoogle() async {
    await GoogleSignIn.instance.initialize(serverClientId: _webClientId);
    final googleUser = await GoogleSignIn.instance.authenticate();
    final googleAuth = googleUser.authentication;
    final credential = fb.GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    await _auth.signInWithCredential(credential);
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      GoogleSignIn.instance.signOut(),
    ]);
  }

  @override
  Stream<AuthState> get authStateChanges {
    return _auth.authStateChanges().map((fbUser) {
      if (fbUser != null) {
        return Authenticated(
          user: User(
            id: fbUser.uid,
            email: fbUser.email ?? '',
            name: fbUser.displayName,
          ),
        );
      } else {
        return const Unauthenticated();
      }
    });
  }
}
