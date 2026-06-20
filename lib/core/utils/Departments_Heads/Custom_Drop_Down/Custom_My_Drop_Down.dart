// ignore_for_file: file_names, library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Drop_Down/Drop_Down_Overlay.dart';


class CustomDropdown<T> extends StatefulWidget {
  const CustomDropdown({
    super.key,
    required this.items,
    required this.labelBuilder,
    required this.label,
    required this.hint,
    required this.onChanged,
    this.value,
    this.searchable = false,
    this.clearable = true,
    this.errorBorder = false,
    this.errorText,
    this.prefixIcon,
    this.icon,
  });

  final List<T> items;
  final String Function(T) labelBuilder;
  final String label;
  final String hint;
  final T? value;
  final void Function(T?) onChanged;
  final bool searchable;
  final IconData? icon;
  final bool clearable;
  final bool errorBorder;
  final String? errorText;
  final IconData? prefixIcon;

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>>
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


  void _openOverlay() {
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
        onFilter: (query) {
          // ✅ الفلترة مع توحيد الهمزات
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
          widget.onChanged(item);
          _closeOverlay();
        },
        onDismiss: _closeOverlay,
        selectedItem: widget.value,
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
    widget.onChanged(null);
    if (mounted) setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    final hasValue = widget.value != null;
    final isError = widget.errorBorder;
    final showClear = hasValue && widget.clearable;

    final labelColor = isError
        ? Colors.red.shade700
        : (hasValue ? constBlue : Colors.grey.shade500);

    final borderColor = isError
        ? Colors.red.shade600
        : (_isOpen ? constBlue : Colors.grey.shade300);

    final borderWidth = (_isOpen || isError) ? 1.5 : 1.0;

    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: borderWidth),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _openOverlay,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 8, 0),
                      child: Row(
                        children: [
                          Icon(
                            widget.prefixIcon ?? widget.icon,
                            size: 25,
                            color: isError ? Colors.red.shade400 : constBlue,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: hasValue
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          widget.label,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: labelColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          widget.labelBuilder(
                                            widget.value as T,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF1E293B),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      widget.label,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isError
                                            ? Colors.red.shade400
                                            : Colors.grey.shade500,
                                      ),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: _openOverlay,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsetsGeometry.only(left: 8),
                    child: AnimatedRotation(
                      turns: _isOpen ? 0.5 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: isError
                            ? Colors.red.shade400
                            : Colors.grey.shade500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isError && widget.errorText != null)
            Padding(
              padding: const EdgeInsets.only(right: 14, top: 5),
              child: Text(
                widget.errorText!,
                style: TextStyle(color: Colors.red.shade700, fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }
}