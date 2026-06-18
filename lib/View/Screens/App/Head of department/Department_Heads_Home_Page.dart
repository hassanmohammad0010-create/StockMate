// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Orders_Controller.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_ListTile.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Name_Container.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Card.dart';

class DepartmentHeadsHomePage extends StatelessWidget {
  DepartmentHeadsHomePage({super.key});

  final OrdersController ordersController = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomNameContainer(
              empName: 'د. محمد علي',
              specializationName: 'رئيس قسم الداخلية',
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: context.screenWidth * 0.02,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Obx(
                        () => CustomCard(
                          icon: Icon(
                            Icons.check,
                            size: 30,
                            color: Color(0xFF09C05E),
                          ),
                          iconBackgroundColor: Color(0xFFE3FDED),
                          number: ordersController.completedCount
                              .toString(), // ← بدلاً من '2'
                          title: 'طلبات منجزة',
                          buttonColor: Color(0xFF09C05E),
                          buttonTitle: 'عرض التفاصيل',
                          onTap: () {
                            DefaultTabController.of(context).animateTo(2);
                            ordersController.initialFilter.value = 'منجز';
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
                          iconBackgroundColor: Color(0xFFE3F2FD),
                          number: ordersController.inProgressCount.toString(),
                          title: 'طلبات قيد التنفيذ',
                          buttonColor: constBlue,
                          buttonTitle: 'عرض التفاصيل',
                          onTap: () {
                            DefaultTabController.of(context).animateTo(2);
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
                            color: Color(0xFFFFBF00),
                          ),
                          iconBackgroundColor: Color(0xFFFFF8E2),
                          number: ordersController.suspendedCount.toString(),
                          title: 'بانتظار الموافقة',
                          buttonColor: Color(0xFFFFBF00),
                          buttonTitle: 'عرض التفاصيل',
                          onTap: () {
                            DefaultTabController.of(context).animateTo(2);
                            ordersController.initialFilter.value = 'معلق';
                          },
                        ),
                      ),
                      Obx(
                        () => CustomCard(
                          icon: Icon(
                            Icons.cancel_outlined,
                            size: 30,
                            color: Color(0xFFFF2125),
                          ),
                          iconBackgroundColor: Color(0xFFFFEBEE),
                          number: ordersController.rejectedCount.toString(),
                          title: 'طلبات مرفوضة',
                          buttonColor: Color(0xFFFF2125),
                          buttonTitle: 'عرض التفاصيل',
                          onTap: () {
                            DefaultTabController.of(context).animateTo(2);
                            ordersController.initialFilter.value = 'مرفوض';
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: context.screenHeight * 0.01),
            Divider(endIndent: 16, indent: 16, color: constGray),
            Align(
              alignment: AlignmentGeometry.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  'وصفة طبية جديدة / السلة',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: cairo,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            SizedBox(height: context.screenHeight * 0.01),
            CustomListTile(
              backgroundColor: constLightBlue,
              description: 'الوصفات الطبية الجديدة المرسلة من الأطباء',
              icon: Icons.description_outlined,
              iconColor: constBlue,
              onTap: () {
                Get.toNamed(AppRoutes.PrescriptionsPage);
              },
              title: 'الوصفات الطبية الجديدة',
            ),
            SizedBox(height: context.screenHeight * 0.01),
            CustomListTile(
              backgroundColor: constLightBlue,
              description: 'طلب رفع روشيتة لمريض',
              icon: Icons.bar_chart_rounded,
              iconColor: constBlue,
              onTap: () {
                Get.toNamed(AppRoutes.SendPrescriptionPage);
              },
              title: 'رفع روشيتة جديدة',
            ),
            SizedBox(height: context.screenHeight * 0.01),
            CustomListTile(
              backgroundColor: constLightBlue,
              description: 'عرض تفاصيل المواد اليومية المطلوبة',
              icon: Icons.shopping_cart,
              iconColor: constBlue,
              onTap: () {
                Get.toNamed(AppRoutes.CartPage);
              },
              title: 'السلة',
            ),
            SizedBox(height: context.screenHeight * 0.01),
            CustomListTile(
              backgroundColor: constLightBlue,
              description: 'عرض الأرشيف للمصروفات اليومية السابقة',
              icon: Icons.fact_check_rounded,
              iconColor: constBlue,
              onTap: () {
                Get.toNamed(AppRoutes.ArchivePage);
              },
              title: 'الأرشيف',
            ),
            SizedBox(height: context.screenHeight * 0.01),
          ],
        ),
      ),
    );
  }
}
