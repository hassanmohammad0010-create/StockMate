import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Get_All_Suppliers_Controller.dart';
import 'package:stock_mate_project/Controller/App/Urgent_Purchase_Requests_Controller.dart';
import 'package:stock_mate_project/Controller/Service/Get_Name_Roll_Of_User.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Under_Implementation_Request_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Main_Page_Card.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Name_Container.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Suppliers_Container.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

// ignore: must_be_immutable
class HeadOfPurchasingHomePage extends StatelessWidget {
  HeadOfPurchasingHomePage({super.key});

  GetAllSuppliersController getAllSuppliersController = Get.put(
    GetAllSuppliersController(),
  );
  GetNameRollOfUserController getNameRollOfUserController = Get.put(
    GetNameRollOfUserController(),
  );
  final UrgentPurchaseRequestsController urgentPurchaseRequestsController =
      Get.put(
        UrgentPurchaseRequestsController(
          status: 'pending_manager_approval',
          priority: 'urgent',
        ),
        tag: 'urgent_purchase_requests',
      );
  final UrgentPurchaseRequestsController preparingPurchaseRequestsController =
      Get.put(
        UrgentPurchaseRequestsController(status: 'preparing'),
        tag: 'preparing_purchase_requests',
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        // ✅ لودينغ لكامل الصفحة لحد ما توصل بيانات المستخدم
        if (getNameRollOfUserController.name.value == null) {
          return const Center(child: CustomLoadingIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              CustomNameContainer(
                empName: 'د. ${getNameRollOfUserController.name.value}' ?? '',
                specializationName: 'رئيس لجنة الشراء',
              ),
              Wrap(
                children: [
                  Obx(() {
                    if (urgentPurchaseRequestsController.isLoading.value) {
                      return SizedBox(
                        width: context.screenWidth * 0.44,
                        height: context.screenHeight * 0.12,
                        child: const Center(child: CustomLoadingIndicator()),
                      );
                    }
                    return CustomMainPageCard(
                      requestNum:
                          urgentPurchaseRequestsController.allRequests.length,
                      description: 'طلبات الشراء',
                      buttomtital: 'بانتظار موافقتك',
                      icons: Icons.warning_amber_rounded,
                      iconBackgroundColor: constLightOrange,
                      iconColor: constOrange,
                      onTap: () {
                        Get.toNamed(AppRoutes.NesseryPurchasingRequestPage);
                      },
                    );
                  }),
                  Obx(() {
                    if (preparingPurchaseRequestsController.isLoading.value) {
                      return SizedBox(
                        width: context.screenWidth * 0.44,
                        height: context.screenHeight * 0.12,
                        child: const Center(child: CustomLoadingIndicator()),
                      );
                    }
                    return CustomMainPageCard(
                      requestNum: preparingPurchaseRequestsController
                          .allRequests
                          .length,
                      description: 'طلبات قيد التنفيذ',
                      buttomtital: 'عرض التفاصيل',

                      icons: Icons.warning_amber_rounded,
                      iconBackgroundColor: constLightBlue,
                      iconColor: constBlue,
                      onTap: () {
                        Get.to(() => UnderImplementationRequestPage());
                      },
                    );
                  }),
                ],
              ),
              SizedBox(height: context.screenHeight * 0.01),
              Divider(endIndent: 16, indent: 16, color: constGray),
              SizedBox(height: context.screenHeight * 0.01),
              Align(
                alignment: AlignmentGeometry.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: context.screenWidth * 0.04,
                    bottom: context.screenHeight * 0.005,
                  ),
                  child: Text(
                    'الموردين ',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: cairo,
                      fontSize: context.screenHeight * 0.033,
                    ),
                  ),
                ),
              ),
              GetBuilder<GetAllSuppliersController>(
                builder: (controller) {
                  return controller.suppliers == null
                      ? CustomLoadingIndicator()
                      : controller.suppliers!.isEmpty
                      ? CustomEmptyState(tital: 'لا يوجد موردين لعرضهم')
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(top: 4, bottom: 16),
                          itemCount: controller.suppliers!.length,
                          itemBuilder: (context, index) {
                            return CustomSuppliersContainer(
                              supplierModel: controller.suppliers![index],
                            );
                          },
                        );
                },
              ),
              SizedBox(height: context.screenHeight * 0.01),
            ],
          ),
        );
      }),
    );
  }
}
