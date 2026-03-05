import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../utils/calculator_logic.dart';

class ScientificRow extends StatelessWidget {
  const ScientificRow({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = context.read<CalculatorLogic>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final functions = ['sin', 'cos', 'tan', 'log', 'ln', '√', 'x²', 'π', 'e'];
    
    final shadowDark = isDark ? const Color(0xFF1F252E) : const Color(0xFFA3B1C6);
    final shadowLight = isDark ? const Color(0xFF37414E) : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 52,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: functions.length,
          itemBuilder: (context, index) {
            final func = functions[index];
            return GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                logic.onButtonPressed(func);
              },
              child: Container(
                margin: const EdgeInsets.only(right: 12, top: 4, bottom: 4, left: 2),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: shadowDark, offset: const Offset(3, 3), blurRadius: 4),
                    BoxShadow(color: shadowLight, offset: const Offset(-3, -3), blurRadius: 4),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  func,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
