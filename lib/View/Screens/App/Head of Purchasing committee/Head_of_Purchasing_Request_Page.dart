import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/App/PurchaseRequestsController.dart';
import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Display_Purchasing_Order_WithRecipts_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Request_Container.dart';
import 'package:stock_mate_project/core/models/Purchase_Request_Model.dart';

import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Filter_Bar.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

class HeadOfPurchasingRequestPage extends StatelessWidget {
  HeadOfPurchasingRequestPage({super.key}) {
    filterController.initFilters([
      'الكل',
      'بأنتظار موافقتك',
      'قيد التنفيذ',
      'منجز',
      'مرفوضة',
    ]);
  }

  final FilterController filterController = Get.put(
    FilterController(),
    tag: 'HeadOfPurchasingRequestPage',
  );

  final PurchaseRequestsController purchaseRequestsController = Get.put(
    PurchaseRequestsController(),
  );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Get.delete<FilterController>(tag: 'HeadOfPurchasingRequestPage');
        }
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomFilterBar(controller: filterController),
            Expanded(
              child: Obx(() {
                if (purchaseRequestsController.isLoading.value) {
                  return const Center(child: CustomLoadingIndicator());
                }

                final String selected = filterController.selectedFilter.value;
                final List<PurchaseRequestListItem> requests =
                    _filterPurchaseItems(
                      purchaseRequestsController.allRequests,
                      selected,
                    );

                return requests.isEmpty
                    ? CustomEmptyState(tital: 'لا يوجد طلبات لعرضها...')
                    : RefreshIndicator(
                        onRefresh: purchaseRequestsController.refreshRequests,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 0),
                          itemCount: requests.length,
                          itemBuilder: (context, index) {
                            final item = requests[index];
                            return CustomRequestContainer(
                              date: item.formattedCreatedAt,
                              necessity: item.priorityLabel,
                              requester: item.requestedBy?.fullName ?? '',
                              state: item.statusLabel,
                              onTap: () async {
                                await Get.to(
                                  () => DisplayPurchasingOrderWithReciptsPage(
                                    requestId: item.id,
                                  ),
                                );
                                // await Get.to(
                                //   () => DisplayPurchasingOrderPage(
                                //     requestId: item.id,
                                //   ),
                                // );
                                purchaseRequestsController.refreshRequests();
                              },
                            );
                          },
                        ),
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }

  List<PurchaseRequestListItem> _filterPurchaseItems(
    List<PurchaseRequestListItem> items,
    String selectedFilter,
  ) {
    switch (selectedFilter) {
      case 'بأنتظار موافقتك':
        return items
            .where((r) => r.statusLabel == 'بأنتظار موافقة اللجنة')
            .toList();

      case 'قيد التنفيذ':
        return items.where((r) => r.statusLabel == 'قيد التنفيذ').toList();

      case 'منجز':
        return items
            .where((r) => r.statusLabel == 'منجز' || r.statusLabel == 'مستلم')
            .toList();
      case 'مكتمل جزئي':
        return items.where((r) => r.statusLabel == 'مكتمل جزئي').toList();
      case 'مرفوضة':
        return items.where((r) => r.statusLabel == 'مرفوض').toList();

      case 'الكل':
      default:
        return items.where((r) => r.statusLabel != 'معلق').toList();
    }
  }
}
