// ignore_for_file: file_names, library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

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

  // ✅ دالة توحيد الهمزات
  String _normalizeArabic(String text) {
    return text
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي');
  }

  // ─── Overlay ───────────────────────────────────────────────────────────────

  void _openOverlay() {
    if (_isOpen) return;
    _filtered = widget.items;
    _searchCtrl.clear();

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlay = OverlayEntry(
      builder: (_) => _DropdownOverlay<T>(
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

  // ─── Build ─────────────────────────────────────────────────────────────────

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

// ══════════════════════════════════════════════════════════════════════════════
// Overlay
// ══════════════════════════════════════════════════════════════════════════════

class _DropdownOverlay<T> extends StatefulWidget {
  const _DropdownOverlay({
    required this.layerLink,
    required this.anchorSize,
    required this.items,
    required this.labelBuilder,
    required this.searchable,
    required this.searchCtrl,
    required this.searchFocus,
    required this.fadeAnim,
    required this.scaleAnim,
    required this.onFilter,
    required this.onSelect,
    required this.onDismiss,
    required this.selectedItem,
  });

  final LayerLink layerLink;
  final Size anchorSize;
  final List<T> items;
  final String Function(T) labelBuilder;
  final bool searchable;
  final TextEditingController searchCtrl;
  final FocusNode searchFocus;
  final Animation<double> fadeAnim;
  final Animation<double> scaleAnim;
  final void Function(String) onFilter;
  final void Function(T?) onSelect;
  final VoidCallback onDismiss;
  final T? selectedItem;

  @override
  State<_DropdownOverlay<T>> createState() => _DropdownOverlayState<T>();
}

class _DropdownOverlayState<T> extends State<_DropdownOverlay<T>> {
  List<T> _displayItems = [];

  @override
  void initState() {
    super.initState();
    _displayItems = widget.items;
    widget.searchCtrl.addListener(_onSearch);
  }

  @override
  void didUpdateWidget(_DropdownOverlay<T> old) {
    super.didUpdateWidget(old);
    _displayItems = widget.items;
  }

  void _onSearch() {
    widget.onFilter(widget.searchCtrl.text);
    setState(() => _displayItems = widget.items);
  }

  @override
  void dispose() {
    widget.searchCtrl.removeListener(_onSearch);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onDismiss,
            behavior: HitTestBehavior.translucent,
            child: const SizedBox.expand(),
          ),
        ),
        CompositedTransformFollower(
          link: widget.layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, widget.anchorSize.height + 6),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: FadeTransition(
              opacity: widget.fadeAnim,
              child: ScaleTransition(
                scale: widget.scaleAnim,
                alignment: Alignment.topCenter,
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: widget.anchorSize.width,
                    constraints: const BoxConstraints(maxHeight: 280),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.searchable) ...[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
                              child: TextField(
                                controller: widget.searchCtrl,
                                focusNode: widget.searchFocus,
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontSize: 13),
                                decoration: InputDecoration(
                                  hintText: 'بحث ...',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 13,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search_rounded,
                                    size: 18,
                                    color: Colors.grey.shade400,
                                  ),
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: constBlue.withOpacity(0.4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Divider(height: 1, color: Colors.grey.shade100),
                          ],
                          if (_displayItems.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 24,
                                horizontal: 16,
                              ),
                              child: Text(
                                'لا توجد نتائج',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 13,
                                ),
                              ),
                            )
                          else
                            Flexible(
                              child: ListView.separated(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: _displayItems.length,
                                separatorBuilder: (_, _) => Divider(
                                  height: 1,
                                  color: Colors.grey.shade100,
                                ),
                                itemBuilder: (_, i) {
                                  final item = _displayItems[i];
                                  final isSelected =
                                      widget.selectedItem == item;
                                  return _DropdownItem(
                                    label: widget.labelBuilder(item),
                                    isSelected: isSelected,
                                    onTap: () => widget.onSelect(item),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// عنصر واحد في القائمة
// ══════════════════════════════════════════════════════════════════════════════

class _DropdownItem extends StatefulWidget {
  const _DropdownItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_DropdownItem> createState() => _DropdownItemState();
}

class _DropdownItemState extends State<_DropdownItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          color: widget.isSelected
              ? constBlue.withOpacity(0.08)
              : _hovered
              ? Colors.grey.shade50
              : Colors.white,
          child: Row(
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: widget.isSelected ? 1.0 : 0.0,
                child: Icon(Icons.check_rounded, size: 16, color: constBlue),
              ),
              SizedBox(width: widget.isSelected ? 8 : 0),
              Expanded(
                child: Text(
                  widget.label,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: widget.isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: widget.isSelected
                        ? constBlue
                        : const Color(0xFF374151),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
