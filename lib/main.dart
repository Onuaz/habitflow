import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: "HabitFlow",
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
  cardColor: const Color(0xFFF1F6FB),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF1E88E5),
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
  ),
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

      themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
      routes: {
        '/settings': (_) => const SettingsScreen(),
      },
    );
  }
}
