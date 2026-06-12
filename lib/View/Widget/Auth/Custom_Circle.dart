import 'package:flutter/material.dart';

class CustomCircle extends StatelessWidget {
  const CustomCircle({
    super.key,
    required this.xAlignment,
    required this.yAlignment,
    this.child,
    required this.size,
    required this.color,
  });
  final double xAlignment, yAlignment, size;
  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final double base = MediaQuery.of(context).size.shortestSide;
    final double circleSize = base * size;

    return OverflowBox(
      alignment: Alignment(xAlignment, yAlignment),
      maxWidth: circleSize,
      maxHeight: circleSize,
      child: Container(
        width: circleSize,
        height: circleSize,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
