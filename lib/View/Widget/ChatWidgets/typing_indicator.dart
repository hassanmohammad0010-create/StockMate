import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: h * 0.01),
        padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.01),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(18),
        ),
        child: SizedBox(
          width: w * 0.12,
          child: AnimatedBuilder(
            animation: controller,
            builder: (_, _) {
              final value = controller.value;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _dot(value, 0.0),
                  _dot(value, 0.2),
                  _dot(value, 0.4),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _dot(double value, double delay) {
    double progress = (value - delay);
    if (progress < 0) progress += 1;

    // حركة صعود وهبوط ناعمة
    final double scale = 1.0 + 0.3 * _bounce(progress);
    final double opacity = 0.5 + 0.5 * _bounce(progress);

    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: constBlue,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  double _bounce(double x) {
    // معادلة منحنى ناعم للصعود والهبوط
    return (1 - (2 * x - 1) * (2 * x - 1));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
