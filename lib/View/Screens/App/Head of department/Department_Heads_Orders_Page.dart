// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/DepartmentOrdersFilterController%20.dart';
import 'package:stock_mate_project/Controller/Logic/Orders_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Order_Details_Page.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Order_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Order_Filter.dart';

class DepartmentOrdersPage extends StatefulWidget {
  const DepartmentOrdersPage({super.key, this.initialFilter = 'الكل'});

  final String initialFilter;

  @override
  State<DepartmentOrdersPage> createState() => _DepartmentOrdersPageState();
}

class _DepartmentOrdersPageState extends State<DepartmentOrdersPage> {
  final OrdersController ordersController = Get.find();
  final DepartmentOrdersFilterController filterController = Get.put(
    DepartmentOrdersFilterController(),
  );
  late Worker _worker;

  @override
  void initState() {
    super.initState();

    // بدلاً من widget.initialFilter استخدم ordersController.initialFilter.value
    filterController.setFilter(ordersController.initialFilter.value);

    _worker = ever(ordersController.initialFilter, (filter) {
      filterController.setFilter(filter);
    });
  }

  @override
  void dispose() {
    _worker.dispose();
    ordersController.initialFilter.value = 'الكل';
    super.dispose();
  }

  List<Order> _getFilteredOrders(String selectedFilter) {
    switch (selectedFilter) {
      case 'الكل':
        return allOrders;
      case 'الطلبات الدورية':
        return allOrders.where((o) => o.isRecurring).toList();
      case 'معلق':
        return allOrders
            .where((o) => o.status == OrderStatus.suspended)
            .toList();
      case 'قيد التنفيذ':
        return allOrders
            .where((o) => o.status == OrderStatus.inProgress)
            .toList();
      case 'منجز':
        return allOrders
            .where((o) => o.status == OrderStatus.completed)
            .toList();
      case 'مرفوض':
        return allOrders
            .where((o) => o.status == OrderStatus.rejected)
            .toList();
      default:
        return allOrders;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          const DepartmentOrdersFilterBar(),
          Expanded(
            child: Obx(() {
              final filteredOrders = _getFilteredOrders(
                filterController.selectedFilter.value,
              );

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
