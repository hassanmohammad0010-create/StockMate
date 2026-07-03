// ignore_for_file: file_names, sized_box_for_whitespace, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/AddRecurringOrder_Controller.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Recurring_Button.dart';

class RecurringChooseCard extends StatelessWidget {
  const RecurringChooseCard({super.key});

  AddRecurringOrderController get _c => Get.find<AddRecurringOrderController>();

  @override
  Widget build(BuildContext context) {
    
    final h = context.screenHeight;
    final w = context.screenWidth;

    return Obx(() {
      final selected = _c.selectedRecurring.value;

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.025),
        child: Container(
          width: w * 0.95,
          child: Card(
            color: Colors.white.withOpacity(0.9),
            elevation: 3.0,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: w * 0.05, top: h * 0.015),
                    child: Text(
                      'التكرار',
                      style: const TextStyle(fontSize: 20, fontFamily: 'Cairo'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                  child: const Divider(),
                ),
                SizedBox(height: h * 0.01),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RecurringButton(
                      label: 'يومي',
                      isSelected: selected == 'daily',
                      onTap: () => _c.selectRecurring('daily'),
                    ),
                    RecurringButton(
                      label: 'أسبوعي',
                      isSelected: selected == 'weekly',
                      onTap: () => _c.selectRecurring('weekly'),
                    ),
                    RecurringButton(
                      label: 'شهري',
                      isSelected: selected == 'monthly',
                      onTap: () => _c.selectRecurring('monthly'),
                    ),
                  ],
                ),
                SizedBox(height: h * 0.01),
              ],
            ),
          ),
        ),
      );
    });
  }
}
