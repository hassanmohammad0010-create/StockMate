// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class CustomNameContainer extends StatelessWidget {
  const CustomNameContainer({
    super.key,
    required this.empName,
    this.specializationName,
  });
  final String empName;
  final String? specializationName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.screenWidth * 0.02,
        vertical: context.screenHeight * 0.01,
      ),
      child: Container(
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
                width: context.screenWidth * 0.09,
                height: context.screenHeight * 0.09,
                decoration: BoxDecoration(
                  color: constBlue,
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
              ),
              SizedBox(width: context.screenWidth * 0.04),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    empName,
                    style: TextStyle(
                      color: constColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: cairo,
                      fontSize: context.screenHeight * 0.021, // ← بدل 18
                    ),
                  ),
                  Visibility(
                    visible: specializationName == null ? false : true,
                    child: Text(
                      specializationName!,
                      style: TextStyle(
                        color: constGray,
                        fontFamily: lateef,
                        fontSize: context.screenHeight * 0.026, // ← بدل 22
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
