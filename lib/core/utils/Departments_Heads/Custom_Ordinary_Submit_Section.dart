// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/AddOrdinaryOrder_Controller.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';

class OrdinarySubmitSection extends GetView<AddOrdinaryOrderController> {
  const OrdinarySubmitSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.02,
        top:    MediaQuery.of(context).size.height * 0.01,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset:     const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── مؤشر عدد الطلبات ──────────────────────────────────────
          Obx(() {
            final count = controller.orders.length;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'عدد الطلبات: ',
                  style: TextStyle(
                    fontSize: 12,
                    color:    Colors.grey.shade500,
                  ),
                ),
                ...List.generate(
                  AddOrdinaryOrderController.maxOrders,
                  (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width:  8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i < count ? constBlue : Colors.grey.shade200,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '$count / ${AddOrdinaryOrderController.maxOrders}',
                  style: TextStyle(
                    fontSize:   12,
                    fontWeight: FontWeight.w600,
                    color:      constBlue,
                  ),
                ),
              ],
            );
          }),

          const SizedBox(height: 10),

          // ── زر الإرسال — يذهب لصفحة التأكيد ─────────────────────
          Obx(() {
            final count = controller.orders.length;
            return CustomMainButtom(
              title:     'إرسال الطلبات ($count)',
              color:     constBlue,
              fontcolor: Colors.white,
              onPressed: controller.validateAndGoToConfirm, // ✅
            );
          }),
        ],
      ),
    );
  }
}