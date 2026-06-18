// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Add_New_Ordinary_Order_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Order_Tab_Bar.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Ordinary_Submit_Section.dart';
import '../../../../Controller/Logic/AddOrdinaryOrder_Controller.dart';

class AddOrdinaryOrderPage extends GetView<AddOrdinaryOrderController> {
  const AddOrdinaryOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AddOrdinaryOrderController>()) {
      Get.put(AddOrdinaryOrderController());
    }
    return Scaffold(
      backgroundColor: constBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          const OrderTabBar(),
          Expanded(
            child: Obx(() {
              final index = controller.activeOrderIndex.value;
              return OrdinaryOrderCard(
                key: ValueKey(index),
                orderIndex: index,
              );
            }),
          ),
          const OrdinarySubmitSection(),
        ],
      ),
    );
  }
}
