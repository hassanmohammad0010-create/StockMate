// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/DepartmentHeadsMainTabController.dart';
import 'package:stock_mate_project/Controller/Logic/Orders_Controller.dart';
import 'package:stock_mate_project/Controller/Service/Get_Name_Roll_Of_User.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_ListTile.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Name_Container.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

class DepartmentHeadsHomePage extends StatelessWidget {
  DepartmentHeadsHomePage({super.key});

  final OrdersController ordersController = Get.put(OrdersController());
  final GetNameRollOfUserController getNameRollOfUserController = Get.put(
    GetNameRollOfUserController(),
  );
  final DepartmentHeadsMainTabController mainTabController =
      Get.find<DepartmentHeadsMainTabController>();

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: GetBuilder<GetNameRollOfUserController>(
        builder: (controller) {
          return (controller.name == null || controller.departmentName == null)
              ? CustomLoadingIndicator()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomNameContainer(
                        empName: 'د. ${controller.name}',
                        specializationName:
                            'رئيس قسم ${controller.departmentName}',
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: w * 0.02),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Obx(
                                  () => CustomCard(
                                    icon: Icon(
                                      Icons.check,
                                      size: 30,
                                      color: constGreen,
                                    ),
                                    iconBackgroundColor: constLightGreen,
                                    number: ordersController.completedCount
                                        .toString(),
                                    title: 'طلبات منجزة',
                                    buttonColor: constGreen,
                                    buttonTitle: 'عرض التفاصيل',
                                    onTap: () {
                                      mainTabController.tabController.animateTo(
                                        2,
                                      );
                                      ordersController.initialFilter.value =
                                          'منجز';
                                    },
                                  ),
                                ),
                                Obx(
                                  () => CustomCard(
                                    icon: Icon(
                                      Icons.more_time,
                                      size: 30,
                                      color: constBlue,
                                    ),
                                    iconBackgroundColor: constLightBlue,
                                    number: ordersController.inProgressCount
                                        .toString(),
                                    title: 'طلبات قيد التنفيذ',
                                    buttonColor: constBlue,
                                    buttonTitle: 'عرض التفاصيل',
                                    onTap: () {
                                      mainTabController.tabController.animateTo(
                                        2,
                                      );
                                      ordersController.initialFilter.value =
                                          'قيد التنفيذ';
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Obx(
                                  () => CustomCard(
                                    icon: Icon(
                                      Icons.warning_amber_rounded,
                                      size: 30,
                                      color: constOrange,
                                    ),
                                    iconBackgroundColor: constLightOrange,
                                    number: ordersController.suspendedCount
                                        .toString(),
                                    title: 'بانتظار الموافقة',
                                    buttonColor: constOrange,
                                    buttonTitle: 'عرض التفاصيل',
                                    onTap: () {
                                      mainTabController.tabController.animateTo(
                                        2,
                                      );
                                      ordersController.initialFilter.value =
                                          'معلق';
                                    },
                                  ),
                                ),
                                Obx(
                                  () => CustomCard(
                                    icon: Icon(
                                      Icons.cancel_outlined,
                                      size: 30,
                                      color: constRed,
                                    ),
                                    iconBackgroundColor: constLightRed,
                                    number: ordersController.rejectedCount
                                        .toString(),
                                    title: 'طلبات مرفوضة',
                                    buttonColor: constRed,
                                    buttonTitle: 'عرض التفاصيل',
                                    onTap: () {
                                      mainTabController.tabController.animateTo(
                                        2,
                                      );
                                      ordersController.initialFilter.value =
                                          'مرفوض';
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: h * 0.01),
                      Divider(
                        endIndent: w * 0.03,
                        indent: w * 0.03,
                        color: constGray,
                      ),
                      controller.role == 'department_manager'
                          ? Column(
                              children: [
                                Align(
                                  alignment: AlignmentGeometry.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: w * 0.05),
                                    child: Text(
                                      'المرضى / السلة',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: cairo,
                                        fontSize: 28,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: h * 0.01),                 
                                CustomListTile(
                                  backgroundColor: constLightBlue,
                                  description: 'معاينة المرضى',
                                  icon: Icons.person_outline,
                                  iconColor: constBlue,
                                  onTap: () {
                                    Get.toNamed(AppRoutes.PatientsPage);
                                  },
                                  title: 'المرضى',
                                ),
                                // SizedBox(height: h * 0.01),
                                CustomListTile(
                                  backgroundColor: constLightBlue,
                                  description:
                                      'عرض تفاصيل المواد اليومية المطلوبة',
                                  icon: Icons.shopping_cart,
                                  iconColor: constBlue,
                                  onTap: () {
                                    Get.toNamed(AppRoutes.CartPage);
                                  },
                                  title: 'السلة',
                                ),
                                CustomListTile(
                                  backgroundColor: constLightBlue,
                                  description:
                                      'عرض الأرشيف للمصروفات اليومية السابقة',
                                  icon: Icons.fact_check_rounded,
                                  iconColor: constBlue,
                                  onTap: () {
                                    Get.toNamed(AppRoutes.ArchivePage);
                                  },
                                  title: 'الأرشيف',
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Align(
                                  alignment: AlignmentGeometry.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: w * 0.05),
                                    child: Text(
                                      'الوصفات الطبية',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: cairo,
                                        fontSize: 28,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: h * 0.01),
                                CustomListTile(
                                  backgroundColor: constLightBlue,
                                  description:
                                      'الوصفات الطبية الجديدة المرسلة من الأطباء',
                                  icon: Icons.description_outlined,
                                  iconColor: constBlue,
                                  onTap: () {
                                    Get.toNamed(AppRoutes.PrescriptionsPage);
                                  },
                                  title: 'الوصفات الطبية الجديدة',
                                ),
                              ],
                            ),
                      SizedBox(height: h * 0.01),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
