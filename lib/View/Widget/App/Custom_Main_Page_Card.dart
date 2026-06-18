import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

// ignore: must_be_immutable
class CustomMainPageCard extends StatelessWidget {
  CustomMainPageCard({
    super.key,
    required this.requestNum,
    required this.description,
    required this.icons,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.onTap,
    required this.buttomtital,
  });
  Color iconColor, iconBackgroundColor;
  IconData icons;
  final int requestNum;
  final String description;
  VoidCallback onTap;
  String buttomtital;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.screenWidth * 0.01, // ← بدل 4
        vertical: context.screenHeight * 0.005, // ← بدل 4
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 1,
                offset: Offset(0, 0),
              ),
            ],
          ),
          width: context.screenWidth * 0.46,
          height: context.screenHeight * 0.21,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.screenHeight * 0.01),
              Row(
                children: [
                  SizedBox(width: context.screenWidth * 0.02),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      horizontal: context.screenWidth * 0.01,
                      vertical: context.screenWidth * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: iconBackgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icons,
                      size: context.screenHeight * 0.045,
                      color: iconColor,
                    ),
                  ),
                  SizedBox(width: context.screenWidth * 0.02),
                  Text(
                    '$requestNum',
                    style: TextStyle(
                      color: constColor,
                      fontFamily: lateef,
                      fontSize: context.screenHeight * 0.057, // ← بدل 48
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.screenWidth * 0.04, // ← بدل 8
                  vertical: context.screenHeight * 0.01, // ← بدل 8
                ),
                child: Text(
                  description,
                  style: TextStyle(
                    color: constGray,
                    fontFamily: cairo,
                    fontSize: context.screenHeight * 0.019, // ← بدل 16
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: context.screenHeight * 0.01),
              Align(
                alignment: AlignmentGeometry.center,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.screenWidth * 0.07, // ← بدل 28
                    vertical: context.screenHeight * 0.004, // ← بدل 4
                  ),
                  decoration: BoxDecoration(
                    color: iconColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    buttomtital,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: cairo,
                      fontSize: context.screenHeight * 0.020, // ← بدل 16
                    ),
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
