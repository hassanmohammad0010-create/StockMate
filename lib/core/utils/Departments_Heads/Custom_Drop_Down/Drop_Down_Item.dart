// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class DropdownItem extends StatelessWidget {
  const DropdownItem({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? constBlue.withOpacity(0.08) : Colors.white,
      child: InkWell(
        onTap: onTap,
        hoverColor: Colors.grey.shade50,
        splashColor: constBlue.withOpacity(0.08),
        highlightColor: constBlue.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: isSelected ? 1.0 : 0.0,
                child: Icon(Icons.check_rounded, size: 16, color: constBlue),
              ),
              SizedBox(width: isSelected ? 8 : 0),
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? constBlue : constColor,
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
