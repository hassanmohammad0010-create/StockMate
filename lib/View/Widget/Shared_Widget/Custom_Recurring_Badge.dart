// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';

class RecurringBadge extends StatelessWidget {
  final RecurringInterval interval;

  const RecurringBadge({super.key, required this.interval});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE9FE),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.repeat, size: 12, color: Color(0xFF7C3AED)),
            const SizedBox(width: 4),
            Text(
              recurringIntervalLabel(interval),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7C3AED),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
