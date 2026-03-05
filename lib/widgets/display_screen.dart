import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/calculator_logic.dart';

class DisplayScreen extends StatelessWidget {
  const DisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logic = context.watch<CalculatorLogic>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      alignment: Alignment.bottomRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (logic.previousInput.isNotEmpty || logic.operator.isNotEmpty)
            Text(
              '${logic.previousInput} ${logic.operator}',
              style: TextStyle(
                fontSize: 24,
                color: theme.colorScheme.primary.withValues(alpha: 0.8), 
                fontWeight: FontWeight.w400,
              ),
            ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              logic.currentInput,
              style: TextStyle(
                fontSize: 80, 
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyLarge?.color, 
                letterSpacing: -2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
