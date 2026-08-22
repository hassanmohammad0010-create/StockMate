// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/App/Get_Inventory_Adjustments_Controller.dart';
import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Adjustment_Container.dart';
import 'package:stock_mate_project/core/models/Adjustment_Type_Model.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Filter_Bar.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/custom_Head_Card.dart';

class DisplayInventoryAdjustmentsPage extends StatelessWidget {
  DisplayInventoryAdjustmentsPage({super.key}) {
    filterController.initFilters([
      'الكل',
      'تالف',
      'منتهي الصلاحية',
      'نقص/فقدان',
      'موجود (إضافة)',
    ]);
  }

  final String pageName = '/DisplayInventoryAdjustmentsPage';

  final FilterController filterController = Get.put(
    FilterController(),
    tag: 'DisplayInventoryAdjustmentsPage',
  );

  final GetInventoryAdjustmentsController controller = Get.find(
    // GetInventoryAdjustmentsController(),
  );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Get.delete<FilterController>(tag: 'DisplayInventoryAdjustmentsPage');
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            CustomBackContainer(),
            CustomHeadContainer(title: 'تسويات المخزون'),
            CustomFilterBar(controller: filterController),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.allRequests.isEmpty) {
                  return const Center(child: CustomLoadingIndicator());
                }

                if (controller.hasError.value &&
                    controller.allRequests.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomEmptyState(tital: 'تعذر تحميل التسويات'),
                      TextButton(
                        onPressed: controller.refreshRequests,
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  );
                }

                final String selected = filterController.selectedFilter.value;
                final List<AdjustmentRow> requests = _filterItems(
                  controller.allRequests,
                  selected,
                );

                if (requests.isEmpty) {
                  return CustomEmptyState(tital: 'لا يوجد تسويات لعرضها');
                }

                return RefreshIndicator(
                  onRefresh: controller.refreshRequests,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                        controller.loadMore();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final item = requests[index];
                        return CustomAdjustmentContainer(
                          variantName: item.variant?.variantName ?? '-',
                          departmentName: item.department?.name ?? '-',
                          quantity: item.quantity,
                          typeLabel: item.arabicTypeLabel,
                          date: _formatDate(item.createdAt),
                          reportedByName: item.reportedBy?.fullName ?? '-',
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  List<AdjustmentRow> _filterItems(
    List<AdjustmentRow> items,
    String selectedFilter,
  ) {
    switch (selectedFilter) {
      case 'تالف':
        return items
            .where((r) => r.adjustmentType == AdjustmentType.damaged)
            .toList();

      case 'منتهي الصلاحية':
        return items
            .where((r) => r.adjustmentType == AdjustmentType.expired)
            .toList();

      case 'نقص/فقدان':
        return items
            .where((r) => r.adjustmentType == AdjustmentType.shrinkage)
            .toList();

      case 'موجود (إضافة)':
        return items
            .where((r) => r.adjustmentType == AdjustmentType.found)
            .toList();

      case 'الكل':
      default:
        return items;
    }
  }

  String _formatDate(DateTime d) {
    final local = d.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year} • ${two(local.hour)}:${two(local.minute)}';
  }
}
