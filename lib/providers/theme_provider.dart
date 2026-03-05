import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark; 

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

class AppColors {
  // Dark Theme
  static const Color darkBackground = Color(0xFF2B333E);
  static const Color darkOperatorColor = Color(0xFF2BD28A); 
  
  // Light Theme
  static const Color lightBackground = Color(0xFFE0E5EC);
  static const Color lightOperatorColor = Color(0xFF1FA36B);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        surface: AppColors.lightBackground,
        primary: AppColors.lightOperatorColor,
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.darkBackground,
        primary: AppColors.darkOperatorColor,
      ),
      useMaterial3: true,
    );
  }
}
