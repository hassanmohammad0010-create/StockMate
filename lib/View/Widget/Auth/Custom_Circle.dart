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
    return OverflowBox(
      alignment: Alignment(xAlignment, yAlignment),

      maxWidth: MediaQuery.of(context).size.width * size,
      maxHeight: MediaQuery.of(context).size.width * size,
      child: Container(
        width: MediaQuery.of(context).size.width * size,
        height: MediaQuery.of(context).size.width * size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
