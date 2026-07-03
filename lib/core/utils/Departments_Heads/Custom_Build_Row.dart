// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class BuildRow extends StatelessWidget {
  const BuildRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {

    final h = context.screenHeight;
    final w = context.screenWidth;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: h * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: cairo,
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),

          // ignore: sized_box_for_whitespace
          Container(
            width: w * 0.22,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: cairo,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
