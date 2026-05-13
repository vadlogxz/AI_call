import 'package:elia/feature/auth/di/auth_provider.dart';
import 'package:elia/feature/auth/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthRepository authRepository = ref.watch(authRepositoryProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShadButton(
              onPressed: () => authRepository.signInWithGoogle(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.login),
                  SizedBox(width: 8),
                  Text('Sign in with Google'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
