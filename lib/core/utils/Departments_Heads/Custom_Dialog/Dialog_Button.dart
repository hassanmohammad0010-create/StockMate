// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

/// زر إجراء داخل الـ Dialog (تأكيد/إلغاء)، قابل لإعادة الاستخدام بأي لون ونص.
class DialogButton extends StatelessWidget {
  const DialogButton({
    super.key,
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style:  TextStyle(
            fontFamily: cairo,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ).copyWith(color: textColor),
        ),
      ),
    );
  }
}