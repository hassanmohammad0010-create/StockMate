// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class CustomHeadContainer extends StatelessWidget {
  const CustomHeadContainer({super.key, required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.01),
      child: Container(
        width: double.infinity,
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
                width: MediaQuery.of(context).size.width * 0.08,
                height: MediaQuery.of(context).size.height * 0.08,
                decoration: BoxDecoration(
                  color: constBlue,
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
              SizedBox(width: MediaQuery.of(context).size.width * 0.03),
              Text(
                title,
                style: TextStyle(
                  color: constColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: cairo,
                  fontSize: 18,
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.22),
              if (trailing != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.02,
                    vertical: h * 0.005,
                  ),
                  decoration: BoxDecoration(
                    color: constLightBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    trailing!,
                    style: TextStyle(
                      color: constColor,
                      fontFamily: cairo,
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
