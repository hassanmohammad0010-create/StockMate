import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/PurchaseRequestsController.dart';
import 'package:stock_mate_project/Controller/App/Refill_Requests_Controller.dart';
import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
import 'package:stock_mate_project/Controller/Logic/Toggle_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Display_Purchasing_Order_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Order_Details_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Request_Container.dart';
import 'package:stock_mate_project/core/models/Order_Item.dart';
import 'package:stock_mate_project/core/models/Purchase_Request_Model.dart';

import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Filter_Bar.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Toggle_Buttom.dart';

class RequestPage extends StatelessWidget {
  RequestPage({super.key}) {
    // ✅ تسجيل واحد فقط مع tag
    filterController.initFilters([
      'الكل',
      'بأنتظار موافقتك',
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

  final RefillRequestsController refillRequestsController = Get.put(
    RefillRequestsController(),
  );

  // ✅ كنترولر طلبات الشراء
  final PurchaseRequestsController purchaseRequestsController = Get.put(
    PurchaseRequestsController(),
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
                horizontal: context.screenWidth * 0.02,
                vertical: context.screenHeight * 0.01,
              ),
              child: Align(
                alignment: AlignmentGeometry.topRight,
                child: CustomToggleButtom(
                  first: 'المستودع',
                  second: 'الاقسام',
                  controller: toggleController,
                ),
              ),
            ),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: toggleController.pageController,
                children: [
                  // ─────────── طلبات الشراء ───────────
                  Column(
                    children: [
                      CustomFilterBar(controller: filterController),
                      Expanded(
                        child: Obx(() {
                          if (purchaseRequestsController.isLoading.value) {
                            return const Center(
                              child: CustomLoadingIndicator(),
                            );
                          }

                          final String selected =
                              filterController.selectedFilter.value;
                          final List<PurchaseRequestListItem> requests =
                              _filterPurchaseItems(
                                purchaseRequestsController.allRequests,
                                selected,
                              );

                          return requests.isEmpty
                              ? CustomEmptyState(
                                  tital: 'لا يوجد طلبات لعرضها...',
                                )
                              : RefreshIndicator(
                                  onRefresh: purchaseRequestsController
                                      .refreshRequests,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.only(top: 0),
                                    itemCount: requests.length,
                                    itemBuilder: (context, index) {
                                      final item = requests[index];
                                      return CustomRequestContainer(
                                        date: item.formattedCreatedAt,
                                        necessity: item.priorityLabel,
                                        requester:
                                            item.requestedBy?.fullName ?? '',
                                        state: item.statusLabel,
                                        onTap: () async {
                                          await Get.to(
                                            () => DisplayPurchasingOrderPage(
                                              requestId: item.id,
                                            ),
                                          );
                                          purchaseRequestsController
                                              .refreshRequests();
                                        },
                                      );
                                    },
                                  ),
                                );
                        }),
                      ),
                    ],
                  ),

                  // ─────────── طلبات الأقسام ───────────
                  Column(
                    children: [
                      CustomFilterBar(controller: filterController),
                      Expanded(
                        child: Obx(() {
                          if (refillRequestsController.isLoading.value) {
                            return const Center(
                              child: CustomLoadingIndicator(),
                            );
                          }

                          final String selected =
                              filterController.selectedFilter.value;
                          final List<OrdertItem> requests = _filterOrdertItems(
                            refillRequestsController.allRequests,
                            selected,
                          );

                          return requests.isEmpty
                              ? CustomEmptyState(
                                  tital: 'لا يوجد طلبات لعرضها...',
                                )
                              : RefreshIndicator(
                                  onRefresh:
                                      refillRequestsController.refreshRequests,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.only(top: 0),
                                    itemCount: requests.length,
                                    itemBuilder: (context, index) {
                                      final item = requests[index];
                                      return CustomRequestContainer(
                                        date: item.formattedCreatedAt,
                                        necessity: item.requestTypeLabel,
                                        requester: item.department?.name ?? '',
                                        state: item.statusLabel,
                                        onTap: () async {
                                          await Get.to(
                                            () =>
                                                DisOrderDetailsPage(item: item),
                                          );
                                          refillRequestsController
                                              .refreshRequests();
                                        },
                                      );
                                    },
                                  ),
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

  List<OrdertItem> _filterOrdertItems(
    List<OrdertItem> items,
    String selectedFilter,
  ) {
    switch (selectedFilter) {
      case 'بأنتظار موافقتك':
        return items.where((r) => r.statusLabel == 'بأنتظار موافقتك').toList();

      case 'قيد التنفيذ':
        return items.where((r) => r.statusLabel == 'قيد التنفيذ').toList();

      case 'منجز':
        return items
            .where((r) => r.statusLabel == 'منجز' || r.statusLabel == 'مستلم')
            .toList();

      case 'مرفوضة':
        return items.where((r) => r.statusLabel == 'مرفوض').toList();

      case 'الكل':
      default:
        // ← نستثني الطلبات "معلق" من عرض "الكل"
        return items.where((r) => r.statusLabel != 'معلق').toList();
    }
  }

  List<PurchaseRequestListItem> _filterPurchaseItems(
    List<PurchaseRequestListItem> items,
    String selectedFilter,
  ) {
    switch (selectedFilter) {
      case 'بأنتظار موافقتك':
        return items
            .where((r) => r.status == OrderStatus.pending_hospital_approval)
            .toList();

      case 'قيد التنفيذ':
        return items
            .where(
              (r) =>
                  r.status == OrderStatus.pending_manager_approval ||
                  r.status == OrderStatus.preparing,
            )
            .toList();

      case 'منجز':
        return items
            .where(
              (r) =>
                  r.status == OrderStatus.complete ||
                  r.status == OrderStatus.partially_complete,
            )
            .toList();

      case 'مرفوضة':
        return items
            .where(
              (r) =>
                  r.status == OrderStatus.hospital_rejected ||
                  r.status == OrderStatus.manager_rejected ||
                  r.status == OrderStatus.cancelled,
            )
            .toList();

      case 'الكل':
      default:
        return items.where((r) => r.status != OrderStatus.draft).toList();
    }
  }
}
