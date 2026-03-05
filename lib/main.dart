import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'providers/theme_provider.dart';
import 'utils/calculator_logic.dart';
import 'screens/calculator_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CalculatorLogic()),
      ],
      child: const CalcApp(),
    ),
  );
}

class CalcApp extends StatelessWidget {
  const CalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    final lightTheme = AppTheme.lightTheme.copyWith(
      textTheme: GoogleFonts.outfitTextTheme(AppTheme.lightTheme.textTheme),
    );
    
    final darkTheme = AppTheme.darkTheme.copyWith(
      textTheme: GoogleFonts.outfitTextTheme(AppTheme.darkTheme.textTheme).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    );

    return MaterialApp(
      title: 'Premium Calculator',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const CalculatorScreen(),
    );
  }
}
