// lib/core/Function/Loading_Dialog.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

BuildContext? _loadingDialogContext;

void showLoadingDialog() {
  Get.dialog(
    Builder(
      builder: (context) {
        // نحفظ الـ context الحقيقي لهذا الـ dialog تحديداً
        _loadingDialogContext = context;
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
        );
      },
    ),
    barrierDismissible: false,
  );
}

void hideLoadingDialog() {
  // نطلب من الـ Navigator المرتبط مباشرة بهذا الـ dialog إنه يقفل نفسه
  // بدل ما نسأل GetX "هل في dialog مفتوح؟" (سؤال ممكن يجاوب غلط)
  if (_loadingDialogContext != null &&
      Navigator.of(_loadingDialogContext!).canPop()) {
    Navigator.of(_loadingDialogContext!).pop();
  }
  _loadingDialogContext = null;
}
