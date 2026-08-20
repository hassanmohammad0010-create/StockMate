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
  return InputDecoration(
    alignLabelWithHint: true,
    labelText: label,
    hintText: hint,
    hintStyle: TextStyle(
      color: Colors.grey.shade500,
      fontSize: 15,
    ), // ✅ كانت 13
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
                child: Icon(prefixIcon, size: 25, color: constBlue),
              ),
            ),
          )
        : null,

    suffixIcon: suffixIcon,

    filled: true,
    fillColor: enabled ? Colors.white : Colors.grey.shade50,

    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: constBlue, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.red.shade600, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.red.shade600, width: 1.5),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade200),
    ),

    labelStyle: TextStyle(
      color: hasText ? constBlue : Colors.grey.shade500,
      fontSize: hasText ? 14 : 18, // ✅ كانت 12 : 14
      fontWeight: hasText ? FontWeight.w500 : FontWeight.w400,
    ),

    errorStyle: TextStyle(color: constRed, fontSize: 12), // ✅ كانت 11
  );
}
