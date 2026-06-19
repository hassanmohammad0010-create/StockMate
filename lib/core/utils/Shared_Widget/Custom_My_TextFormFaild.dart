// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class CustomMyTextFormField extends StatefulWidget {
  const CustomMyTextFormField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.enabled = true,
    this.initialValue,
  });

  final String label;
  final String hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final bool enabled;
  final String? initialValue;

  @override
  State<CustomMyTextFormField> createState() => _CustomMyTextFormFieldState();
}

class _CustomMyTextFormFieldState extends State<CustomMyTextFormField> {
  // نستخدم controller داخلي فقط إذا لم يُمرَّر controller خارجي
  TextEditingController? _internalController;

  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController!;

  // ─── Listener ─────────────────────────────────────────────────────────────
  // نحتفظ بمرجع الـ listener حتى نتمكن من إزالته بدقة في dispose
  late final VoidCallback _listener;

  @override
  void initState() {
    super.initState();

    // أنشئ controller داخلي فقط إذا لم يُعطَ controller خارجي
    if (widget.controller == null) {
      _internalController = TextEditingController(text: widget.initialValue);
    }

    // الـ listener يُعيد البناء فقط إذا كان الـ widget لا يزال موجوداً
    _listener = () {
      if (mounted) setState(() {});
    };

    _effectiveController.addListener(_listener);
  }

  @override
  void didUpdateWidget(CustomMyTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // إذا تغيّر الـ controller الخارجي — انقل الـ listener
    if (oldWidget.controller != widget.controller) {
      // أزل الـ listener من القديم
      final oldCtrl = oldWidget.controller ?? _internalController;
      oldCtrl?.removeListener(_listener);

      // إذا أصبح لا يوجد controller خارجي وكان موجوداً سابقاً
      if (widget.controller == null && _internalController == null) {
        _internalController = TextEditingController(text: widget.initialValue);
      }

      // أضف الـ listener للجديد
      _effectiveController.addListener(_listener);
    }
  }

  @override
  void dispose() {
    // ← المشكلة الأصلية كانت هنا: لم يُزَل الـ listener قبل dispose
    _effectiveController.removeListener(_listener);

    // تخلص من الـ controller الداخلي فقط — الخارجي تتحمل مسؤوليته الصفحة
    _internalController?.dispose();
    _internalController = null;

    super.dispose();
  }

  final _fieldKey = GlobalKey<FormFieldState>();

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final hasText = _effectiveController.text.isNotEmpty;
    final hasError = _fieldKey.currentState?.hasError ?? false;

    return TextFormField(
      key: _fieldKey,
      controller: _effectiveController,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      obscureText: widget.obscureText,
      enabled: widget.enabled,
      onChanged: widget.onChanged,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: widget.label,
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: hasError
              ? Colors.red.shade600
              : hasText
              ? constBlue
              : Colors.grey.shade500,
          fontSize: 13,
        ),
        // prefixIcon: widget.prefixIcon != null
        //     ? Icon(widget.prefixIcon, size: 20, color: constBlue)
        //     : null,
        prefixIcon: widget.prefixIcon != null
            ? SizedBox(
                width: 40,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: widget.maxLines == 1 ? 12 : 0,
                    bottom: widget.maxLines == 1 ? 0 : 60,
                    right: 8,
                    left: 8,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Icon(
                      widget.prefixIcon,
                      size: 25,
                      color: hasError
                          ? Colors.red.shade600
                          : hasText
                          ? constBlue
                          : constBlue,
                    ),
                  ),
                ),
              )
            : null,

        suffixIcon: widget.suffixIcon,

        filled: true,
        fillColor: widget.enabled ? Colors.white : Colors.grey.shade50,

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
          color: hasError
              ? Colors.red.shade600
              : hasText
              ? constBlue
              : Colors.grey.shade500,
          fontSize: hasText ? 12 : 14,
          fontWeight: hasText ? FontWeight.w500 : FontWeight.w400,
        ),

        errorStyle: TextStyle(color: Colors.red.shade700, fontSize: 11),
      ),
    );
  }
}
