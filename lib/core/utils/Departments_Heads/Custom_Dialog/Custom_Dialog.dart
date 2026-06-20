// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/DialogType.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/Dialog_Content.dart';

class CustomDialog {
  CustomDialog._();

  static Future<bool?> show({
    required String title,
    required String message,
    DialogType type = DialogType.info,

    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
    bool showCancel = true,

    VoidCallback? onConfirm,

    bool showTextField = false,
    String textFieldHint = '',
    String textFieldLabel = '',
    IconData textFieldIcon = Icons.edit_outlined,
    TextInputType textFieldKeyboard = TextInputType.text,
    TextEditingController? textFieldController,
    String? Function(String?)? textFieldValidator,

    bool dismissible = true,
  }) {
    final resolvedController = textFieldController ?? TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Get.dialog<bool>(
      barrierDismissible: dismissible,
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: DialogContent(
          title: title,
          message: message,
          type: type,
          confirmText: confirmText,
          cancelText: cancelText,
          showCancel: showCancel,
          onConfirm: onConfirm,
          showTextField: showTextField,
          textFieldHint: textFieldHint,
          textFieldLabel: textFieldLabel,
          textFieldIcon: textFieldIcon,
          textFieldKeyboard: textFieldKeyboard,
          textFieldController: resolvedController,
          textFieldValidator: textFieldValidator,
          formKey: formKey,
        ),
      ),
    );
  }
}