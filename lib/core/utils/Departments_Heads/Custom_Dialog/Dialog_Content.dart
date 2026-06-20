// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/DialogType.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/Dialog_Button.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/Dialog_Style.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/Dialog_Text_Field.dart';


/// محتوى الـ Dialog الكامل: أيقونة + عنوان + رسالة + حقل نص اختياري + أزرار.
class DialogContent extends StatelessWidget {
  const DialogContent({
    super.key,
    required this.title,
    required this.message,
    required this.type,
    required this.confirmText,
    required this.cancelText,
    required this.showCancel,
    required this.showTextField,
    required this.textFieldHint,
    required this.textFieldLabel,
    required this.textFieldIcon,
    required this.textFieldKeyboard,
    required this.textFieldController,
    required this.formKey,
    this.onConfirm,
    this.textFieldValidator,
  });

  final String title;
  final String message;
  final DialogType type;
  final String confirmText;
  final String cancelText;
  final bool showCancel;
  final VoidCallback? onConfirm;

  final bool showTextField;
  final String textFieldHint;
  final String textFieldLabel;
  final IconData textFieldIcon;
  final TextInputType textFieldKeyboard;
  final TextEditingController textFieldController;
  final String? Function(String?)? textFieldValidator;

  final GlobalKey<FormState> formKey;

  /// منطق ضغط زر التأكيد، مشترك بين حالتي (مع/بدون إلغاء).
  void _handleConfirm() {
    if (showTextField && !(formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (onConfirm != null) {
      onConfirm!();
    } else {
      Get.back(result: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = DialogStyle.forType(type);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Header(
                title: title,
                message: message,
                style: style,
                showTextField: showTextField,
                textFieldHint: textFieldHint,
                textFieldLabel: textFieldLabel,
                textFieldIcon: textFieldIcon,
                textFieldKeyboard: textFieldKeyboard,
                textFieldController: textFieldController,
                textFieldValidator: textFieldValidator,
              ),
              Divider(height: 1, color: Colors.grey.shade100),
              _Actions(
                showCancel: showCancel,
                confirmText: confirmText,
                cancelText: cancelText,
                confirmColor: style.confirmColor,
                onConfirm: _handleConfirm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// الجزء العلوي: الأيقونة + العنوان + الرسالة + حقل النص الاختياري.
class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.message,
    required this.style,
    required this.showTextField,
    required this.textFieldHint,
    required this.textFieldLabel,
    required this.textFieldIcon,
    required this.textFieldKeyboard,
    required this.textFieldController,
    required this.textFieldValidator,
  });

  final String title;
  final String message;
  final DialogStyle style;
  final bool showTextField;
  final String textFieldHint;
  final String textFieldLabel;
  final IconData textFieldIcon;
  final TextInputType textFieldKeyboard;
  final TextEditingController textFieldController;
  final String? Function(String?)? textFieldValidator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: style.iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(style.icon, color: style.iconColor, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style:  TextStyle(
              fontFamily: cairo,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: cairo,
              fontSize: 13,
              color: Colors.grey.shade500,
              height: 1.5,
            ),
          ),
          if (showTextField) ...[
            const SizedBox(height: 20),
            DialogTextField(
              controller: textFieldController,
              hint: textFieldHint,
              label: textFieldLabel,
              icon: textFieldIcon,
              keyboardType: textFieldKeyboard,
              confirmColor: style.confirmColor,
              validator: textFieldValidator,
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// صف الأزرار السفلي: تأكيد فقط، أو تأكيد + إلغاء.
class _Actions extends StatelessWidget {
  const _Actions({
    required this.showCancel,
    required this.confirmText,
    required this.cancelText,
    required this.confirmColor,
    required this.onConfirm,
  });

  final bool showCancel;
  final String confirmText;
  final String cancelText;
  final Color confirmColor;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final confirmButton = DialogButton(
      label: confirmText,
      color: confirmColor,
      textColor: Colors.white,
      onTap: onConfirm,
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: showCancel
          ? Row(
              children: [
                Expanded(
                  child: DialogButton(
                    label: cancelText,
                    color: Colors.grey.shade100,
                    textColor: Colors.grey.shade700,
                    onTap: () => Get.back(result: false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: confirmButton),
              ],
            )
          : confirmButton,
    );
  }
}