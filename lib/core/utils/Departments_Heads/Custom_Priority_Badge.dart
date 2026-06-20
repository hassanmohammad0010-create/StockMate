// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';

class PriorityBadge extends StatelessWidget {
  final OrderPriority priority;

  // ignore: use_key_in_widget_constructors
  const PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    final isUrgent = priority == OrderPriority.urgent;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: context.screenHeight * 0.002,
        horizontal: context.screenWidth * 0.01,
      ),
      width: context.screenWidth * 0.15,
      decoration: BoxDecoration(
        color: isUrgent ? constRed : constBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          isUrgent ? 'ضروري' : 'عادي',
          style: TextStyle(
            fontSize: 20,
            fontFamily: lateef,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
