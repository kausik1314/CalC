import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculatorButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final Color? textColor;
  final bool isOperator;
  final bool isEmpty;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.onTap,
    this.textColor,
    this.isOperator = false,
    this.isEmpty = false,
  });

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    HapticFeedback.lightImpact();
    setState(() => _isPressed = true);
  }
  
  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onTap();
  }
  
  void _onTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    if (widget.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = theme.scaffoldBackgroundColor;
    
    final shadowDark = isDark ? const Color(0xFF1F252E) : const Color(0xFFA3B1C6);
    final shadowLight = isDark ? const Color(0xFF37414E) : Colors.white;

    final defaultTextCol = isDark ? Colors.white : const Color(0xFF4A4A4A);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: _isPressed
              ? null
              : [
                  BoxShadow(color: shadowDark, offset: const Offset(4, 4), blurRadius: 8, spreadRadius: 0),
                  BoxShadow(color: shadowLight, offset: const Offset(-4, -4), blurRadius: 8, spreadRadius: 0),
                ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: _isPressed ? Border.all(color: shadowDark.withValues(alpha: 0.4), width: 1.5) : null,
          ),
          child: Center(
             child: widget.text == '⌫' 
                ? Icon(Icons.backspace_outlined, size: 24, color: widget.textColor ?? defaultTextCol)
                : Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: widget.isOperator ? 26 : 24,
                      fontWeight: widget.isOperator ? FontWeight.bold : FontWeight.w500,
                      color: widget.textColor ?? defaultTextCol,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
