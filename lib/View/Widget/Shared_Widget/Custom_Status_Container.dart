// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class StatusBanner extends StatelessWidget {
  const StatusBanner({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
  });

  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Align(
        alignment: AlignmentGeometry.centerRight,
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.09,
              height: MediaQuery.of(context).size.height * 0.07,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            Icon(icon, color: color),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontFamily: cairo,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
