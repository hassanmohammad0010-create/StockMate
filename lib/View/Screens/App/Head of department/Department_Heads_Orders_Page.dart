// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Order_Details_Page.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Recurring_Order_Details_Page.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Animation_Filter_Chip.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Order_Card.dart';

class DepartmentOrdersPage extends StatefulWidget {
  const DepartmentOrdersPage({super.key});
  
  final String pageName = '/DepartmentHeadsOrdersPage';

  @override
  State<DepartmentOrdersPage> createState() => _DepartmentOrdersPageState();
}

class _DepartmentOrdersPageState extends State<DepartmentOrdersPage> {
  String _selectedFilter = 'الكل';

  final List<String> _filters = [
    'الكل',
    'الطلبات الدورية',
    'معلق',
    'قيد التنفيذ',
    'منجز',
    'مرفوضة',
  ];

  List<Order> get _filteredOrders {
    switch (_selectedFilter) {
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
      case 'مرفوضة':
        return allOrders
            .where((o) => o.status == OrderStatus.rejected)
            .toList();
      default:
        return allOrders;
    }
  }

  void _openOrderDetails(Order order) {
    Get.to(
      () => order.isRecurring
          ? RecurringOrderDetailsPage(order: order)
          : OrderDetailsPage(order: order),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: _filteredOrders.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: _filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = _filteredOrders[index];
                      return OrderCard(
                        order: order,
                        onTap: () => _openOrderDetails(order),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: constBlue,
        foregroundColor: Colors.white,
        splashColor: constColor,
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  // ==================== شريط الفلاتر ====================
  Widget _buildFilterBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: _filters.map((filter) {
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: MyFilterChip(
                label: filter,
                isSelected: _selectedFilter == filter,
                onTap: () => setState(() => _selectedFilter = filter),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ==================== حالة القائمة الفارغة ====================
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
