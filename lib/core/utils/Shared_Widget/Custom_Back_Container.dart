// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class CustomBackContainer extends StatelessWidget {
  final VoidCallback? onBack;

  const CustomBackContainer({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return Container(
      color: constColor,
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: w * 0.04, top: h * 0.04),
      width: w,
      height: h * 0.15,
      child: GestureDetector(
        onTap: onBack ?? () => Get.back(),
        child: Container(
          width: w * 0.15,
          height: h * 0.05,
          decoration: BoxDecoration(
            color: constBlue,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Icon(Icons.arrow_back_rounded, size: 32, color: Colors.white),
        ),
      ),
    );
  }
}