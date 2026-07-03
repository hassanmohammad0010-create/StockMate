// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class RecurringButton extends StatelessWidget {
  const RecurringButton({
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

    final h = context.screenHeight;
    final w = context.screenWidth;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: h * 0.05,
      width: w * 0.25,
      decoration: BoxDecoration(
        color: isSelected ? constBlue : Colors.transparent,
        border: Border.all(color: isSelected ? constBlue : Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: MaterialButton(
        onPressed: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontFamily: 'Cairo',
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
