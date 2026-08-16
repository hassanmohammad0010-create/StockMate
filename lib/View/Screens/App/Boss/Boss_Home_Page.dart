import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Urgent_RefillRequests_Controller.dart';
import 'package:stock_mate_project/Controller/Service/Get_Name_Roll_Of_User.dart';
import 'package:stock_mate_project/Controller/App/Urgent_Purchase_Requests_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/User_Mangment_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_ListTile.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Name_Container.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Main_Page_Card.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

// ignore: must_be_immutable
class BossHomePage extends StatelessWidget {
  BossHomePage({super.key});
  GetNameRollOfUserController getNameRollOfUserController = Get.put(
    GetNameRollOfUserController(),
  );
  final UrgentRefillRequestsController urgentRefillRequestsController = Get.put(
    UrgentRefillRequestsController(fetchAll: true),
  );
  final UrgentPurchaseRequestsController urgentPurchaseRequestsController =
      Get.put(
        UrgentPurchaseRequestsController(
          status: 'pending_hospital_approval',
          priority: 'urgent',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GetBuilder<GetNameRollOfUserController>(
          builder: (controller) {
            return Column(
              children: [
                CustomNameContainer(
                  empName: 'د.${controller.name}',
                  specializationName: 'مدير المستشفى',
                ),
                Wrap(
                  children: [
                    // ← كرت طلبات الأقسام: لودينغ لحد ما يخلص urgentRefillRequestsController
                    Obx(() {
                      if (urgentRefillRequestsController.isLoading.value) {
                        return SizedBox(
                          width: context.screenWidth * 0.44,
                          height: context.screenHeight * 0.12,
                          child: const Center(child: CustomLoadingIndicator()),
                        );
                      }
                      return CustomMainPageCard(
                        requestNum:
                            urgentRefillRequestsController.allRequests.length,
                        description: 'طلبات الاقسام',
                        icons: Icons.warning_amber_rounded,
                        buttomtital: 'بانتظار موافقتك',
                        iconBackgroundColor: constLightOrange,
                        iconColor: constOrange,
                        onTap: () {
                          Get.toNamed(AppRoutes.NesseryDepartmentRequestPage);
                        },
                      );
                    }),
                    // ← كرت طلبات الشراء: لودينغ لحد ما يخلص urgentPurchaseRequestsController
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
                      'التقارير والادوات',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: cairo,
                        fontSize: context.screenHeight * 0.033,
                      ),
                    ),
                  ),
                ),

                CustomListTile(
                  backgroundColor: constLightBlue,
                  description: 'اضافة -الغاء تنشيط -ربط الموظفين',
                  icon: Icons.emoji_people_outlined,
                  iconColor: constBlue,
                  onTap: () {
                    Get.to(() => UserMangmentPage());
                  },
                  title: 'ادارة الموظفين ',
                ),
                CustomListTile(
                  backgroundColor: constLightBlue,
                  description: 'جرد شامل للمواد والكميات المتوفرة',
                  icon: Icons.bar_chart_rounded,
                  iconColor: constBlue,
                  onTap: () {
                    Get.toNamed(AppRoutes.ElectronicInventoryPage);
                  },
                  title: 'تقرير جرد الكتروني',
                ),
                // CustomListTile(
                //   backgroundColor: constLightBlue,
                //   description: 'سجل  لعمليات دخول وخروج المواد',
                //   icon: Icons.fact_check_rounded,
                //   iconColor: constBlue,
                //   onTap: () {
                //     Get.toNamed(AppRoutes.EntryAndExitReportPage);
                //   },
                //   title: 'تقرير عمليات الدخول والخروج',
                // ),
                CustomListTile(
                  backgroundColor: constLightBlue,
                  description: 'عرض كامل تفاصيل الموردين ',
                  icon: Icons.shopping_cart,
                  iconColor: constBlue,
                  onTap: () {
                    Get.toNamed(AppRoutes.SuppliersPage);
                  },
                  title: 'الموردين',
                ),
                SizedBox(height: context.screenHeight * 0.01),
              ],
            );
          },
        ),
      ),
    );
  }
}
