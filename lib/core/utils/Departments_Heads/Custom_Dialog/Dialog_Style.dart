// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/DialogType.dart';

class DialogStyle {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final Color confirmColor;

  const DialogStyle({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.confirmColor,
  });

  factory DialogStyle.forType(DialogType type) {
    switch (type) {
      case DialogType.success:
        return const DialogStyle(
          icon: Icons.check_circle_outline_rounded,
          iconColor: constGreen,
          iconBackground: constLightGreen,
          confirmColor: constGreen,
        );
      case DialogType.warning:
        return const DialogStyle(
          icon: Icons.warning_amber_rounded,
          iconColor: constOrange,
          iconBackground: constLightOrange,
          confirmColor: constOrange,
        );
      case DialogType.danger:
        return const DialogStyle(
          icon: Icons.delete_outline_rounded,
          iconColor: constRed,
          iconBackground: constLightRed,
          confirmColor: constRed,
        );
      case DialogType.info:
        return const DialogStyle(
          icon: Icons.info_outline_rounded,
          iconColor: constBlue,
          iconBackground: constLightBlue,
          confirmColor: constBlue,
        );
    }
  }
}
