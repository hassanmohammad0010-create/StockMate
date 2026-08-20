// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/App/Get_Disposal_Sales_Controller.dart';
import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Disposal_Sale_Details_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Disposal_Request_Container.dart';
import 'package:stock_mate_project/core/models/Disposal_Sales_Page_Data_Model.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Filter_Bar.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/custom_Head_Card.dart';

class DiplayDisposalRequestPage extends StatelessWidget {
  DiplayDisposalRequestPage({super.key}) {
    filterController.initFilters([
      'الكل',
      'بانتظار الموافقة',
      'بانتظار التأكيد',
      'مكتمل',
      'مرفوضة',
    ]);
  }

  final String pageName = '/DiplayDisposalRequestPage';

  final FilterController filterController = Get.put(
    FilterController(),
    tag: 'DiplayDisposalRequestPage',
  );

  final GetDisposalSalesController controller = Get.put(
    GetDisposalSalesController(),
  );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Get.delete<FilterController>(tag: 'DiplayDisposalRequestPage');
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            CustomBackContainer(),
            CustomHeadContainer(title: 'طلبات بيع الإتلاف'),
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
                      CustomEmptyState(tital: 'تعذر تحميل الطلبات'),
                      TextButton(
                        onPressed: controller.refreshRequests,
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  );
                }

                final String selected = filterController.selectedFilter.value;
                final List<DisposalSaleListItem> requests = _filterItems(
                  controller.allRequests,
                  selected,
                );

                if (requests.isEmpty) {
                  return CustomEmptyState(tital: 'لا يوجد طلبات لعرضها');
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
                        return CustomDisposalRequestContainer(
                          date: item.formattedCreatedAt,
                          destinationName: item.destination?.name ?? '-',
                          state: item.statusLabel,
                          onTap: () async {
                            await Get.to(
                              () => DisposalSaleDetailsPage(
                                disposalSaleRequestId: item.id,
                              ),
                            );
                            controller.refreshRequests();
                          },
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

  List<DisposalSaleListItem> _filterItems(
    List<DisposalSaleListItem> items,
    String selectedFilter,
  ) {
    switch (selectedFilter) {
      case 'بانتظار الموافقة':
        return items
            .where((r) => r.status == DisposalSaleRequestStatus.pendingApproval)
            .toList();

      case 'بانتظار التأكيد':
        return items
            .where(
              (r) => r.status == DisposalSaleRequestStatus.awaitingConfirmation,
            )
            .toList();

      case 'مكتمل':
        return items
            .where((r) => r.status == DisposalSaleRequestStatus.completed)
            .toList();

      case 'مرفوضة':
        return items
            .where(
              (r) =>
                  r.status == DisposalSaleRequestStatus.rejected ||
                  r.status == DisposalSaleRequestStatus.cancelled,
            )
            .toList();

      case 'الكل':
      default:
        return items;
    }
  }
}
