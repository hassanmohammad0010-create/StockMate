import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

// ignore: must_be_immutable
class CustomViewComponent extends StatelessWidget {
  String imagePath;
  String title;
  String text;
  CustomViewComponent({
    super.key,
    required this.imagePath,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize(context).screenWidth * 0.04,
      ),
      child: Column(
        children: [
          SizedBox(height: AppSize(context).screenHeight * 0.16),

          // حجم ثابت لكل الصور بنفس الطول والعرض
          SizedBox(
            width: AppSize(context).screenWidth * 0.9,
            height: AppSize(context).screenWidth * 0.9,
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),

          SizedBox(height: AppSize(context).screenHeight * 0.02),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              overflow: TextOverflow.fade,
              fontSize: AppSize(context).screenWidth * 0.11,
              fontFamily: cairo,
              color: constColor,
            ),
          ),
          SizedBox(height: AppSize(context).screenHeight * 0.02),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              overflow: TextOverflow.fade,
              fontFamily: lateef,
              fontSize: AppSize(context).screenWidth * 0.07,
              color: constGray,
            ),
          ),
        ],
      ),
    );
  }
}
