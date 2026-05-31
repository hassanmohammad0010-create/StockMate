// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/AddRecurringOrder_Controller.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Add_New_Recurring_Order_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Recurring_Submit_Section.dart';
import '../../../../Controller/Logic/AddOrdinaryOrder_Controller.dart';

class AddRecurringOrderPage extends GetView<AddOrdinaryOrderController> {
  const AddRecurringOrderPage({super.key});

  final String pageName = '/AddRecurringOrderPage';


  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AddRecurringOrderController>()) {
      Get.put(AddRecurringOrderController());
    }
    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final index = controller.activeOrderIndex.value;
              return RecurringOrderCard(
                key: ValueKey(index),
              );
            }),
          ),
          const RecurringSubmitSection(),
        ],
      ),
    );
  }
}
