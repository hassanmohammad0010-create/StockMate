// ignore_for_file: file_names, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/AddOrdinaryOrder_Controller.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Priority_Button.dart';

class PriorityChooseCard extends StatelessWidget {
  const PriorityChooseCard({super.key, required this.orderIndex});

  final int orderIndex;
  AddOrdinaryOrderController get _c => Get.find<AddOrdinaryOrderController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Obx(() {
      if (orderIndex >= _c.orders.length) {
        return const SizedBox.shrink();
      }
      final selected = _c.orders[orderIndex].priority;
      return Padding(
        padding:  EdgeInsets.symmetric(horizontal: size.width * 0.025),
        child: Container(
          width: MediaQuery.of(context).size.height * 0.9,
          child: Card(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24, top: 12),
                    child: Text(
                      'الأولوية',
                      style: const TextStyle(fontSize: 20, fontFamily: 'Cairo'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.03,
                  ),
                  child: const Divider(),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    PriorityButton(
                      label: 'ضروري',
                      color: constRed,
                      isSelected: selected == 'ضروري',
                      size: size,
                      onTap: () => _c.updatePriority(orderIndex, 'ضروري'),
                    ),
                    PriorityButton(
                      label: 'عادي',
                      color: constBlue,
                      isSelected: selected == 'عادي',
                      size: size,
                      onTap: () => _c.updatePriority(orderIndex, 'عادي'),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              ],
            ),
          ),
        ),
      );
    });
  }
}
