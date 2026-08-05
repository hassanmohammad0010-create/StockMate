// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
import 'package:stock_mate_project/Controller/Logic/Orders_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Order_Details_Page.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Filter_Bar.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Order_Card.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';

class DepartmentOrdersPage extends GetView<FilterController> {
  const DepartmentOrdersPage({super.key, this.initialFilter = 'الكل'});

  final String initialFilter;
  static const String _filterTag = AppRoutes.DepartmentOrdersPage;

  @override
  String? get tag => _filterTag;

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;
    
    final ordersController = Get.find<OrdersController>();

    if (!Get.isRegistered<FilterController>(tag: _filterTag)) {
      Get.put<FilterController>(
        FilterController()
          ..initFilters([
            'الكل',
            'منجز',
            'طلبات مستلمة',
            'معلق',
            'قيد التنفيذ',
            'الطلبات الدورية',
            'مرفوض',
          ])
          ..setFilter(initialFilter),
        tag: _filterTag,
      );
    }

    // Worker للاستماع لـ initialFilter
    ever(ordersController.initialFilter, (filter) {
      controller.setFilter(filter);
    });

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          Align(
            alignment: AlignmentGeometry.centerRight,
            child: CustomFilterBar(controller: controller),
          ),
          Expanded(
            child: Obx(() {
              final orders = ordersController.orders;
              final selected = controller.selectedFilter.value;
              final query = controller.searchQuery.value.trim().toLowerCase();

              // منطق الفلترة هنا
              List<Order> filteredOrders = switch (selected) {
                'منجز' => orders.where((o) => o.status == OrderStatus.completed).toList(),
                'طلبات مستلمة' => orders.where((o) => o.status == OrderStatus.reserved).toList(),
                'معلق' => orders.where((o) => o.status == OrderStatus.suspended).toList(),
                'قيد التنفيذ' => orders.where((o) => o.status == OrderStatus.inProgress).toList(),
                'الطلبات الدورية' => orders.where((o) => o.isRecurring).toList(),
                'مرفوض' => orders.where((o) => o.status == OrderStatus.rejected).toList(),
                _ => orders.toList(),
              };

              // منطق البحث
              if (query.isNotEmpty) {
                filteredOrders = filteredOrders.where((o) {
                  // قم بتخصيص الحقول هنا
                  return true;
                }).toList();
              }

              return filteredOrders.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        vertical: h * 0.01,
                        horizontal: w * 0.03,
                      ),
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = filteredOrders[index];
                        return OrderCard(
                          order: order,
                          onTap: () => Get.to(() => OrderDetailsPage(order: order)),
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