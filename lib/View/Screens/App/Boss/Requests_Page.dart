import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/PurchaseRequestsController.dart';
import 'package:stock_mate_project/Controller/App/Refill_Requests_Controller.dart';
import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
import 'package:stock_mate_project/Controller/Logic/Toggle_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Display_Purchasing_Order_WithRecipts_Page.dart';
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
    tag: 'RequestPage',
  );

  final ToggleController toggleController = Get.put(
    ToggleController(),
    tag: 'RequestPage',
  );

  final RefillRequestsController refillRequestsController = Get.put(
    RefillRequestsController(),
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
                  // ─────────── 1. طلبات الشراء (المستودع) ───────────
                  Column(
                    children: [
                      CustomFilterBar(controller: filterController),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: purchaseRequestsController.refreshRequests,
                          child: Obx(() {
                            // 1️⃣ حالة التحميل
                            if (purchaseRequestsController.isLoading.value) {
                              return CustomScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                slivers: const [
                                  SliverFillRemaining(
                                    hasScrollBody: false,
                                    child: Center(
                                      child: CustomLoadingIndicator(),
                                    ),
                                  ),
                                ],
                              );
                            }

                            final String selected =
                                filterController.selectedFilter.value;
                            final List<PurchaseRequestListItem> requests =
                                _filterPurchaseItems(
                                  purchaseRequestsController.allRequests,
                                  selected,
                                );

                            // 2️⃣ حالة الفراغ
                            if (requests.isEmpty) {
                              return CustomScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                slivers: const [
                                  SliverFillRemaining(
                                    hasScrollBody: false,
                                    child: CustomEmptyState(
                                      tital: 'لا يوجد طلبات لعرضها...',
                                    ),
                                  ),
                                ],
                              );
                            }

                            // 3️⃣ حالة وجود البيانات
                            return CustomScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              slivers: [
                                SliverPadding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: context.screenHeight * 0.01,
                                  ),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate((
                                      context,
                                      index,
                                    ) {
                                      final item = requests[index];
                                      return CustomRequestContainer(
                                        date: item.formattedCreatedAt,
                                        necessity: item.priorityLabel,
                                        requester:
                                            item.requestedBy?.fullName ?? '',
                                        state: item.statusLabel,
                                        onTap: () async {
                                          await Get.to(
                                            () =>
                                                DisplayPurchasingOrderWithReciptsPage(
                                                  requestId: item.id,
                                                ),
                                          );
                                          purchaseRequestsController
                                              .refreshRequests();
                                        },
                                      );
                                    }, childCount: requests.length),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),

                  // ─────────── 2. طلبات الأقسام ───────────
                  Column(
                    children: [
                      CustomFilterBar(controller: filterController),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: refillRequestsController.refreshRequests,
                          child: Obx(() {
                            // 1️⃣ حالة التحميل
                            if (refillRequestsController.isLoading.value) {
                              return CustomScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                slivers: const [
                                  SliverFillRemaining(
                                    hasScrollBody: false,
                                    child: Center(
                                      child: CustomLoadingIndicator(),
                                    ),
                                  ),
                                ],
                              );
                            }

                            final String selected =
                                filterController.selectedFilter.value;
                            final List<OrdertItem> requests =
                                _filterOrdertItems(
                                  refillRequestsController.allRequests,
                                  selected,
                                );

                            // 2️⃣ حالة الفراغ
                            if (requests.isEmpty) {
                              return CustomScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                slivers: const [
                                  SliverFillRemaining(
                                    hasScrollBody: false,
                                    child: CustomEmptyState(
                                      tital: 'لا يوجد طلبات لعرضها...',
                                    ),
                                  ),
                                ],
                              );
                            }

                            // 3️⃣ حالة وجود البيانات
                            return CustomScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              slivers: [
                                SliverPadding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: context.screenHeight * 0.01,
                                  ),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate((
                                      context,
                                      index,
                                    ) {
                                      final item = requests[index];
                                      return CustomRequestContainer(
                                        date: item.formattedCreatedAt,
                                        necessity: item.requestTypeLabel,
                                        requester: item.department?.name ?? '',
                                        state: item.statusLabel,
                                        onTap: () async {
                                          await Get.to(
                                            () => DisOrderDetailsPage(
                                              requestId: item.id,
                                            ),
                                          );
                                          refillRequestsController
                                              .refreshRequests();
                                        },
                                      );
                                    }, childCount: requests.length),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
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
        return items
            .where((r) => r.statusLabel == 'بأنتظار مدير المستشفى')
            .toList();
      case 'قيد التنفيذ':
        return items.where((r) => r.statusLabel == 'قيد التنفيذ').toList();
      case 'منجز':
        return items
            .where((r) => r.statusLabel == 'منجز' || r.statusLabel == 'مستلم')
            .toList();
      case 'مرفوضة':
        return items
            .where(
              (r) =>
                  r.statusLabel == 'مرفوض مدير المستشفى' ||
                  r.statusLabel == 'مرفوض مدير المستودع' ||
                  r.statusLabel == 'مرفوض',
            )
            .toList();
      case 'الكل':
      default:
        final filtered = items.where((r) => r.statusLabel != 'معلق').toList();
        // ✅ الطلبات "بأنتظار مدير المستشفى" أولاً، وبعدها الباقي بنفس ترتيبها الأصلي
        final pending = filtered
            .where((r) => r.statusLabel == 'بأنتظار مدير المستشفى')
            .toList();
        final rest = filtered
            .where((r) => r.statusLabel != 'بأنتظار مدير المستشفى')
            .toList();
        return [...pending, ...rest];
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
        final filtered = items
            .where((r) => r.status != OrderStatus.draft)
            .toList();
        // ✅ الطلبات "بأنتظار موافقة مدير المستشفى" أولاً، وبعدها الباقي
        final pending = filtered
            .where((r) => r.status == OrderStatus.pending_hospital_approval)
            .toList();
        final rest = filtered
            .where((r) => r.status != OrderStatus.pending_hospital_approval)
            .toList();
        return [...pending, ...rest];
    }
  }
}
