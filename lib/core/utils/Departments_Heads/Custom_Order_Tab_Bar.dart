// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/AddOrdinaryOrder_Controller.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Order_Tap.dart';

class OrderTabBar extends GetView<AddOrdinaryOrderController> {
  const OrderTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() {
                final orders      = controller.orders;
                final activeIndex = controller.activeOrderIndex.value;
                final canRemove   = controller.canRemoveOrder;
                return Row(
                  children: List.generate(
                    orders.length,
                    (i) => OrderTab(
                      index:     i,
                      isActive:  i == activeIndex,
                      isValid:   orders[i].isValid,
                      canRemove: canRemove,
                      onTap:     () => controller.selectOrder(i),
                      onRemove:  () => controller.removeOrder(i),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(width: 8),

          Obx(() => Opacity(
            opacity: controller.canAddOrder ? 1.0 : 0.35,
            child: GestureDetector(
              onTap: controller.addOrder,
              child: Container(
                height: 38,
                width:  84,
                decoration: BoxDecoration(
                  color: constBlue,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color:  constBlue.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'أضف طلب',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.add, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}