// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';

class CustomNotificationCard extends StatelessWidget {
  const CustomNotificationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.statusColor,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final Color statusColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: h * 0.09,
        margin: EdgeInsets.symmetric(vertical: h * 0.005, horizontal: w * 0.01),
        padding: EdgeInsets.symmetric(horizontal: w * 0.03),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Row(
              children: [
                Text(
                  'Stock\nMate',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    height: 1.1,
                  ),
                ),
                SizedBox(width: w * 0.015),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFF2196F3),
                  child: Icon(
                    Icons.nightlight_round,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
            SizedBox(width: w * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: h * 0.004),
                  Text(
                    subtitle,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            SizedBox(width: w * 0.03),

            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: w * 0.02),

          ],
        ),
      ),
    );
  }
}
