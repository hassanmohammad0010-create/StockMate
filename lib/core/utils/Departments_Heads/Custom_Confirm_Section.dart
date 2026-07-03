// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

// ignore: must_be_immutable
class BuildSection extends StatelessWidget {
  BuildSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  IconData icon;
  String title;
  List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // عنوان القسم
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(icon, size: 20, color: constBlue),
                SizedBox(width: w * 0.02),

                Text(
                  title,
                  style: TextStyle(
                    fontFamily: cairo,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            Divider(
              indent: w * 0.004,
              endIndent: w * 0.004,
              height: h * 0.02,
              color: Colors.grey.shade300,
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}
