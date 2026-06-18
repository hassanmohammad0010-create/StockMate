// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';

enum DialogType { info, success, warning, danger }

class CustomDialog {
  CustomDialog._();

  // ─── الدالة الرئيسية ──────────────────────────────────────────────────────
  static Future<bool?> show({
    // ── المحتوى ──────────────────────────────────────────
    required String title,
    required String message,
    DialogType type = DialogType.info,

    // ── أزرار ────────────────────────────────────────────
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
    bool showCancel = true,

    // ── تخصيص عمل زر التأكيد (اختياري) ─────────────────────
    // لو مرّرتها، تُنفَّذ بدل الإغلاق الافتراضي، وتصبح أنت
    // المسؤول عن إغلاق الـ Dialog (عبر Get.back) متى احتجت.
    VoidCallback? onConfirm,

    // ── حقل النص الاختياري ───────────────────────────────
    bool showTextField = false,
    String textFieldHint = '',
    String textFieldLabel = '',
    IconData textFieldIcon = Icons.edit_outlined,
    TextInputType textFieldKeyboard = TextInputType.text,
    TextEditingController? textFieldController,
    String? Function(String?)? textFieldValidator,

    // ── سلوك الـ Dialog ───────────────────────────────────
    bool dismissible = true,
  }) {
    final _internalController = textFieldController ?? TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return Get.dialog<bool>(
      barrierDismissible: dismissible,
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: _DialogContent(
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
          textFieldController: _internalController,
          textFieldValidator: textFieldValidator,
          formKey: _formKey,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// محتوى الـ Dialog
// ══════════════════════════════════════════════════════════════════════════════
class _DialogContent extends StatelessWidget {
  const _DialogContent({
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

  // ─── إعدادات كل نوع ───────────────────────────────────────────────────────
  _DialogStyle get _style {
    switch (type) {
      case DialogType.success:
        return _DialogStyle(
          icon: Icons.check_circle_outline_rounded,
          iconColor: constGreen,
          iconBackground: constlightGreen,
          confirmColor: constGreen,
        );
      case DialogType.warning:
        return _DialogStyle(
          icon: Icons.warning_amber_rounded,
          iconColor: constOrange,
          iconBackground: constLightOrange,
          confirmColor: constOrange,
        );
      case DialogType.danger:
        return _DialogStyle(
          icon: Icons.delete_outline_rounded,
          iconColor: constRed,
          iconBackground: constLightRed,
          confirmColor: constRed,
        );
      case DialogType.info:
        return _DialogStyle(
          icon: Icons.info_outline_rounded,
          iconColor: constBlue,
          iconBackground: constLightBlue,
          confirmColor: constBlue,
        );
    }
  }

  // ─── منطق ضغط زر التأكيد (مشترك بين الحالتين: مع/بدون إلغاء) ───────────────
  void _handleConfirm() {
    if (showTextField) {
      if (!(formKey.currentState?.validate() ?? false)) {
        return;
      }
    }

    if (onConfirm != null) {
      onConfirm!();
    } else {
      Get.back(result: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;

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
              // ── الجزء العلوي (أيقونة + عنوان + رسالة) ─────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                child: Column(
                  children: [
                    // أيقونة
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

                    // عنوان
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: cairo,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // رسالة
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

                    // ── حقل النص الاختياري ─────────────────────────────
                    if (showTextField) ...[
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: textFieldController,
                        keyboardType: textFieldKeyboard,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        validator: textFieldValidator,
                        style: TextStyle(fontFamily: cairo, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: textFieldHint,
                          labelText: textFieldLabel.isEmpty
                              ? null
                              : textFieldLabel,
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
                          prefixIcon: Icon(
                            textFieldIcon,
                            size: 20,
                            color: Colors.grey.shade400,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: style.confirmColor,
                              width: 1.5,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: constRed),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: constRed,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // ── فاصل ─────────────────────────────────────────────────
              Divider(height: 1, color: Colors.grey.shade100),

              // ── الأزرار ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(16),
                child: showCancel
                    ? Row(
                        children: [
                          // زر الإلغاء
                          Expanded(
                            child: _DialogButton(
                              label: cancelText,
                              color: Colors.grey.shade100,
                              textColor: Colors.grey.shade700,
                              onTap: () => Get.back(result: false),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // زر التأكيد
                          Expanded(
                            child: _DialogButton(
                              label: confirmText,
                              color: style.confirmColor,
                              textColor: Colors.white,
                              onTap: _handleConfirm,
                            ),
                          ),
                        ],
                      )
                    // زر التأكيد فقط بدون إلغاء
                    : _DialogButton(
                        label: confirmText,
                        color: style.confirmColor,
                        textColor: Colors.white,
                        onTap: _handleConfirm,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// زر الـ Dialog
// ══════════════════════════════════════════════════════════════════════════════
class _DialogButton extends StatelessWidget {
  const _DialogButton({
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
          style: TextStyle(
            fontFamily: cairo,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// نموذج الإعدادات الداخلية
// ══════════════════════════════════════════════════════════════════════════════
class _DialogStyle {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final Color confirmColor;

  const _DialogStyle({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.confirmColor,
  });
}
