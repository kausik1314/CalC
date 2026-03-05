import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../providers/theme_provider.dart';
import '../utils/calculator_logic.dart';
import '../widgets/calculator_button.dart';
import '../widgets/display_screen.dart';
import '../widgets/animated_background.dart';
import '../widgets/scientific_row.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  void _showHistoryModal(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final logic = context.watch<CalculatorLogic>();
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF262D36).withValues(alpha: 0.95) : const Color(0xFFE2E7ED).withValues(alpha: 0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 24),
              Text('Calculation History', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color)),
              const SizedBox(height: 16),
              Expanded(
                child: logic.history.isEmpty 
                  ? Center(child: Text("No history yet.", style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6))))
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: logic.history.length,
                      itemBuilder: (context, index) {
                        final item = logic.history[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                          title: Text(item.equation, style: TextStyle(fontSize: 18, color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6)), textAlign: TextAlign.right),
                          subtitle: Text(item.result, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: theme.colorScheme.primary), textAlign: TextAlign.right),
                        );
                      },
                    ),
              ),
              if (logic.history.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: TextButton(
                    onPressed: () { logic.clearHistory(); Navigator.pop(context); },
                    child: const Text("Clear History", style: TextStyle(color: Colors.redAccent, fontSize: 16)),
                  ),
                )
            ],
          ),
        );
      }
    );
  }

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
        onTap: () {
          HapticFeedback.lightImpact();
          themeProvider.toggleTheme();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
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
                  Icon(Icons.wb_sunny_rounded, size: 20, color: isDark ? Colors.grey.withValues(alpha: 0.5) : Colors.amber),
                  Icon(Icons.nightlight_round, size: 20, color: isDark ? Colors.greenAccent : Colors.grey.withValues(alpha: 0.5)),
                   const SizedBox(width: 2),
                ],
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                left: isDark ? 44 : 4,
                top: 4,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF262D36) : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: shadowDark.withValues(alpha: 0.4), blurRadius: 4)]
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent, // Background handled by AnimatedBackground
      body: AnimatedBackground(
        isDark: themeProvider.isDarkMode,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.history_rounded, color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.8), size: 28),
                      onPressed: () => _showHistoryModal(context),
                    ),
                    themeToggle(),
                    const SizedBox(width: 48), // Balance the row
                  ],
                ),
              ),
              const Expanded(
                flex: 4,
                child: DisplayScreen(),
              ),
              const ScientificRow(),
              const SizedBox(height: 16),
              Expanded(
                flex: 7,
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
      ),
    );
  }
}
