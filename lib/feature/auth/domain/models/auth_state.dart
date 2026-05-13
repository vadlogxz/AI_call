import 'package:elia/feature/auth/domain/models/user.dart';

sealed class AuthState {
  const AuthState();
}

final class Authenticated extends AuthState {
  const Authenticated({
    required this.user
  });

  final User user;
}

final class Unauthenticated extends AuthState {
  const Unauthenticated();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}