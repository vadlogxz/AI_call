import 'package:elia/core/di/shared_preferences_provider.dart';
import 'package:elia/core/presentation/pages/main_shell.dart';
import 'package:elia/feature/settings/presentation/state/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return ShadApp.custom(
      themeMode: settings.themePreference.themeMode,
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadZincColorScheme.light(),
      ),
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadSlateColorScheme.dark(),
      ),
      appBuilder: (context) {
        return MaterialApp(
          themeMode: settings.themePreference.themeMode,
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          home: const MainShell(),
          builder: (context, child) {
            return ShadAppBuilder(child: child!);
          },
        );
      },
    );
  }
}

ThemeData _buildLightTheme() {
  const scheme = ColorScheme.light(
    primary: Color(0xFF2563EB),
    secondary: Color(0xFF0F766E),
    surface: Color(0xFFF7F9FC),
    onSurface: Color(0xFF111827),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: const Color(0xFFF7F9FC),
    cardColor: Colors.white,
    dividerColor: const Color(0xFFD9E1EC),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF7F9FC),
      foregroundColor: Color(0xFF111827),
      elevation: 0,
    ),
  );
}

ThemeData _buildDarkTheme() {
  const scheme = ColorScheme.dark(
    primary: Color(0xFF60A5FA),
    secondary: Color(0xFF34D399),
    surface: Color(0xFF0A0D14),
    onSurface: Color(0xFFE8EAF5),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: const Color(0xFF0A0D14),
    cardColor: const Color(0xFF0F172A),
    dividerColor: const Color(0xFF1E293B),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0A0D14),
      foregroundColor: Color(0xFFE8EAF5),
      elevation: 0,
    ),
  );
}
