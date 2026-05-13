import 'package:elia/app/router/app_routes.dart';
import 'package:elia/app/shell/main_shell.dart';
import 'package:elia/feature/auth/presentation/login_screen.dart';
import 'package:elia/feature/dictionary/presentation/pages/dictionary_screen.dart';
import 'package:elia/feature/home/presentation/screens/home_screen.dart';
import 'package:elia/feature/profile/presentation/pages/profile_screen.dart';
import 'package:go_router/go_router.dart';

final appRoutes = <RouteBase>[
  GoRoute(
    path: AppRoutes.login.path,
    name: AppRoutes.login.name,
    builder: (context, state) => const LoginScreen(),
  ),
  ShellRoute(
    builder: (context, state, child) => AppShell(child: child),
    routes: [
      GoRoute(
        path: AppRoutes.home.path,
        name: AppRoutes.home.name,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.dictionary.path,
        name: AppRoutes.dictionary.name,
        builder: (context, state) => const DictionaryScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile.path,
        name: AppRoutes.profile.name,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  ),
];
