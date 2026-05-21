import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

// ignore: must_be_immutable
class CustomCircle extends StatelessWidget {
  Widget? columnChild;
  double width, height;
  CustomCircle({
    super.key,
    this.columnChild,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 300,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            center: Alignment(-0.2, 0.3), // Adjust gradient center position
            colors: [constBlue, constColor],
            stops: [0.4, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 2,
              offset: Offset(-10, -8), // Left-up direction shadow
            ),
          ],
        ),
        alignment: Alignment.center,
        child: columnChild ?? Text(''),
      ),
    );
  }
}
