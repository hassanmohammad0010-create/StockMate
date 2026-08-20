import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/App/Urgent_RefillRequests_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Order_Details_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Request_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

class NesseryDepartmentRequestPage extends StatelessWidget {
  const NesseryDepartmentRequestPage({super.key});
  final String pageName = '/NesseryDepartmentRequestPage';

  @override
  Widget build(BuildContext context) {
    final UrgentRefillRequestsController controller = Get.find(
      // UrgentRefillRequestsController(fetchAll: true),
    );

    return Scaffold(
      body: Column(
        children: [
          CustomBackContainer(),
          CustomHeadContainer(title: 'طلبات الاقسام المستعجلة '),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.allRequests.isEmpty) {
                return const Center(child: CustomLoadingIndicator());
              }

              // ✅ حالة الخطأ مع إعادة المحاولة
              if (controller.hasError.value || controller.allRequests.isEmpty) {
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
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomEmptyState(tital: 'لا يوجد طلبات مستعجلة'),
                    TextButton(
                      onPressed: controller.refreshRequests,
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                );
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
                    itemCount: controller.allRequests.length,
                    itemBuilder: (context, index) {
                      final item = controller.allRequests[index];
                      return CustomRequestContainer(
                        date: item.formattedCreatedAt,
                        necessity: item.requestTypeLabel,
                        requester: item.department?.name ?? '',
                        state: item.statusLabel,
                        onTap: () async {
                          await Get.to(
                            () => DisOrderDetailsPage(requestId: item.id),
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