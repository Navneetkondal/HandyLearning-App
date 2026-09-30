import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/home/screens/home_dashboard_screen.dart';

/// Entry point of the Flutter Learning Hub application.
///
/// Architecture Overview:
/// 1. Root initializes [ThemeCubit] via [BlocProvider].
/// 2. [MaterialApp] is wrapped with [BlocBuilder<ThemeCubit, ThemeMode>],
///    enabling instant, reactive switching between Light and Dark themes.
/// 3. Navigation routes to [HomeDashboardScreen], which opens interactive
///    learning modules for UI Components, StatelessWidget vs StatefulWidget,
///    Cubit State Management, and the Repository Pattern.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FlutterLearningHubApp());
}

class FlutterLearningHubApp extends StatelessWidget {
  const FlutterLearningHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Flutter Learning Hub',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: const HomeDashboardScreen(),
          );
        },
      ),
    );
  }
}
