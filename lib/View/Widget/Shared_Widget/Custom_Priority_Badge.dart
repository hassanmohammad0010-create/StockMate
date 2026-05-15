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
      width: MediaQuery.of(context).size.width * 0.15,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isUrgent ? const Color(0xFFE53935) : constBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          isUrgent ? 'ضروري' : 'عادي',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
