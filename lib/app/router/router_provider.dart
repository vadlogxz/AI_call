import 'package:elia/app/router/app_router.dart';
import 'package:elia/core/logging/app_logger.dart';
import 'package:elia/feature/auth/di/auth_provider.dart';
import 'package:elia/feature/auth/domain/models/auth_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>(
        (ref) {
      final authState = ref.watch(authStateProvider);

      return GoRouter(
        navigatorKey: _rootNavigatorKey,
        routes: appRoutes,
        initialLocation: '/login',
        redirect: (context, state) async {
          // final token = await FirebaseAuth.instance.currentUser?.getIdToken();
          // debugPrint('TOKEN: $token');

          if (authState.isLoading) return null;
          final isLoggedIn = authState.asData?.value is Authenticated;
          final isOnLoginPage = state.matchedLocation == '/login';

          if(!isLoggedIn && !isOnLoginPage) {
            AppLogger.debug('User is not authenticated. Redirecting to login page.', tag: LogTag.router);
            return '/login';
          }
          if(isLoggedIn && isOnLoginPage) {
            AppLogger.debug('User is authenticated. Redirecting to home page.', tag: LogTag.router);
            return '/home';
        }
          return null;
        },
      );
    }
);
