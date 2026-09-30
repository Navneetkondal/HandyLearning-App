import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit managing the application's [ThemeMode].
///
/// This serves as an immediate, practical example of Cubit state management:
/// 1. State is [ThemeMode] (light, dark, or system).
/// 2. Cubit exposes methods: [toggleTheme], [setTheme].
/// 3. Emitting a new state triggers rebuild in [MaterialApp] via [BlocBuilder].
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  /// Toggles between light and dark mode.
  void toggleTheme() {
    if (state == ThemeMode.dark) {
      emit(ThemeMode.light);
    } else {
      emit(ThemeMode.dark);
    }
  }

  /// Sets a specific theme mode.
  void setTheme(ThemeMode mode) {
    emit(mode);
  }

  /// Helper to check if current mode is dark (assuming system dark if system).
  bool isDarkMode(BuildContext context) {
    if (state == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return state == ThemeMode.dark;
  }
}
