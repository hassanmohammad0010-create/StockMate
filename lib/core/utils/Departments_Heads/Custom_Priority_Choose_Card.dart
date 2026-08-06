// ignore_for_file: file_names, sized_box_for_whitespace, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/AddOrdinaryOrder_Controller.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Priority_Button.dart';

class PriorityChooseCard extends StatelessWidget {
  const PriorityChooseCard({super.key});

  AddOrdinaryOrderController get _c => Get.find<AddOrdinaryOrderController>();

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return Obx(() {
      final selected = _c.requestPriority.value;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.025),
        child: Container(
          width: w * 0.95,
          child: Container(
            color: Colors.transparent,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: w * 0.05, top: h * 0.015),
                    child: Text(
                      'أولوية الطلب',
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w600,
                      ),
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
                    PriorityButton(
                      label: 'ضروري',
                      color: constRed,
                      isSelected: selected == 'ضروري',
                      size: Size(w * 0.4, h * 0.05),
                      onTap: () => _c.updateRequestPriority('ضروري'),
                    ),
                    PriorityButton(
                      label: 'عادي',
                      color: constBlue,
                      isSelected: selected == 'عادي',
                      size: Size(w * 0.4, h * 0.05),
                      onTap: () => _c.updateRequestPriority('عادي'),
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
