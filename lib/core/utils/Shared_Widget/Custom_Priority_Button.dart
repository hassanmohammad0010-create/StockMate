// ignore_for_file: file_names

import 'package:flutter/material.dart';

class PriorityButton extends StatelessWidget {
  const PriorityButton({super.key, 
    required this.label,
    required this.color,
    required this.isSelected,
    required this.size,
    required this.onTap,
  });

  final String     label;
  final Color      color;
  final bool       isSelected;
  final Size       size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: size.height * 0.05,
      width:  size.width  * 0.4,
      decoration: BoxDecoration(
        color:        isSelected && label == 'ضروري' ? color : isSelected && label == 'عادي' ? color : Colors.transparent,
        border:       Border.all(color: color, width: isSelected ? 2 : 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: MaterialButton(
        onPressed: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Text(
          label,
          style: TextStyle(
            color:      isSelected && label == 'ضروري' ? Colors.white : isSelected && label == 'عادي' ? Colors.white : color,
            fontFamily: 'Cairo',
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}