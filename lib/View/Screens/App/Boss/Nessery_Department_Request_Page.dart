import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Service/Get_Urgent_Department_Requests_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Order_Details_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Request_Container.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

class NesseryDepartmentRequestPage extends StatelessWidget {
  NesseryDepartmentRequestPage({super.key});
  final String pageName = '/NesseryDepartmentRequestPage';
  GetUrgentDepartmentRequestsController controller = Get.put(
    GetUrgentDepartmentRequestsController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomBackContainer(),
          CustomHeadContainer(title: 'طلبات الاقسام الضرورية'),
          GetBuilder<GetUrgentDepartmentRequestsController>(
            builder: (controller) {
              return controller.requests == null
                  ? Expanded(child: Center(child: CustomLoadingIndicator()))
                  : controller.requests!.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text(
                          'لا يوجد موردين لعرضهم....',
                          style: TextStyle(fontFamily: cairo, fontSize: 24),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 0),
                        itemCount: controller.requests!.length,
                        itemBuilder: (context, index) {
                          return CustomRequestContainer(
                            requestModel: controller.requests![index],
                            onTap: () {
                              Get.to(
                                () => DisOrderDetailsPage(
                                  requestModel: controller.requests![index],
                                ),
                              );
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
