// ignore_for_file: file_names

import 'dart:math' as math;
import 'package:flutter/material.dart';

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double radius;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final dashedPath = _dashPath(path, dashArray: [gap, gap]);
    canvas.drawPath(dashedPath, paint);
  }

  Path _dashPath(Path source, {required List<double> dashArray}) {
    final Path dest = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0;
      bool draw = true;
      int index = 0;
      while (distance < metric.length) {
        final len = dashArray[index % dashArray.length];
        if (draw) {
          dest.addPath(
            metric.extractPath(
              distance,
              math.min(distance + len, metric.length),
            ),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
        index++;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
