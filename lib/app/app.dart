import 'package:elia/app/router/router_provider.dart';
import 'package:elia/app/theme/app_theme.dart';
import 'package:elia/feature/profile/presentation/state/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final GoRouter router = ref.watch(routerProvider);

    final isDark = switch (settings.themePreference.themeMode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system =>
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark,
    };

    return ShadApp.router(
      themeMode: settings.themePreference.themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      materialThemeBuilder: (context, theme) => theme.copyWith(
        brightness: isDark ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: isDark ? null : null,
        colorScheme: (isDark
                ? AppTheme.materialDark
                : AppTheme.materialLight)
            .colorScheme,
        textTheme: isDark
            ? AppTheme.materialDark.textTheme
            : AppTheme.materialLight.textTheme,
        appBarTheme: isDark ? AppTheme.materialDark.appBarTheme : null,
        inputDecorationTheme: isDark
            ? AppTheme.materialDark.inputDecorationTheme
            : null,
      ),
      routerConfig: router,
    );
  }
}
