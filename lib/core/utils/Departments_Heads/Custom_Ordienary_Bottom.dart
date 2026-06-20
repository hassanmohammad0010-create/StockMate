// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/AddOrdinaryOrder_Controller.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';

class CustomOrdinaryBottom extends StatelessWidget {
  const CustomOrdinaryBottom({super.key});

  
  AddOrdinaryOrderController get controller => Get.find<AddOrdinaryOrderController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, size.height * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // زر تأكيد الإرسال
          Obx(() {
            final loading = controller.isLoading.value;
            return CustomMainButtom(
              title: loading ? 'جاري الإرسال ...' : 'تأكيد الإرسال',
              color: constBlue,
              fontcolor: Colors.white,
              onPressed: loading ? () {} : controller.submitOrders,
            );
          }),
          const SizedBox(height: 10),

          // زر العودة والتعديل
          CustomMainButtom(
            title: 'العودة والتعديل',
            color: Colors.grey.shade100,
            fontcolor: Colors.grey.shade700,
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}