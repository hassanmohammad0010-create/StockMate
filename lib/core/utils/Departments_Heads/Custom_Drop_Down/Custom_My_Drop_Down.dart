// ignore_for_file: file_names, library_private_types_in_public_api, deprecated_member_use, use_super_parameters

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Drop_Down/Drop_Down_Overlay.dart';

class CustomDropdown<T> extends FormField<T> {
  CustomDropdown({
    super.key,
    required this.items,
    required this.labelBuilder,
    required this.label,
    required this.hint,
    required this.onChanged,
    T? value,
    this.searchable = false,
    this.clearable = true,
    this.errorBorder = false,
    this.errorText,
    this.prefixIcon,
    this.icon,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.onRetry,
    FormFieldValidator<T>? validator,
    AutovalidateMode? autovalidateMode,
    FormFieldSetter<T>? onSaved,
  }) : super(
         initialValue: value,
         validator: validator,
         onSaved: onSaved,
         autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
         builder: (field) {
           final state = field as _CustomDropdownState<T>;
           return state._build(context: field.context);
         },
       );

  final List<T> items;
  final String Function(T) labelBuilder;
  final String label;
  final String hint;
  final void Function(T?) onChanged;
  final bool searchable;
  final IconData? icon;
  final bool clearable;
  final bool errorBorder;
  final String? errorText;
  final IconData? prefixIcon;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final VoidCallback? onRetry;

  @override
  FormFieldState<T> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends FormFieldState<T>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  OverlayEntry? _overlay;
  bool _isOpen = false;
  List<T> _filtered = [];

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  CustomDropdown<T> get widget => super.widget as CustomDropdown<T>;

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _scaleAnim = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(CustomDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isOpen &&
        (oldWidget.items != widget.items ||
            oldWidget.isLoading != widget.isLoading ||
            oldWidget.hasError != widget.hasError ||
            oldWidget.errorMessage != widget.errorMessage)) {
      _filtered = widget.items;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlay?.markNeedsBuild();
      });
    }
  }

  @override
  void didChange(T? value) {
    super.didChange(value);
    widget.onChanged(value);
  }

  @override
  void reset() {
    super.reset();
    widget.onChanged(value);
  }

  @override
  void dispose() {
    _forceCloseOverlay();
    _animCtrl.dispose();
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  String _normalizeArabic(String text) {
    return text
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي');
  }

  void _openOverlay(BuildContext context) {
    if (_isOpen) return;
    _filtered = widget.items;
    _searchCtrl.clear();

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlay = OverlayEntry(
      builder: (_) => DropdownOverlay<T>(
        layerLink: _layerLink,
        anchorSize: size,
        items: _filtered,
        labelBuilder: widget.labelBuilder,
        searchable: widget.searchable,
        searchCtrl: _searchCtrl,
        searchFocus: _searchFocus,
        fadeAnim: _fadeAnim,
        scaleAnim: _scaleAnim,
        isLoading: widget.isLoading,
        hasError: widget.hasError,
        errorMessage: widget.errorMessage,
        onRetry: widget.onRetry,
        onFilter: (query) {
          _filtered = widget.items
              .where(
                (e) => _normalizeArabic(
                  widget.labelBuilder(e),
                ).toLowerCase().contains(_normalizeArabic(query).toLowerCase()),
              )
              .toList();
          _overlay?.markNeedsBuild();
        },
        onSelect: (item) {
          didChange(item);
          _closeOverlay();
        },
        onDismiss: _closeOverlay,
        selectedItem: value,
      ),
    );

    Overlay.of(context).insert(_overlay!);
    _animCtrl.forward(from: 0);
    setState(() => _isOpen = true);
  }

  void _closeOverlay() {
    if (!_isOpen) return;
    _animCtrl.reverse().then((_) {
      _overlay?.remove();
      _overlay = null;
    });
    if (mounted) setState(() => _isOpen = false);
  }

  void _forceCloseOverlay() {
    _overlay?.remove();
    _overlay = null;
    _isOpen = false;
  }

  void _clearValue() {
    if (_isOpen) _forceCloseOverlay();
    didChange(null);
  }

  Widget _build({required BuildContext context}) {
    final hasValue = value != null;
    final isEmptyList = widget.items.isEmpty && !widget.isLoading;
    final isError = widget.errorBorder || hasError;
    final showClear = hasValue && widget.clearable;

    // ✅ نفس ألوان البوردر بتاعة CustomMyTextFormField (Input_Decoration.dart)
    final borderColor = isError
        ? constRed
        : (_isOpen ? constBlue : Colors.grey.shade300);

    final borderWidth = (_isOpen || isError) ? 1.5 : 1.0;

    void handleOpen() {
      if (isEmptyList) return;
      _openOverlay(context);
    }

    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              // ✅ نفس fillColor بتاع CustomMyTextFormField (enabled ? white : grey.shade50)
              color: isEmptyList ? Colors.grey.shade50 : Colors.white,
              // ✅ نفس borderRadius (12 بدل 12، كانت متطابقة أصلاً)
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: borderWidth),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: handleOpen,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      // ✅ نفس contentPadding الثابت بتاع buildCustomTextFieldDecoration
                      // (horizontal: 20, vertical: 18) بدل النسبة h * 0.018
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          if (widget.prefixIcon != null ||
                              widget.icon != null) ...[
                            // ✅ نفس SizedBox(width: 40) اللي في prefixIcon بتاع الـ text field
                            SizedBox(
                              width: 40,
                              child: Icon(
                                widget.prefixIcon ?? widget.icon,
                                size: 25,
                                color: isEmptyList
                                    ? Colors.grey.shade400
                                    : constBlue,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: hasValue
                                ? Text(
                                    widget.labelBuilder(value as T),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: constColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                : Text(
                                    isEmptyList ? 'لا يوجد' : widget.label,
                                    style: TextStyle(
                                      // ✅ نفس منطق label/hint بتاع buildCustomTextFieldDecoration
                                      color: Colors.grey.shade500,
                                      fontSize: 15,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (showClear)
                  GestureDetector(
                    onTap: _clearValue,
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                if (!isEmptyList)
                  GestureDetector(
                    onTap: handleOpen,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 12),
                      child: AnimatedRotation(
                        turns: _isOpen ? 0.5 : 0,
                        duration: const Duration(milliseconds: 180),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (isError && (widget.errorText != null || errorText != null))
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 6),
              child: Text(
                widget.errorText ?? errorText ?? '',
                style: const TextStyle(color: constRed, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
