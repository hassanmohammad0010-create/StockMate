import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Completed_Request_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Electronic_Inventory_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Entry_And_Exit_Report_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Nessery_Department_Request_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Nessery_Purchasing_Request_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Suppliers_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Under_Implementation_Request_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_ListTile.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Name_Container.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Main_Page_Card.dart';

class BossHomePage extends StatelessWidget {
  const BossHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomNameContainer(
              empName: 'د.أحمد الاحمد',
              specializationName: 'مدير المستشفى',
            ),
            Wrap(
              children: [
                CustomMainPageCard(
                  requestNum: 5,
                  description: 'طلبات الاقسام',
                  icons: Icons.warning_amber_rounded,
                  buttomtital: 'بانتظار موافقتك',
                  iconBackgroundColor: constLightOrange,
                  iconColor: constOrange,
                  onTap: () {
                    Get.toNamed(NesseryDepartmentRequestPage().pageName);
                  },
                ),
                CustomMainPageCard(
                  requestNum: 4,
                  description: 'طلبات الشراء',
                  buttomtital: 'بانتظار موافقتك',

                  icons: Icons.warning_amber_rounded,
                  iconBackgroundColor: constLightOrange,
                  iconColor: constOrange,
                  onTap: () {
                    Get.toNamed(NesseryPurchasingRequestPage().pageName);
                  },
                ),

                CustomMainPageCard(
                  requestNum: 9,
                  description: 'طلبات قيد التنفيذ',
                  buttomtital: 'عرض التفاصيل',

                  icons: Icons.timelapse,
                  iconBackgroundColor: constLightBlue,
                  iconColor: constBlue,
                  onTap: () {
                    Get.toNamed(UnderImplementationRequestPage().pageName);
                  },
                ),
                CustomMainPageCard(
                  requestNum: 13,
                  description: 'طلبات مرفوضة',
                  buttomtital: 'عرض التفاصيل',
                  icons: Icons.check,
                  iconBackgroundColor: constLightRed,
                  iconColor: constRed,
                  onTap: () {
                    Get.toNamed(CompletedRequestPage().pageName);
                  },
                ),
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
              description: 'جرد شامل للمواد والكميات المتوفرة',
              icon: Icons.bar_chart_rounded,
              iconColor: constBlue,
              onTap: () {
                Get.toNamed(ElectronicInventoryPage().pageName);
              },
              title: 'تقرير جرد الكتروني',
            ),
            CustomListTile(
              backgroundColor: constLightBlue,
              description: 'سجل  لعمليات دخول وخروج المواد',
              icon: Icons.fact_check_rounded,
              iconColor: constBlue,
              onTap: () {
                Get.toNamed(EntryAndExitReportPage().pageName);
              },
              title: 'تقرير عمليات الدخول والخروج',
            ),
            CustomListTile(
              backgroundColor: constLightBlue,
              description: 'عرض كامل تفاصيل الموردين ',
              icon: Icons.shopping_cart,
              iconColor: constBlue,
              onTap: () {
                Get.toNamed(SuppliersPage().pageName);
              },
              title: 'الموردين',
            ),
            SizedBox(height: context.screenHeight * 0.01),
          ],
        ),
      ),
    );
  }
}
