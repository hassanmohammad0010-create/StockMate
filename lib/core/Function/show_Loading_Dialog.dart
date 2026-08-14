// lib/core/Function/Loading_Dialog.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

void showLoadingDialog() {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomLoadingIndicator(),
            const SizedBox(height: 16),
            Text(
              'جاري التنفيذ...',
              style: TextStyle(fontFamily: cairo, fontSize: 16),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false, // ما يقدرش يقفلها بالضغط برا
  );
}

void hideLoadingDialog() {
  if (Get.isDialogOpen == true) {
    Get.back();
  }
}
