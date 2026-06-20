// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';

class RecurringBadge extends StatelessWidget {
  final RecurringInterval interval;

  const RecurringBadge({super.key, required this.interval});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: context.screenHeight * 0.002,
        horizontal: context.screenWidth * 0.01,
      ),
      width: context.screenWidth * 0.18,
      decoration: BoxDecoration(
        color: const Color(0xFFEDE9FE),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.repeat, size: 14, color: Color(0xFF7C3AED)),
          const SizedBox(width: 4),
          Text(
            recurringIntervalLabel(interval),
            style: TextStyle(
              fontSize: 20,
              fontFamily: lateef,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF7C3AED),
            ),
          ),
        ],
      ),
    );
  }
}
