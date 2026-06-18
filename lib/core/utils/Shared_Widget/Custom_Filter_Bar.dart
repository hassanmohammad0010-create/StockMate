// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';

class CustomFilterBar extends StatelessWidget {
  const CustomFilterBar({super.key, required this.tag, required this.filters});
  final String tag;
  final List<String> filters;
  @override
  Widget build(BuildContext context) {

   final FilterController controller = Get.find(tag: tag);
  

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Obx(
          () => Row(
            children: controller.filters.map((filter) {
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _FilterChip(
                  label: filter,
                  isSelected: controller.isSelected(filter),
                  onTap: () => controller.selectFilter(filter),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// ==================== Chip Widget ====================
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? constBlue : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? constBlue : Colors.grey.shade300,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: constBlue,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontFamily: cairo,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
