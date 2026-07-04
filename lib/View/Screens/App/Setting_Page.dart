// ignore_for_file: deprecated_member_use, file_names
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_ListTile.dart';
import 'package:stock_mate_project/core/Function/Custom_Dialog.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.02,
                vertical: h * 0.01,
              ),
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
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.02,
                  vertical: h * 0.02,
                ),
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
                    Divider(
                      color: constLightGray,
                      endIndent: w * 0.02,
                      indent: w * 0.02,
                    ),
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
                    Divider(
                      color: constLightGray,
                      endIndent: w * 0.02,
                      indent: w * 0.02,
                    ),
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
                        SizedBox(width: w * 0.02),
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
                Get.toNamed(AppRoutes.CreateEmployeeAccountPage);
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
                Get.toNamed(AppRoutes.ReportPage);
              },
              title: 'تواصل معنا',
            ),

            CustomListTile(
              backgroundColor: constLightBlue,
              description: 'طلب حذف الحساب الشخصي',
              icon: Icons.delete,
              iconColor: constBlue,
              onTap: () {
                showConfirmDialog(
                  onConfirm: () {},
                  tital: 'هل انت متأكد',
                  sub: 'انت على وشك حذف حسابك',
                );
              },
              title: 'حذف الحساب',
            ),

            CustomListTile(
              backgroundColor: constLightBlue,
              description: 'طلب تسجيل خروج من التطبيق',
              icon: Icons.logout,
              iconColor: constBlue,
              onTap: () {
                showConfirmDialog(
                  onConfirm: () {},
                  tital: 'هل انت متأكد',
                  sub: 'انت على وشك تسجيل الخروج من حسابك ',
                );
              },
              title: 'تسجيل الخروج',
            ),
            SizedBox(height: h * 0.01),
          ],
        ),
      ),
    );
  }
}
