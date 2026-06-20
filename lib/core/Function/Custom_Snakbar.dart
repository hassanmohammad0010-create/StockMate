import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';

void customSnackBar({
  required String title,
  required String message,
  required Color color,
  required Color messageColor,
  int? duration,
}) {
  Get.snackbar(
    title,
    message,
    duration: Duration(seconds: duration ?? 3),
    backgroundColor: color,
    titleText: Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: cairo,
        fontSize: 18,
      ),
    ),
    messageText: Text(
      message,
      style: TextStyle(fontFamily: lateef, fontSize: 20, color: messageColor),
    ),
  );
}
