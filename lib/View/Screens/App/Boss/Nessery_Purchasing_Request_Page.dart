import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:stock_mate_project/Controller/Service/Get_Urgent_Purchasing_Requests_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Display_Purchasing_Order_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Request_Container.dart';
import 'package:stock_mate_project/core/models/Purchase_Request_Model.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

class NesseryPurchasingRequestPage extends StatelessWidget {
  NesseryPurchasingRequestPage({super.key});
  final String pageName = '/NesseryPurchasingRequestPage';
  GetUrgentPurchasingRequestsController controller = Get.put(
    GetUrgentPurchasingRequestsController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomBackContainer(),
          CustomHeadContainer(title: 'طلبات الشراء الضرورية'),
          GetBuilder<GetUrgentPurchasingRequestsController>(
            builder: (controller) {
              return Expanded(
                child: controller.requests == null
                    ? CustomLoadingIndicator()
                    : controller.requests!.isEmpty
                    ? CustomEmptyState(tital: 'لا يوجد طلبات لعرضها...')
                    : ListView.builder(
                        padding: EdgeInsets.only(top: 0),
                        itemCount: controller.requests!.length,
                        itemBuilder: (context, index) {
                          return CustomRequestContainer(
                            requester: controller.requests![index].requester,
                            state:
                                controller.requests![index].status.arabicLabel,
                            date:
                                '${controller.requests![index].date.year}-${controller.requests![index].date.month}-${controller.requests![index].date.day}',
                            necessity: controller
                                .requests![index]
                                .requestType
                                .arabicLabel,
                            onTap: () {
                              Get.to(DisplayPurchasingOrderPage());
                            },
                          );
                        },
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
