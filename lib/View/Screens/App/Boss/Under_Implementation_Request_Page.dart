// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/App/Urgent_Purchase_Requests_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Display_Purchasing_Order_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Request_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/custom_Head_Card.dart';

class UnderImplementationRequestPage extends StatelessWidget {
  UnderImplementationRequestPage({super.key});
  final String pageName = '/UnderImplementationRequestPage';

  final UrgentPurchaseRequestsController preparingPurchaseRequestsController =
      Get.find(tag: 'preparing_purchase_requests');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomBackContainer(),
          CustomHeadContainer(title: 'طلبات الشراء قيد التنفيذ'),
          Expanded(
            child: Obx(() {
              if (preparingPurchaseRequestsController.isLoading.value &&
                  preparingPurchaseRequestsController.allRequests.isEmpty) {
                return const Center(child: CustomLoadingIndicator());
              }

              if (preparingPurchaseRequestsController.hasError.value &&
                  preparingPurchaseRequestsController.allRequests.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomEmptyState(tital: 'تعذر تحميل الطلبات'),
                    TextButton(
                      onPressed:
                          preparingPurchaseRequestsController.refreshRequests,
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                );
              }

              if (preparingPurchaseRequestsController.allRequests.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomEmptyState(tital: 'لا يوجد طلبات قيد التنفيذ'),
                    TextButton(
                      onPressed:
                          preparingPurchaseRequestsController.refreshRequests,
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                );
              }

              return RefreshIndicator(
                onRefresh: preparingPurchaseRequestsController.refreshRequests,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                      preparingPurchaseRequestsController.loadMore();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.all(0),
                    itemCount:
                        preparingPurchaseRequestsController.allRequests.length,
                    itemBuilder: (context, index) {
                      final item = preparingPurchaseRequestsController
                          .allRequests[index];
                      return CustomRequestContainer(
                        date: item.formattedCreatedAt,
                        necessity: item.priorityLabel,
                        requester: item.requestedBy?.fullName ?? '',
                        state: item.statusLabel,
                        onTap: () async {
                          await Get.to(
                            () =>
                                DisplayPurchasingOrderPage(requestId: item.id),
                          );
                          preparingPurchaseRequestsController.refreshRequests();
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
    );
  }
}
