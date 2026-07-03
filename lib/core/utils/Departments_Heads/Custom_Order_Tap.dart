// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class OrderTab extends StatelessWidget {
  const OrderTab({
    super.key,
    required this.index,
    required this.isActive,
    required this.isValid,
    required this.canRemove,
    required this.onTap,
    required this.onRemove,
  });

  final int index;
  final bool isActive;
  final bool isValid;
  final bool canRemove;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(left: context.screenWidth * 0.015),
        padding: EdgeInsets.symmetric(
          horizontal: context.screenWidth * 0.03,
          vertical: context.screenHeight * 0.01,
        ),
        decoration: BoxDecoration(
          color: isActive ? constBlue : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? constBlue : Colors.grey.shade300,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: constBlue.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isActive)
              Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.only(left: context.screenWidth * 0.015),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isValid ? constGreen : constOrange,
                ),
              ),
            Text(
              canRemove ? 'طلب ${index + 1}' : 'طلب جديد',
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? Colors.white : Colors.grey.shade700,
              ),
            ),
            SizedBox(width: context.screenWidth * 0.02),
            if (canRemove) ...[
              SizedBox(width: context.screenWidth * 0.01),
              GestureDetector(
                onTap: onRemove,
                child: Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: isActive
                      ? Colors.white.withOpacity(0.8)
                      : Colors.grey.shade500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
