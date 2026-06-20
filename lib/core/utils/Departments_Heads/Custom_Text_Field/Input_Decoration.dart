// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

InputDecoration buildCustomTextFieldDecoration({
  required String label,
  required String hint,
  required bool enabled,
  required int maxLines,
  required bool hasError,
  required bool hasText,
  IconData? prefixIcon,
  Widget? suffixIcon,
}) {
  final activeColor = hasError
      ? Colors.red.shade600
      : hasText
      ? constBlue
      : Colors.grey.shade500;

  return InputDecoration(
    alignLabelWithHint: true,
    labelText: label,
    hintText: hint,
    hintStyle: TextStyle(color: activeColor, fontSize: 13),
    prefixIcon: prefixIcon != null
        ? SizedBox(
            width: 40,
            child: Padding(
              padding: EdgeInsets.only(
                top: maxLines == 1 ? 12 : 0,
                bottom: maxLines == 1 ? 0 : 76,
                right: 8,
                left: 8,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Icon(
                  prefixIcon,
                  size: 25,
                  color: hasError ? Colors.red.shade600 : constBlue,
                ),
              ),
            ),
          )
        : null,

    suffixIcon: suffixIcon,

    filled: true,
    fillColor: enabled ? Colors.white : Colors.grey.shade50,

    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 14,
    ),

    // border عادي
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    // border عادي بدون focus
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    // border عند التركيز
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: constBlue, width: 1.5),
    ),
    // border عند الخطأ
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.red.shade600, width: 1.5),
    ),
    // border عند التركيز مع الخطأ
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.red.shade600, width: 1.5),
    ),
    // border عند التعطيل
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade200),
    ),

    labelStyle: TextStyle(
      color: activeColor,
      fontSize: hasText ? 12 : 14,
      fontWeight: hasText ? FontWeight.w500 : FontWeight.w400,
    ),

    errorStyle: TextStyle(color: Colors.red.shade700, fontSize: 11),
  );
}