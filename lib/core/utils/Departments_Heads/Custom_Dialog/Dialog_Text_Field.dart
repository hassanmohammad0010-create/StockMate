// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

/// حقل النص الاختياري الذي يظهر داخل الـ Dialog عند الحاجة لإدخال قيمة
/// من المستخدم (مثل سبب الرفض أو الكمية المستلمة).
class DialogTextField extends StatelessWidget {
  const DialogTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.label,
    required this.icon,
    required this.keyboardType,
    required this.confirmColor,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final Color confirmColor;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      validator: validator,
      style:  TextStyle(fontFamily: cairo, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        labelText: label.isEmpty ? null : label,
        hintStyle: TextStyle(
          fontFamily: cairo,
          fontSize: 13,
          color: Colors.grey.shade400,
        ),
        labelStyle: TextStyle(
          fontFamily: cairo,
          fontSize: 13,
          color: Colors.grey.shade500,
        ),
        prefixIcon: Icon(icon, size: 20, color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: _border(Colors.grey.shade200),
        enabledBorder: _border(Colors.grey.shade200),
        focusedBorder: _border(confirmColor, width: 1.5),
        errorBorder: _border(constRed),
        focusedErrorBorder: _border(constRed, width: 1.5),
      ),
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}