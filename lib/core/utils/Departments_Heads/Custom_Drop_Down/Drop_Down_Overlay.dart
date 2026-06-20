// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Drop_Down/Drop_Down_Item.dart';

class DropdownOverlay<T> extends StatefulWidget {
  const DropdownOverlay({super.key, 
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
  State<DropdownOverlay<T>> createState() => _DropdownOverlayState<T>();
}

class _DropdownOverlayState<T> extends State<DropdownOverlay<T>> {
  List<T> _displayItems = [];

  @override
  void initState() {
    super.initState();
    _displayItems = widget.items;
    widget.searchCtrl.addListener(_onSearch);
  }

  @override
  void didUpdateWidget(DropdownOverlay<T> old) {
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
                                  return DropdownItem(
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