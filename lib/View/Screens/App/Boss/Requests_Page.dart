import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
import 'package:stock_mate_project/Controller/Logic/Toggle_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Order_Details_Page.dart';

import 'package:stock_mate_project/core/models/Order_Models.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Filter_Bar.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Order_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Toggle_Buttom.dart';

class RequestPage extends StatelessWidget {
  RequestPage({super.key}) {
    // ✅ تسجيل واحد فقط مع tag
    filterController.initFilters([
      'الكل',
      'معلق',
      'قيد التنفيذ',
      'منجز',
      'مرفوضة',
    ]);
  }

  // ✅ Controller واحد مع tag موحد
  final FilterController filterController = Get.put(
    FilterController(),
    tag: 'RequestPage',
  );

  final ToggleController toggleController = Get.put(
    ToggleController(),
    tag: 'RequestPage',
  );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          // ✅ حذف كلا الـ Controller عند الخروج
          Get.delete<FilterController>(tag: 'RequestPage');
          Get.delete<ToggleController>(tag: 'RequestPage');
        }
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.screenWidth * 0.02, // ← بدل 8
                vertical: context.screenHeight * 0.01, // ← بدل 8
              ),
              child: Align(
                alignment: AlignmentGeometry.topRight,
                child: CustomToggleButtom(
                  first: 'المستودع',
                  second: 'المخازن',
                  controller: toggleController,
                ),
              ),
            ),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: toggleController.pageController,
                children: [
                  // ✅ الصفحة الأولى: المستودع (فلتر + قائمة)
                  Column(
                    children: [
                      CustomFilterBar(
                        tag: 'RequestPage',
                        filters: const [
                          'الكل',
                          'معلق',
                          'قيد التنفيذ',
                          'منجز',
                          'مرفوضة',
                        ],
                      ),
                      Expanded(
                        child: Obx(() {
                          final String selected =
                              filterController.selectedFilter.value;

                          final List<Order> orders = switch (selected) {
                            'الكل' => allOrders,
                            'معلق' =>
                              allOrders
                                  .where(
                                    (o) => o.status == OrderStatus.suspended,
                                  )
                                  .toList(),
                            'قيد التنفيذ' =>
                              allOrders
                                  .where(
                                    (o) => o.status == OrderStatus.inProgress,
                                  )
                                  .toList(),
                            'منجز' =>
                              allOrders
                                  .where(
                                    (o) => o.status == OrderStatus.completed,
                                  )
                                  .toList(),
                            'مرفوضة' =>
                              allOrders
                                  .where(
                                    (o) => o.status == OrderStatus.rejected,
                                  )
                                  .toList(),
                            _ => allOrders,
                          };

                          return orders.isEmpty
                              ? _buildEmptyState()
                              : ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    8,
                                    16,
                                    100,
                                  ),
                                  itemCount: orders.length,
                                  itemBuilder: (context, index) {
                                    return OrderCard(
                                      order: orders[index],
                                      onTap: () =>
                                          _openOrderDetails(orders[index]),
                                    );
                                  },
                                );
                        }),
                      ),
                    ],
                  ),

                  // ✅ الصفحة الثانية: المخازن
                  Column(
                    children: [
                      CustomFilterBar(
                        tag: 'RequestPage',
                        filters: const [
                          'الكل',
                          'معلق',
                          'قيد التنفيذ',
                          'منجز',
                          'مرفوضة',
                        ],
                      ),
                      Expanded(
                        child: Obx(() {
                          final String selected =
                              filterController.selectedFilter.value;

                          final List<Order> orders = switch (selected) {
                            'الكل' => allOrders,
                            'معلق' =>
                              allOrders
                                  .where(
                                    (o) => o.status == OrderStatus.suspended,
                                  )
                                  .toList(),
                            'قيد التنفيذ' =>
                              allOrders
                                  .where(
                                    (o) => o.status == OrderStatus.inProgress,
                                  )
                                  .toList(),
                            'منجز' =>
                              allOrders
                                  .where(
                                    (o) => o.status == OrderStatus.completed,
                                  )
                                  .toList(),
                            'مرفوضة' =>
                              allOrders
                                  .where(
                                    (o) => o.status == OrderStatus.rejected,
                                  )
                                  .toList(),
                            _ => allOrders,
                          };

                          return orders.isEmpty
                              ? _buildEmptyState()
                              : ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    8,
                                    16,
                                    100,
                                  ),
                                  itemCount: orders.length,
                                  itemBuilder: (context, index) {
                                    return OrderCard(
                                      order: orders[index],
                                      onTap: () =>
                                          _openOrderDetails(orders[index]),
                                    );
                                  },
                                );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openOrderDetails(Order order) {
    Get.to(
      () =>
          // order.isRecurring
          // ? RecurringOrderDetailsPage(order: order)
          // :
          OrderDetailsPage(order: order),
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
