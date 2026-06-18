import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';

void customSnackBar({
  required String title,
  required String message,
  int? duration,
}) {
  Get.snackbar(
    title,
    message,
    duration: Duration(seconds: duration ?? 3),
    backgroundColor: title.tr == 'Warning'.tr ? Colors.red : constColor,
    titleText: Text(
      title.tr,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),
    messageText: Text(
      message.tr,
      style: TextStyle(fontFamily: cairo, fontSize: 20, color: Colors.white),
    ),
  );
}
