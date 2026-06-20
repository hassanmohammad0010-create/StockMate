// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Dashed_Border_Painter.dart';

class ArchiveCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final double height;
  final double width;
  final VoidCallback? onTap;

  const ArchiveCard({
    super.key,
    required this.title,
    required this.icon,
    required this.height,
    required this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: CustomPaint(
          painter: DashedBorderPainter(
            color: constBlue,
            strokeWidth: 1.6,
            gap: 12,
            radius: 18,
          ),
          child: Container(
            height: height * 0.12,
            width: width * 0.93,
            padding: EdgeInsets.symmetric(
              vertical: height * 0.025,
              horizontal: width * 0.04,
            ),
            decoration: BoxDecoration(
              color: constBlue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: constBlue.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: constBlue, size: 40),
                ),
                SizedBox(width: width * 0.03),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: constColor,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: constBlue,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
