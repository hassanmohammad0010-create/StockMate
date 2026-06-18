import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Nessery_Department_Request_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Nessery_Purchasing_Request_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Main_Page_Card.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Name_Container.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Suppliers_Container.dart';

class HeadOfPurchasingHomePage extends StatelessWidget {
  HeadOfPurchasingHomePage({super.key});
  final List<String> suppliersCategories = [
    'بارا سيتامول',
    'شاش',
    'قفازات',
    'بارا سيتامول', // ملاحظة: مكررة، يمكنك إزالتها إذا كان ذلك غير مقصود
    'انسولين',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomNameContainer(
              empName: 'د.أحمد الاحمد',
              specializationName: 'رئيس لجنة الشراء',
            ),
            Wrap(
              children: [
                CustomMainPageCard(
                  requestNum: 5,
                  description: 'طلبات جديدة',
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
                  description: 'طلبات قيد التنفيذ',
                  buttomtital: 'عرض التفاصيل',

                  icons: Icons.warning_amber_rounded,
                  iconBackgroundColor: constLightBlue,
                  iconColor: constBlue,
                  onTap: () {},
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
                  'الموردين ',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: cairo,
                    fontSize: context.screenHeight * 0.033,
                  ),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 4, bottom: 16),
              itemCount: 6,
              itemBuilder: (context, index) {
                return CustomSuppliersContainer(category: suppliersCategories);
              },
            ),
            SizedBox(height: context.screenHeight * 0.01),
          ],
        ),
      ),
    );
  }
}
