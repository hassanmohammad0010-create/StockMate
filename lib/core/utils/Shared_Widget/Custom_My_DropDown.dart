import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 
// ════════════════════════════════════════════════════════════
//  custom_widgets.dart
//  يحتوي على:
//    • DropdownItem<T>         — موديل عنصر الـ Dropdown
//    • CustomDropdownTheme     — إعدادات شكل الـ Dropdown
//    • CustomDropdown<T>       — الـ Dropdown Widget
//    • CustomTextFieldTheme    — إعدادات شكل الـ TextFormField
//    • CustomTextFormField     — الـ TextFormField Widget
// ════════════════════════════════════════════════════════════
 
 
// ─────────────────────────────────────────────────────────────
//  1. DropdownItem
// ─────────────────────────────────────────────────────────────
class DropdownItem<T> {
  final T value;
  final String label;
  final String? subtitle;
  final Widget? leading;
  final bool disabled;
  final String? group;
 
  const DropdownItem({
    required this.value,
    required this.label,
    this.subtitle,
    this.leading,
    this.disabled = false,
    this.group,
  });
}
 
 
// ─────────────────────────────────────────────────────────────
//  2. CustomDropdownTheme
// ─────────────────────────────────────────────────────────────
class CustomDropdownTheme {
  final Color? triggerBackground;
  final Color? panelBackground;
  final Color? selectedItemColor;
  final Color? hoverItemColor;
  final Color? borderColor;
  final Color? focusBorderColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? iconColor;
  final Color? groupHeaderColor;
  final Color? searchBarColor;
  final double borderRadius;
  final double panelBorderRadius;
  final double elevation;
  final EdgeInsets itemPadding;
  final TextStyle? labelStyle;
  final TextStyle? subtitleStyle;
  final TextStyle? groupHeaderStyle;
 
  const CustomDropdownTheme({
    this.triggerBackground,
    this.panelBackground,
    this.selectedItemColor,
    this.hoverItemColor,
    this.borderColor,
    this.focusBorderColor,
    this.textColor,
    this.hintColor,
    this.iconColor,
    this.groupHeaderColor,
    this.searchBarColor,
    this.borderRadius = 12,
    this.panelBorderRadius = 16,
    this.elevation = 12,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.labelStyle,
    this.subtitleStyle,
    this.groupHeaderStyle,
  });
}
 
 
// ─────────────────────────────────────────────────────────────
//  3. CustomDropdown<T>
//
//  USAGE:
//  ───────
//  // طريقة 1 – قائمة بسيطة
//  CustomDropdown<String>(
//    label: 'النوع',
//    hint: 'اختر نوعاً…',
//    items: ['Admin', 'Editor', 'Viewer'],
//    labelBuilder: (v) => v,
//    onChanged: (v) => setState(() => _selected = v),
//  )
//
//  // طريقة 2 – قائمة غنية بأيقونات وتجميع
//  CustomDropdown<String>(
//    label: 'الدولة',
//    hint: 'اختر دولة…',
//    searchable: true,
//    dropdownItems: [
//      DropdownItem(value: 'sa', label: 'السعودية', subtitle: 'الرياض',
//                   leading: Text('🇸🇦', style: TextStyle(fontSize: 18))),
//      DropdownItem(value: 'ae', label: 'الإمارات', subtitle: 'أبوظبي',
//                   leading: Text('🇦🇪', style: TextStyle(fontSize: 18))),
//    ],
//    onChanged: (v) => setState(() => _country = v),
//  )
// ─────────────────────────────────────────────────────────────
class CustomDropdown<T> extends StatefulWidget {
  final T? value;
  final List<T>? items;
  final List<DropdownItem<T>>? dropdownItems;
  final ValueChanged<T?>? onChanged;
  final String Function(T)? labelBuilder;
  final Widget? Function(T)? leadingIconBuilder;
  final String? Function(T)? subtitleBuilder;
  final String? Function(T)? groupBuilder;
  final bool Function(T)? disabledBuilder;
  final String? hint;
  final String? label;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final bool showClearButton;
  final bool searchable;
  final String searchHint;
  final int maxPanelItems;
  final double maxPanelHeight;
  final bool enabled;
  final CustomDropdownTheme theme;
 
  const CustomDropdown({
    super.key,
    this.value,
    this.items,
    this.dropdownItems,
    this.onChanged,
    this.labelBuilder,
    this.leadingIconBuilder,
    this.subtitleBuilder,
    this.groupBuilder,
    this.disabledBuilder,
    this.hint = 'Select an option',
    this.label,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.showClearButton = true,
    this.searchable = false,
    this.searchHint = 'Search…',
    this.maxPanelItems = 8,
    this.maxPanelHeight = 320,
    this.enabled = true,
    this.theme = const CustomDropdownTheme(),
  }) : assert(
          items != null || dropdownItems != null,
          'Provide either items or dropdownItems',
        );
 
  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}
 
class _CustomDropdownState<T> extends State<CustomDropdown<T>>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
 
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  T? _selectedValue;
  String _searchQuery = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
 
  List<DropdownItem<T>> get _allItems {
    if (widget.dropdownItems != null) return widget.dropdownItems!;
    return widget.items!.map((item) => DropdownItem<T>(
          value: item,
          label: widget.labelBuilder?.call(item) ?? item.toString(),
          subtitle: widget.subtitleBuilder?.call(item),
          leading: widget.leadingIconBuilder?.call(item),
          disabled: widget.disabledBuilder?.call(item) ?? false,
          group: widget.groupBuilder?.call(item),
        )).toList();
  }
 
  List<DropdownItem<T>> get _filteredItems {
    if (_searchQuery.isEmpty) return _allItems;
    final q = _searchQuery.toLowerCase();
    return _allItems.where((item) =>
        item.label.toLowerCase().contains(q) ||
        (item.subtitle?.toLowerCase().contains(q) ?? false)).toList();
  }
 
  DropdownItem<T>? get _selectedItem {
    final val = widget.value ?? _selectedValue;
    if (val == null) return null;
    try {
      return _allItems.firstWhere((item) => item.value == val);
    } catch (_) {
      return null;
    }
  }
 
  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 220));
    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut);
    _slideAnimation = Tween<Offset>(
            begin: const Offset(0, -0.04), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeOut));
    _focusNode.addListener(() => setState(() {}));
  }
 
  @override
  void dispose() {
    _closePanel();
    _focusNode.dispose();
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }
 
  void _togglePanel() {
    if (!widget.enabled) return;
    _isOpen ? _closePanel() : _openPanel();
  }
 
  void _openPanel() {
    _overlayEntry = _buildOverlay();
    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward(from: 0);
    setState(() => _isOpen = true);
    _focusNode.requestFocus();
  }
 
  void _closePanel() {
    if (_overlayEntry == null) return;
    _animationController.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
    _searchController.clear();
    _searchQuery = '';
    setState(() => _isOpen = false);
  }
 
  void _selectItem(DropdownItem<T> item) {
    if (item.disabled) return;
    setState(() => _selectedValue = item.value);
    widget.onChanged?.call(item.value);
    _closePanel();
  }
 
  void _clearSelection() {
    setState(() => _selectedValue = null);
    widget.onChanged?.call(null);
  }
 
  // ── Colours ──────────────────────────────────
  Color _c(Color? custom, Color fallback) => custom ?? fallback;
  ColorScheme get _cs => Theme.of(context).colorScheme;
 
  Color get _triggerBg   => _c(widget.theme.triggerBackground, _cs.surface);
  Color get _panelBg     => _c(widget.theme.panelBackground, _cs.surface);
  Color get _selectedClr => _c(widget.theme.selectedItemColor, _cs.primary.withOpacity(.12));
  Color get _hoverClr    => _c(widget.theme.hoverItemColor, _cs.onSurface.withOpacity(.06));
  Color get _borderClr   => _c(widget.theme.borderColor, _cs.outline.withOpacity(.5));
  Color get _focusClr    => _c(widget.theme.focusBorderColor, _cs.primary);
  Color get _textClr     => _c(widget.theme.textColor, _cs.onSurface);
  Color get _hintClr     => _c(widget.theme.hintColor, _cs.onSurface.withOpacity(.45));
  Color get _iconClr     => _c(widget.theme.iconColor, _cs.onSurface.withOpacity(.6));
 
  // ── Overlay ───────────────────────────────────
  OverlayEntry _buildOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _closePanel,
        behavior: HitTestBehavior.translucent,
        child: Stack(children: [
          Positioned.fill(child: Container(color: Colors.transparent)),
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height + 6),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildPanel(size.width)),
            ),
          ),
        ]),
      ),
    );
  }
 
  Widget _buildPanel(double width) {
    final t = widget.theme;
    final items = _filteredItems;
    final grouped = <String?, List<DropdownItem<T>>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.group, () => []).add(item);
    }
    return Material(
      elevation: t.elevation,
      borderRadius: BorderRadius.circular(t.panelBorderRadius),
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(t.panelBorderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            width: width,
            constraints: BoxConstraints(maxHeight: widget.maxPanelHeight),
            decoration: BoxDecoration(
              color: _panelBg.withOpacity(.92),
              borderRadius: BorderRadius.circular(t.panelBorderRadius),
              border: Border.all(color: _borderClr.withOpacity(.4), width: 1),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.14),
                    blurRadius: 24,
                    offset: const Offset(0, 8))
              ],
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (widget.searchable) _buildSearchBar(),
              if (items.isEmpty)
                _buildEmptyState()
              else
                Flexible(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shrinkWrap: true,
                    children: [
                      for (final group in grouped.entries) ...[
                        if (group.key != null) _buildGroupHeader(group.key!),
                        for (final item in group.value) _buildItemTile(item),
                      ],
                    ],
                  ),
                ),
            ]),
          ),
        ),
      ),
    );
  }
 
  Widget _buildSearchBar() => Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
        child: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: (v) => setState(() {
            _searchQuery = v;
            _overlayEntry?.markNeedsBuild();
          }),
          style: TextStyle(color: _textClr, fontSize: 14),
          decoration: InputDecoration(
            hintText: widget.searchHint,
            hintStyle: TextStyle(color: _hintClr, fontSize: 14),
            prefixIcon: Icon(Icons.search_rounded, size: 18, color: _iconClr),
            filled: true,
            fillColor: _c(widget.theme.searchBarColor,
                _cs.onSurface.withOpacity(.06)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
          ),
        ),
      );
 
  Widget _buildGroupHeader(String group) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 2),
        child: Text(
          group.toUpperCase(),
          style: widget.theme.groupHeaderStyle ??
              TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
                color: _c(widget.theme.groupHeaderColor,
                    _cs.primary.withOpacity(.7)),
              ),
        ),
      );
 
  Widget _buildItemTile(DropdownItem<T> item) {
    final isSelected = item.value == (widget.value ?? _selectedValue);
    return _HoverContainer(
      onTap: item.disabled ? null : () => _selectItem(item),
      selectedColor: _selectedClr,
      hoverColor: _hoverClr,
      isSelected: isSelected,
      isDisabled: item.disabled,
      child: Padding(
        padding: widget.theme.itemPadding,
        child: Row(children: [
          if (item.leading != null) ...[
            IconTheme(
              data: IconThemeData(
                color: item.disabled
                    ? _textClr.withOpacity(.35)
                    : isSelected
                        ? _cs.primary
                        : _iconClr,
                size: 20,
              ),
              child: item.leading!,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.label,
                  style: widget.theme.labelStyle?.copyWith(
                          color: item.disabled
                              ? _textClr.withOpacity(.38)
                              : _textClr) ??
                      TextStyle(
                        fontSize: 14.5,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: item.disabled
                            ? _textClr.withOpacity(.38)
                            : _textClr,
                      ),
                ),
                if (item.subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(item.subtitle!,
                        style: widget.theme.subtitleStyle ??
                            TextStyle(
                                fontSize: 12,
                                color: _textClr.withOpacity(
                                    item.disabled ? .28 : .55))),
                  ),
              ],
            ),
          ),
          if (isSelected)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child:
                  Icon(Icons.check_rounded, size: 18, color: _cs.primary),
            ),
          if (item.disabled)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(Icons.block_rounded,
                  size: 14, color: _textClr.withOpacity(.35)),
            ),
        ]),
      ),
    );
  }
 
  Widget _buildEmptyState() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(children: [
          Icon(Icons.search_off_rounded,
              size: 32, color: _textClr.withOpacity(.3)),
          const SizedBox(height: 8),
          Text('No results found',
              style:
                  TextStyle(fontSize: 13, color: _textClr.withOpacity(.5))),
        ]),
      );
 
  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final selected = _selectedItem;
    final hasError = widget.errorText != null;
    final isFocused = _focusNode.hasFocus || _isOpen;
    final borderColor = !widget.enabled
        ? _borderClr.withOpacity(.4)
        : hasError
            ? _cs.error
            : isFocused
                ? _focusClr
                : _borderClr;
 
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null) ...[
            Text(widget.label!,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: hasError
                      ? _cs.error
                      : isFocused
                          ? _focusClr
                          : _textClr.withOpacity(.75),
                )),
            const SizedBox(height: 6),
          ],
          GestureDetector(
            onTap: _togglePanel,
            child: FocusableActionDetector(
              focusNode: _focusNode,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                decoration: BoxDecoration(
                  color: widget.enabled
                      ? _triggerBg
                      : _triggerBg.withOpacity(.55),
                  borderRadius: BorderRadius.circular(t.borderRadius),
                  border: Border.all(
                      color: borderColor,
                      width: isFocused ? 1.8 : 1.2),
                  boxShadow: isFocused && !hasError
                      ? [
                          BoxShadow(
                              color: _focusClr.withOpacity(.18),
                              blurRadius: 8,
                              offset: const Offset(0, 2))
                        ]
                      : [],
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 13),
                child: Row(children: [
                  if (widget.prefixIcon != null) ...[
                    IconTheme(
                        data: IconThemeData(color: _iconClr, size: 20),
                        child: widget.prefixIcon!),
                    const SizedBox(width: 10),
                  ],
                  if (selected?.leading != null &&
                      widget.prefixIcon == null) ...[
                    IconTheme(
                        data: IconThemeData(
                            color: _cs.primary, size: 20),
                        child: selected!.leading!),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: selected == null
                        ? Text(widget.hint ?? 'Select…',
                            style: TextStyle(
                                color: _hintClr, fontSize: 14.5),
                            overflow: TextOverflow.ellipsis)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(selected.label,
                                  style: TextStyle(
                                      color: _textClr,
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis),
                              if (selected.subtitle != null)
                                Text(selected.subtitle!,
                                    style: TextStyle(
                                        color: _textClr.withOpacity(.55),
                                        fontSize: 12),
                                    overflow: TextOverflow.ellipsis),
                            ],
                          ),
                  ),
                  if (widget.showClearButton && selected != null)
                    GestureDetector(
                      onTap: widget.enabled ? _clearSelection : null,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 4, right: 4),
                        child: Icon(Icons.close_rounded,
                            size: 16, color: _iconClr),
                      ),
                    ),
                  AnimatedRotation(
                    turns: _isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        size: 22,
                        color: isFocused ? _focusClr : _iconClr),
                  ),
                ]),
              ),
            ),
          ),
          if (widget.errorText != null || widget.helperText != null) ...[
            const SizedBox(height: 6),
            Text(
              widget.errorText ?? widget.helperText!,
              style: TextStyle(
                  fontSize: 12,
                  color: widget.errorText != null
                      ? _cs.error
                      : _textClr.withOpacity(.6)),
            ),
          ],
        ],
      ),
    );
  }
}
 
 
// ─────────────────────────────────────────────────────────────
//  4. _HoverContainer  (helper داخلي للـ Dropdown)
// ─────────────────────────────────────────────────────────────
class _HoverContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color selectedColor;
  final Color hoverColor;
  final bool isSelected;
  final bool isDisabled;
 
  const _HoverContainer({
    required this.child,
    required this.onTap,
    required this.selectedColor,
    required this.hoverColor,
    required this.isSelected,
    required this.isDisabled,
  });
 
  @override
  State<_HoverContainer> createState() => _HoverContainerState();
}
 
class _HoverContainerState extends State<_HoverContainer> {
  bool _hovered = false;
 
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: widget.isDisabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          color: widget.isSelected
              ? widget.selectedColor
              : _hovered && !widget.isDisabled
                  ? widget.hoverColor
                  : Colors.transparent,
          child: widget.child,
        ),
      ),
    );
  }
}
