import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_ListTile.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Name_Container.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Main_Page_Card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                  requestNum: 13,
                  description: 'طلبات منجزة',
                  icons: Icons.check,
                  iconBackgroundColor: constlightGreen,
                  iconColor: constGreen,
                ),
                CustomMainPageCard(
                  requestNum: 9,
                  description: 'طلبات قيد التنفيذ',
                  icons: Icons.timelapse,
                  iconBackgroundColor: constLightBlue,
                  iconColor: constBlue,
                ),
                CustomMainPageCard(
                  requestNum: 5,
                  description: 'طلبات الاقسام',
                  icons: Icons.warning_amber_rounded,
                  iconBackgroundColor: constLightOrange,
                  iconColor: constOrange,
                ),
                CustomMainPageCard(
                  requestNum: 4,
                  description: 'طلبات الشراء',
                  icons: Icons.warning_amber_rounded,
                  iconBackgroundColor: constLightOrange,
                  iconColor: constOrange,
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Divider(endIndent: 16, indent: 16, color: constGray),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Align(
              alignment: AlignmentGeometry.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 4),
                child: Text(
                  'التقارير والادوات',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: cairo,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            CustomListTile(
              backgroundColor: constLightBlue,
              description: 'جرد شامل للمواد والكميات المتوفرة',
              icon: Icons.bar_chart_rounded,
              iconColor: constBlue,
              onTap: () {},
              title: 'تقرير جرد الكتروني',
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            CustomListTile(
              backgroundColor: constLightBlue,
              description: 'سجل  لعمليات دخول وخروج المواد',
              icon: Icons.fact_check_rounded,
              iconColor: constBlue,
              onTap: () {},
              title: 'تقرير عمليات الدخول والخروج',
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            CustomListTile(
              backgroundColor: constLightBlue,
              description: 'عرض كامل تفاصيل الموردين ',
              icon: Icons.shopping_cart,
              iconColor: constBlue,
              onTap: () {},
              title: 'الموردين',
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          ],
        ),
      ),
    );
  }
}
