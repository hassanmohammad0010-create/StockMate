// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_ListTile.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Name_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/custom_Card.dart';

class DepartmentHeadsHomePage extends StatelessWidget {
  const DepartmentHeadsHomePage({super.key});

  final String pageName = '/DepartmentHeadsHomePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F6FA),
      floatingActionButton: FloatingActionButton(
        backgroundColor: constBlue,
        foregroundColor: Colors.white,
        splashColor: constColor,
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomNameContainer(
              empName: 'محمد علي',
              specializationName: 'رئيس قسم الأشعة',
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.02,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomCard(
                        icon: Icon(
                          Icons.check,
                          size: 30,
                          color: Color(0xFF09C05E),
                        ),
                        iconBackgroundColor: Color(0xFFE3FDED),
                        number: '105',
                        title: 'طلبات منجزة',
                        buttonColor: Color(0xFF09C05E),
                        buttonTitle: 'عرض التفاصيل',
                        onTap: () {},
                      ),
                      CustomCard(
                        icon: Icon(Icons.more_time, size: 30, color: constBlue),
                        iconBackgroundColor: Color(0xFFE3F2FD),
                        number: '4',
                        title: 'طلبات قيد التنفيذ',
                        buttonColor: constBlue,
                        buttonTitle: 'عرض التفاصيل',
                        onTap: () {},
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CustomCard(
                        icon: Icon(
                          Icons.warning_amber_rounded,
                          size: 30,
                          color: Color(0xFFFFBF00),
                        ),
                        iconBackgroundColor: Color(0xFFFFF8E2),
                        number: '32',
                        title: 'بانتظار الموافقة',
                        buttonColor: Color(0xFFFFBF00),
                        buttonTitle: 'عرض التفاصيل',
                        onTap: () {},
                      ),
                      CustomCard(
                        icon: Icon(
                          Icons.cancel_outlined,
                          size: 30,
                          color: Color(0xFFFF2125),
                        ),
                        iconBackgroundColor: Color(0xFFFFEBEE),
                        number: '10',
                        title: 'طلبات مرفوضة',
                        buttonColor: Color(0xFFFF2125),
                        buttonTitle: 'عرض التفاصيل',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Divider(endIndent: 16, indent: 16, color: constGray),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Align(
              alignment: AlignmentGeometry.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  'روشيتة جديدة / السلة',
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
              description: 'طلب رفع روشيتة لمريض',
              icon: Icons.bar_chart_rounded,
              iconColor: constBlue,
              onTap: () {},
              title: 'رفع روشيتة جديدة',
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            CustomListTile(
              backgroundColor: constLightBlue,
              description: 'عرض تفاصيل المواد اليومية المطلوبة',
              icon: Icons.shopping_cart,
              iconColor: constBlue,
              onTap: () {},
              title: 'السلة',
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            CustomListTile(
              backgroundColor: constLightBlue,
              description: 'عرض الأرشيف للمصروفات اليومية السابقة',
              icon: Icons.fact_check_rounded,
              iconColor: constBlue,
              onTap: () {},
              title: 'الأرشيف',
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          ],
        ),
      ),
    );
  }
}
