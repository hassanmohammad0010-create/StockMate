// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/DepartmentOrdersFilterController%20.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Order_Details_Page.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Order_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Order_Filter.dart';

class DepartmentOrdersPage extends GetView<DepartmentOrdersFilterController> {
  const DepartmentOrdersPage({super.key, this.initialFilter = 'الكل'});

  final String initialFilter;

  @override
  Widget build(BuildContext context) {

  if (!Get.isRegistered<DepartmentOrdersFilterController>()) {
    Get.put(DepartmentOrdersFilterController());
  }

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          const DepartmentOrdersFilterBar(),
          Expanded(
            child: Obx(() {
              final filteredOrders = controller.filteredOrders;

              return filteredOrders.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = filteredOrders[index];
                        return OrderCard(
                          order: order,
                          onTap: () =>
                              Get.to(() => OrderDetailsPage(order: order)),
                        );
                      },
                    );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'لا توجد طلبات',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}