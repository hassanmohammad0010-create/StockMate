// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/AddRecurringOrder_Controller.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Add_New_Recurring_Order_Card.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Recurring_Submit_Section.dart';

class AddRecurringOrderPage extends StatelessWidget {
  const AddRecurringOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddRecurringOrderController());

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: RecurringOrderCard(controller: controller),
          ),
          const RecurringSubmitSection(),
        ],
      ),
    );
  }
}