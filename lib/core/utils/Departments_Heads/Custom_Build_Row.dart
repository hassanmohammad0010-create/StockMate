// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class BuildRow extends StatelessWidget {
  BuildRow({super.key, required this.label, required this.value, this.icon});

  final String label;
  final String value;
  IconData? icon;

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: h * 0.006),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) Icon(icon, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: cairo,
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          // ignore: sized_box_for_whitespace
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: cairo,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
