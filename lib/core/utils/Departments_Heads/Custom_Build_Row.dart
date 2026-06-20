import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class BuildRow extends StatelessWidget {
  const BuildRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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
            width: 90,
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
}}