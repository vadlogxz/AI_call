import 'package:flutter/material.dart';

enum ThemePreference {
  system,
  light,
  dark;

  ThemeMode get themeMode => switch (this) {
    ThemePreference.system => ThemeMode.system,
    ThemePreference.light => ThemeMode.light,
    ThemePreference.dark => ThemeMode.dark,
  };

  String get storageValue => name;

  static ThemePreference fromStorage(String? value) {
    return ThemePreference.values.firstWhere(
      (item) => item.name == value,
      orElse: () => ThemePreference.system,
    );
  }
}
