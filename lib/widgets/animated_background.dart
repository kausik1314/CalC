import 'package:flutter/material.dart';

class AnimatedBackground extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const AnimatedBackground({super.key, required this.child, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final darkColors = [const Color(0xFF2B333E), const Color(0xFF232A32)];
    final lightColors = [const Color(0xFFE0E5EC), const Color(0xFFE3E8EE)];
    
    final targetColors = isDark ? darkColors : lightColors;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: targetColors,
        ),
      ),
      child: child,
    );
  }
}
