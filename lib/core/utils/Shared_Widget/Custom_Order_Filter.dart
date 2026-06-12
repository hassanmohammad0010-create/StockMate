// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/DepartmentOrdersFilterController%20.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Animation_Filter_Chip.dart';

class DepartmentOrdersFilterBar extends StatelessWidget {
  const DepartmentOrdersFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final DepartmentOrdersFilterController filterController = Get.find();

    return Container(
      color: constBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Obx(
        () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: filterController.filters.map((filter) {
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: MyFilterChip(
                  label: filter,
                  isSelected: filterController.selectedFilter.value == filter,
                  onTap: () => filterController.setFilter(filter),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}