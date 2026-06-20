// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class DropdownItem extends StatefulWidget {
  const DropdownItem({super.key, 
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<DropdownItem> createState() => _DropdownItemState();
}

class _DropdownItemState extends State<DropdownItem> {
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