import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final bool isDark;

  const AnimatedBackground({super.key, required this.child, required this.isDark});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final darkColors = [const Color(0xFF2B333E), const Color(0xFF262E38), const Color(0xFF232A32)];
    final lightColors = [const Color(0xFFE0E5EC), const Color(0xFFDDE3EB), const Color(0xFFE3E8EE)];
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final colors = widget.isDark ? darkColors : lightColors;
        
        final Color c1 = Color.lerp(colors[0], colors[1], _controller.value) ?? colors[0];
        final Color c2 = Color.lerp(colors[1], colors[2], _controller.value) ?? colors[1];

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [c1, c2],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}
