import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
// If you have it, keep it. If not, I’ll help you add it.
import 'screens/welcome_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const HabitFlowApp(),
    ),
  );
}

class HabitFlowApp extends StatelessWidget {
  const HabitFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "HabitFlow",

          // 🌟 START HERE (FIXED FLOW)
          home: const WelcomeScreen(),

          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color(0xFF1E88E5),
            scaffoldBackgroundColor: Colors.white,
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E88E5),
              secondary: Color(0xFF43A047),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E88E5),
              foregroundColor: Colors.white,
            ),
            cardColor: Color(0xFFF1F6FB),
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF1E88E5),
              secondary: Color(0xFF43A047),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E88E5),
              foregroundColor: Colors.white,
            ),
          ),

          themeMode:
              themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,

          routes: {
            '/home': (_) => const HomeScreen(),
            '/settings': (_) => const SettingsScreen(),
          },
        );
      },
    );
  }
}