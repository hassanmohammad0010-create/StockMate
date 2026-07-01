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
      case OrderStatus.reserved:
        label = 'مستلم';
        bgColor = constLightGreen;
        textColor = constGreen;
        break;
      case OrderStatus.completed:
        label = 'تم الإنجاز';
        bgColor = constLightGreen;
        textColor = constGreen;
        break;
      case OrderStatus.rejected:
        label = 'مرفوض';
        bgColor = constLightRed;
        textColor = constRed;
        break;
      case OrderStatus.inProgress:
        label = 'قيد التنفيذ';
        bgColor = constLightBlue;
        textColor = constBlue;
        break;
      case OrderStatus.suspended:
        label = 'معلق';
        bgColor = constLightOrange;
        textColor = constOrange;
        break;
    }
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: context.screenHeight * 0.002,
        horizontal: context.screenWidth * 0.01,
      ),
      width: context.screenWidth * 0.18,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontFamily: lateef,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
