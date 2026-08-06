// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Test/RefillRequestsPageData.dart';

class PriorityBadge extends StatelessWidget {
  final OrderPriority priority;

  const PriorityBadge({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    final isUrgent = priority == OrderPriority.urgent;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: h * 0.002,
        horizontal: w * 0.01,
      ),
      width: w * 0.15,
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