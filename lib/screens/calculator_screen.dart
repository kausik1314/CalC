import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../utils/calculator_logic.dart';
import '../widgets/calculator_button.dart';
import '../widgets/display_screen.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);
    final logic = context.read<CalculatorLogic>();

    final List<List<String>> buttons = [
      ['C', '±', '%', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '−'],
      ['1', '2', '3', '+'],
      ['0', '.', '⌫', '='],
    ];

    Color getTextColor(String text) {
      if (['C', '±', '%', '÷', '×', '−', '+', '=', '⌫'].contains(text)) {
        return theme.colorScheme.primary; 
      }
      return theme.textTheme.bodyLarge?.color ?? Colors.white;
    }

    Widget themeToggle() {
      bool isDark = themeProvider.isDarkMode;
      Color shadowDark = isDark ? const Color(0xFF1F252E) : const Color(0xFFA3B1C6);
      Color shadowLight = isDark ? const Color(0xFF37414E) : Colors.white;

      return GestureDetector(
        onTap: () => themeProvider.toggleTheme(),
        child: Container(
          width: 84,
          height: 40,
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: shadowDark, offset: const Offset(3, 3), blurRadius: 6),
              BoxShadow(color: shadowLight, offset: const Offset(-3, -3), blurRadius: 6),
            ],
          ),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   const SizedBox(width: 2),
                  Icon(Icons.wb_sunny_rounded, size: 20, color: isDark ? Colors.grey.withOpacity(0.5) : Colors.amber),
                  Icon(Icons.nightlight_round, size: 20, color: isDark ? Colors.greenAccent : Colors.grey.withOpacity(0.5)),
                   const SizedBox(width: 2),
                ],
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                left: isDark ? 44 : 4,
                top: 4,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF262D36) : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: shadowDark.withOpacity(0.4), blurRadius: 4)]
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            themeToggle(),
            const Expanded(
              flex: 3,
              child: DisplayScreen(),
            ),
            Expanded(
              flex: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Column(
                  children: buttons.map((row) {
                    return Expanded(
                      child: Row(
                        children: row.map((text) {
                          return Expanded(
                            child: CalculatorButton(
                              text: text,
                              textColor: getTextColor(text),
                              isOperator: ['÷', '×', '−', '+', '=', 'C', '±', '%', '⌫'].contains(text),
                              onTap: () => logic.onButtonPressed(text),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
