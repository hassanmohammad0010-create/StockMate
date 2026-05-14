// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/View/Widget/Shared_Widget/custom_Big_Card.dart';
import 'package:stock_mate_project/View/Widget/Shared_Widget/custom_Card.dart';
import 'package:stock_mate_project/View/Widget/Shared_Widget/custom_Head_Card.dart';

class DepartmentHeadsHomePage extends StatelessWidget {
  const DepartmentHeadsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF4F6FA),
      floatingActionButton:FloatingActionButton(
  backgroundColor: constDarkBlue,        
  foregroundColor: Colors.white,       
  splashColor: constColor,      
  elevation: 2.0,                      
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30),
  ),
  onPressed: () {},
  child: Icon(Icons.add),
),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomHeadCard(
              doctorName: 'الدكتور محمد علي',
              department: 'رئيس قسم الجراحة',
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.02,
              ),
              child: Row(
                children: [
                  CustomCard(
                    icon: Icon(Icons.check, size: 30, color: Color(0xFF09C05E)),
                    iconBackgroundColor: Color(0xFFE3FDED),
                    number: '105',
                    title: 'طلبات منجزة',
                    buttonColor: Color(0xFF09C05E),
                    buttonTitle: 'عرض التفاصيل',
                    onTap: () {},
                  ),
                  CustomCard(
                    icon: Icon(
                      Icons.more_time,
                      size: 30,
                      color: constDarkBlue,
                    ),
                    iconBackgroundColor: Color(0xFFE3F2FD),
                    number: '4',
                    title: 'طلبات قيد التنفيذ',
                    buttonColor: constDarkBlue,
                    buttonTitle: 'عرض التفاصيل',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.02,
              ),
              child: Row(
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
            ),
            Divider(
              height: 30,
              thickness: 1,
              indent: MediaQuery.of(context).size.width * 0.03,
              endIndent: MediaQuery.of(context).size.width * 0.03,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.03,
                ),
                child: Text(
                  'روشيتة جديدة / السلة',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            CustomBigCard(title: 'رفع روشيتة جديدة',icon: Icon(
                  Icons.sticky_note_2_outlined,
                  size: 40,
                  color: constDarkBlue,
                ),onTap: () {},),
            CustomBigCard(title: 'السلة اليومية',icon: Icon(
                  Icons.shopping_cart_outlined,
                  size: 40,
                  color: constDarkBlue,
                ),onTap: () {},),
            CustomBigCard(title: 'الأرشيف',icon: Icon(
                  Icons.archive_outlined,
                  size: 40,
                  color: constDarkBlue,
                ),onTap: () {},),
          ],
        ),
      ),
    );
  }
}
