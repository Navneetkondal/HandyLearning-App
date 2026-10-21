import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Cubit managing the application's [ThemeMode].
///
/// This serves as an immediate, practical example of Cubit state management:
/// 1. State is [ThemeMode] (light, dark, or system).
/// 2. Cubit exposes methods: [toggleTheme], [setTheme].
/// 3. Emitting a new state triggers rebuild in [MaterialApp] via [BlocBuilder].
/// 4. Persists user preference via [SharedPreferences] across application restarts.
class ThemeCubit extends Cubit<ThemeMode> {
  static const _prefKey = 'app_theme_mode';

  ThemeCubit() : super(ThemeMode.system) {
    _loadSavedTheme();
  }

  Future<void> _loadSavedTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_prefKey);
      if (saved == 'light') {
        emit(ThemeMode.light);
      } else if (saved == 'dark') {
        emit(ThemeMode.dark);
      } else if (saved == 'system') {
        emit(ThemeMode.system);
      }
    } catch (_) {
      // Graceful fallback if SharedPreferences is unavailable in tests
    }
  }

  /// Toggles between light and dark mode.
  void toggleTheme() {
    if (state == ThemeMode.dark) {
      setTheme(ThemeMode.light);
    } else {
      setTheme(ThemeMode.dark);
    }
  }

  /// Sets a specific theme mode and persists it.
  void setTheme(ThemeMode mode) {
    emit(mode);
    _persistTheme(mode);
  }

  Future<void> _persistTheme(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, mode.name);
    } catch (_) {
      // Ignore persistence failure in transient environments
    }
  }

  /// Helper to check if current mode is dark (assuming system dark if system).
  bool isDarkMode(BuildContext context) {
    if (state == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return state == ThemeMode.dark;
  }
}
