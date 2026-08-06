// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Test/RefillRequestsPageData.dart';

class RecurringBadge extends StatelessWidget {
  final RecurringInterval interval;

  const RecurringBadge({super.key, required this.interval});

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return Container(
      padding: EdgeInsets.symmetric(vertical: h * 0.002, horizontal: w * 0.01),
      width: w * 0.18,
      decoration: BoxDecoration(
        color: const Color(0xFFEDE9FE),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.repeat, size: 14, color: Color(0xFF7C3AED)),
          SizedBox(width: w * 0.01),
          Text(
            _intervalLabel(interval),
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

  String _intervalLabel(RecurringInterval interval) {
    switch (interval) {
      case RecurringInterval.daily:
        return 'يومي';
      case RecurringInterval.weekly:
        return 'أسبوعي';
      case RecurringInterval.monthly:
        return 'شهري';
    }
  }
}