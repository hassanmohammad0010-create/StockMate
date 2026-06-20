// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/AddRecurringOrder_Controller.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';

class RecurringSubmitSection extends GetView<AddRecurringOrderController> {
  const RecurringSubmitSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: context.screenHeight * 0.01,
        top: context.screenHeight * 0.01,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),

          CustomMainButtom(
            title: 'إرسال الطلب',
            color: constBlue,
            fontcolor: Colors.white,
            onPressed: () =>
controller.validateAndGoToConfirm(),            
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
  