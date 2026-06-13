// ignore_for_file: deprecated_member_use, file_names
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Create_Employee_Account_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Report_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_ListTile.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F6FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // لون الظل
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المعلومات الشخصية',
                      style: TextStyle(
                        color: constColor,
                        fontFamily: lateef,
                        fontSize: 32,
                      ),
                    ),
                    Divider(color: constLightGray, endIndent: 16, indent: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person),
                            Text(
                              'الاسم',
                              style: TextStyle(
                                color: constColor,
                                fontFamily: cairo,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'الدكتور محمد الاحمد',
                          style: TextStyle(
                            color: constGray,
                            fontFamily: cairo,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Divider(color: constLightGray, endIndent: 16, indent: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person),
                            Text(
                              'البريد الالكتروني',
                              style: TextStyle(
                                color: constColor,
                                fontFamily: cairo,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Flexible(
                          child: Text(
                            'hasanmohammad@gmail.com',
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: constGray,
                              fontFamily: cairo,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            CustomListTile(
              backgroundColor: constLightBlue,
              description: 'انشاء حساب جديد لموظف',
              icon: Icons.person,
              iconColor: constBlue,
              onTap: () {
                Get.toNamed(CreateEmployeeAccountPage().pageName);
              },
              title: 'انشاء حساب جديد',
            ),

            CustomListTile(
              backgroundColor: constLightBlue,
              description: 'طلب تغيير كلمة مرور الحساب',
              icon: Icons.password,
              iconColor: constBlue,
              onTap: () {},
              title: 'كلمة المرور',
            ),

            CustomListTile(
              backgroundColor: constLightBlue,
              description: 'قم بتقديم اقتراح او ابلاغ',
              icon: Icons.report,
              iconColor: constBlue,
              onTap: () {
                Get.toNamed(ReportPage().pageName);
              },
              title: 'تواصل معنا',
            ),

            // CustomListTile(
            //   backgroundColor: constLightBlue,
            //   description: 'تقديم ابلاغ',
            //   icon: Icons.report,
            //   iconColor: constBlue,
            //   onTap: () {},
            //   title: 'ابلاغ',
            // ),

            // CustomListTile(
            //   backgroundColor: constLightBlue,
            //   description: 'تقديم اقتراح',
            //   icon: Icons.headphones,
            //   iconColor: constBlue,
            //   onTap: () {},
            //   title: 'اقتراح',
            // ),
            CustomListTile(
              backgroundColor: constLightBlue,
              description: 'طلب حذف الحساب الشخصي',
              icon: Icons.delete,
              iconColor: constBlue,
              onTap: () {},
              title: 'حذف الحساب',
            ),

            CustomListTile(
              backgroundColor: constLightBlue,
              description: 'طلب تسجيل خروج من التطبيق',
              icon: Icons.logout,
              iconColor: constBlue,
              onTap: () {},
              title: 'تسجيل الخروج',
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          ],
        ),
      ),
    );
  }
}
