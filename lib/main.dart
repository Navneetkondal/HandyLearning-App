import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/home/screens/home_dashboard_screen.dart';

import 'features/ios_senior_prep/screens/ios_master_handbook_screen.dart';

/// Entry point of the handyLearn application.
///
/// Architecture Overview:
/// 1. Root initializes [ThemeCubit] via [BlocProvider].
/// 2. [MaterialApp] is wrapped with [BlocBuilder<ThemeCubit, ThemeMode>],
///    enabling instant, reactive switching between Light and Dark themes.
/// 3. Defaults to [IosMasterHandbookScreen] (Swift & iOS Technical Handbook),
///    with 1-tap navigation to [HomeDashboardScreen] for general Flutter engineering labs.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HandyLearnApp());
}

class HandyLearnApp extends StatelessWidget {
  final Widget? initialHome;

  const HandyLearnApp({super.key, this.initialHome});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Swift & iOS Handbook',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: initialHome ?? const IosMasterHandbookScreen(),
          );
        },
      ),
    );
  }
}

/// Backwards compatibility alias
typedef FlutterLearningHubApp = HandyLearnApp;
