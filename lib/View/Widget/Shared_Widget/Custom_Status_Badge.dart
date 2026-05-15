// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';

class StatusBadge extends StatelessWidget {
  final OrderStatus status;

  // ignore: use_key_in_widget_constructors
  const StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    late String label;
    late Color bgColor;
    late Color textColor;

    switch (status) {
      case OrderStatus.completed:
        label = 'تم الإنجاز';
        bgColor = const Color(0xFFE3FDED);
        textColor = const Color(0xFF09C05E);
        break;
      case OrderStatus.rejected:
        label = 'مرفوضة';
        bgColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFE53935);
        break;
      case OrderStatus.inProgress:
        label = 'قيد التنفيذ';
        bgColor = const Color(0xFFE3F2FD);
        textColor = constBlue;
        break;
      case OrderStatus.suspended:
        label = 'معلق';
        bgColor = const Color(0xFFFFF8E2);
        textColor = const Color(0xFFFFBF00);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
