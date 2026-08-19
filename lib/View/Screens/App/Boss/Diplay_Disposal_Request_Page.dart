// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/App/Get_Disposal_Sales_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Disposal_Sale_Details_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Disposal_Request_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/custom_Head_Card.dart';

class DiplayDisposalRequestPage extends StatelessWidget {
  DiplayDisposalRequestPage({super.key});
  final String pageName = '/DiplayDisposalRequestPage';

  final GetDisposalSalesController controller = Get.put(
    GetDisposalSalesController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomBackContainer(),
          CustomHeadContainer(title: 'طلبات بيع الإتلاف'),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.allRequests.isEmpty) {
                return const Center(child: CustomLoadingIndicator());
              }

              if (controller.hasError.value && controller.allRequests.isEmpty) {
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

              if (controller.allRequests.isEmpty) {
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
                    padding: EdgeInsets.all(0),
                    itemCount: controller.allRequests.length,
                    itemBuilder: (context, index) {
                      final item = controller.allRequests[index];
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
    );
  }
}
