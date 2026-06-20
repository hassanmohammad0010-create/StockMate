// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Text_Field/Input_Decoration.dart';

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
  TextEditingController? _internalController;

  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController!;

  late final VoidCallback _listener;

  final _fieldKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      _internalController = TextEditingController(text: widget.initialValue);
    }

    _listener = () {
      if (mounted) setState(() {});
    };

    _effectiveController.addListener(_listener);
  }

  @override
  void didUpdateWidget(CustomMyTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      final oldCtrl = oldWidget.controller ?? _internalController;
      oldCtrl?.removeListener(_listener);
      if (widget.controller == null && _internalController == null) {
        _internalController = TextEditingController(text: widget.initialValue);
      }
      _effectiveController.addListener(_listener);
    }
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_listener);
    _internalController?.dispose();
    _internalController = null;

    super.dispose();
  }


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
      decoration: buildCustomTextFieldDecoration(
        label: widget.label,
        hint: widget.hint,
        enabled: widget.enabled,
        maxLines: widget.maxLines,
        hasError: hasError,
        hasText: hasText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
      ),
    );
  }
}
