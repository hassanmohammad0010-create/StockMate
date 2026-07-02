// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Dashed_Border_Painter.dart';

class ArchiveCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const ArchiveCard({
    super.key,
    required this.title,
    required this.icon,
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
            height: context.screenHeight * 0.12,
            width: context.screenWidth * 0.93,
            padding: EdgeInsets.symmetric(
              vertical: context.screenHeight * 0.025,
              horizontal: context.screenWidth * 0.04,
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
                SizedBox(width: context.screenWidth * 0.03),
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
