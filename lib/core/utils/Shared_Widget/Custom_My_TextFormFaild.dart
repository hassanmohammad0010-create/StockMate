import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 
// ─────────────────────────────────────────────────────────────
//  5. CustomMyTextFieldTheme
// ─────────────────────────────────────────────────────────────
class CustomMyTextFieldTheme {
  final Color? background;
  final Color? borderColor;
  final Color? focusBorderColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? iconColor;
  final Color? cursorColor;
  final double borderRadius;
  final TextStyle? inputStyle;
  final TextStyle? labelStyle;
  final TextStyle? helperStyle;
 
  const CustomMyTextFieldTheme({
    this.background,
    this.borderColor,
    this.focusBorderColor,
    this.textColor,
    this.hintColor,
    this.iconColor,
    this.cursorColor,
    this.borderRadius = 12,
    this.inputStyle,
    this.labelStyle,
    this.helperStyle,
  });
}
 
 
// ─────────────────────────────────────────────────────────────
//  6. CustomTextFormField
//
//  USAGE:
//  ───────
//  CustomTextFormField(
//    label: 'الاسم',
//    hint: 'أدخل اسمك…',
//    prefixIcon: Icon(Icons.person_outline_rounded),
//    showClearButton: true,
//    validator: (v) => v!.isEmpty ? 'مطلوب' : null,
//    onChanged: (v) => print(v),
//  )
// ─────────────────────────────────────────────────────────────
class CustomMyTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool showClearButton;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final bool autocorrect;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final CustomMyTextFieldTheme theme;
 
  const CustomMyTextFormField({
    super.key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.showClearButton = false,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.validator,
    this.onSaved,
    this.theme = const CustomMyTextFieldTheme(),
  });
 
  @override
  State<CustomMyTextFormField> createState() => _CustomMyTextFormFieldState();
}
 
class _CustomMyTextFormFieldState extends State<CustomMyTextFormField> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  bool _isFocused = false;
  bool _obscured = true;
  String? _validatorError;
 
  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _obscured = widget.obscureText;
    _focusNode.addListener(() => setState(() => _isFocused = _focusNode.hasFocus));
    _controller.addListener(() => setState(() {}));
  }
 
  @override
  void dispose() {
    if (widget.focusNode == null) _focusNode.dispose();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }
 
  Color _c(Color? custom, Color fallback) => custom ?? fallback;
  ColorScheme get _cs => Theme.of(context).colorScheme;
 
  Color get _bg         => _c(widget.theme.background, _cs.surface);
  Color get _borderClr  => _c(widget.theme.borderColor, _cs.outline.withOpacity(.5));
  Color get _focusClr   => _c(widget.theme.focusBorderColor, _cs.primary);
  Color get _textClr    => _c(widget.theme.textColor, _cs.onSurface);
  Color get _hintClr    => _c(widget.theme.hintColor, _cs.onSurface.withOpacity(.45));
  Color get _iconClr    => _c(widget.theme.iconColor, _cs.onSurface.withOpacity(.6));
 
  bool get _hasError => widget.errorText != null || _validatorError != null;
  bool get _hasText  => _controller.text.isNotEmpty;
 
  Color get _activeBorder {
    if (!widget.enabled) return _borderClr.withOpacity(.4);
    if (_hasError) return _cs.error;
    if (_isFocused) return _focusClr;
    return _borderClr;
  }
 
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: widget.theme.labelStyle?.copyWith(
                    color: _hasError
                        ? _cs.error
                        : _isFocused
                            ? _focusClr
                            : _textClr.withOpacity(.75)) ??
                TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _hasError
                      ? _cs.error
                      : _isFocused
                          ? _focusClr
                          : _textClr.withOpacity(.75),
                ),
          ),
          const SizedBox(height: 6),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            color: widget.enabled ? _bg : _bg.withOpacity(.55),
            borderRadius: BorderRadius.circular(widget.theme.borderRadius),
            border: Border.all(
                color: _activeBorder,
                width: _isFocused ? 1.8 : 1.2),
            boxShadow: _isFocused && !_hasError
                ? [
                    BoxShadow(
                        color: _focusClr.withOpacity(.18),
                        blurRadius: 8,
                        offset: const Offset(0, 2))
                  ]
                : [],
          ),
          child: Row(
            crossAxisAlignment: widget.maxLines != null && widget.maxLines! > 1
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              if (widget.prefixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: IconTheme(
                    data: IconThemeData(
                        color: _isFocused ? _focusClr : _iconClr, size: 20),
                    child: widget.prefixIcon!,
                  ),
                ),
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  readOnly: widget.readOnly,
                  obscureText: widget.obscureText ? _obscured : false,
                  autocorrect: widget.autocorrect,
                  autofocus: widget.autofocus,
                  maxLines: widget.obscureText ? 1 : widget.maxLines,
                  minLines: widget.minLines,
                  maxLength: widget.maxLength,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  textCapitalization: widget.textCapitalization,
                  inputFormatters: widget.inputFormatters,
                  onChanged: widget.onChanged,
                  onTap: widget.onTap,
                  onFieldSubmitted: widget.onSubmitted,
                  validator: widget.validator != null
                      ? (v) {
                          final err = widget.validator!(v);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) setState(() => _validatorError = err);
                          });
                          return null;
                        }
                      : null,
                  onSaved: widget.onSaved,
                  cursorColor: _c(widget.theme.cursorColor, _focusClr),
                  cursorWidth: 1.8,
                  style: widget.theme.inputStyle ??
                      TextStyle(
                        fontSize: 14.5,
                        color: widget.enabled
                            ? _textClr
                            : _textClr.withOpacity(.45),
                      ),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle:
                        TextStyle(color: _hintClr, fontSize: 14.5),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    filled: false,
                    isDense: true,
                    counterText: '',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: widget.prefixIcon != null ? 10 : 14,
                      vertical: 13,
                    ),
                  ),
                ),
              ),
              if (widget.showClearButton && _hasText && widget.enabled)
                GestureDetector(
                  onTap: () {
                    _controller.clear();
                    widget.onChanged?.call('');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child:
                        Icon(Icons.close_rounded, size: 16, color: _iconClr),
                  ),
                ),
              if (widget.obscureText)
                GestureDetector(
                  onTap: () => setState(() => _obscured = !_obscured),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12, left: 4),
                    child: Icon(
                      _obscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: _isFocused ? _focusClr : _iconClr,
                    ),
                  ),
                )
              else if (widget.suffixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12, left: 4),
                  child: IconTheme(
                    data: IconThemeData(
                        color: _isFocused ? _focusClr : _iconClr, size: 20),
                    child: widget.suffixIcon!,
                  ),
                ),
            ],
          ),
        ),
        if (widget.errorText != null ||
            _validatorError != null ||
            widget.helperText != null) ...[
          const SizedBox(height: 6),
          Text(
            widget.errorText ?? _validatorError ?? widget.helperText!,
            style: widget.theme.helperStyle?.copyWith(
                    color: _hasError
                        ? _cs.error
                        : _textClr.withOpacity(.6)) ??
                TextStyle(
                    fontSize: 12,
                    color: _hasError
                        ? _cs.error
                        : _textClr.withOpacity(.6)),
          ),
        ],
      ],
    );
  }
}