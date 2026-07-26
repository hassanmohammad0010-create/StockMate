// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Service/Auth/Login_Service.dart';
import 'package:stock_mate_project/View/Screens/Auth/Enter_OTB_Page.dart';
import 'package:stock_mate_project/core/Function/Validation.dart';
import 'package:stock_mate_project/View/Widget/Auth/Custom_Circle.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Text_Failed.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final String pageName = '/LoginPage';
  final GlobalKey<FormState> loginPageKey = GlobalKey();
  String? email;
  static const Color darkNavy = Color(0xFF161B2E);
  static const Color skyBlue = Color(0xFF7FCBEE);
  static const Color primaryBlue = Color(0xFF1C6EA4);

  // ارتفاع التصميم المرجعي اللي اتبنت عليه القيم الثابتة الأصلية (520, 600, 50, ...)
  static const double _designHeight = 800;

  @override
  Widget build(context) {
    final double scale = context.screenHeight / _designHeight;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Form(
        key: loginPageKey,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: context.screenHeight,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 50 * scale,
                  color: constLightBlue,
                ),
                CustomCircle(
                  xAlignment: 1.5,
                  yAlignment: -0.5,
                  color: constBlue,
                  size: 0.9,
                ),
                CustomCircle(
                  xAlignment: -11.5,
                  yAlignment: -0.4,
                  color: constColor,
                  size: 0.9,
                ),
                CustomCircle(
                  xAlignment: 0,
                  yAlignment: -1.2,
                  size: 1.2,
                  color: constLightBlue,
                  child: Image.asset(
                    'assets/Image/Logo/Full_Logo.png',
                    height: 550 * scale,
                    width: 550 * scale,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 16,
                  top: 480 * scale,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اهلا بك !  ',
                        style: TextStyle(
                          color: constColor,
                          fontSize: context.screenHeight * 0.040,
                          fontWeight: FontWeight.bold,
                          fontFamily: cairo,
                        ),
                      ),
                      Text(
                        'الرجاء اكمال المعلومات لتسجيل الدخول',
                        style: TextStyle(
                          color: constGray,
                          fontSize: context.screenHeight * 0.02,
                          fontFamily: cairo,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomCircle(
                  xAlignment: 4,
                  yAlignment: 2.1,
                  size: 0.9,
                  color: constLightBlue,
                ),
                CustomCircle(
                  xAlignment: -3,
                  yAlignment: 2.2,
                  color: constBlue,
                  size: 0.9,
                ),
                CustomCircle(
                  xAlignment: 9.5,
                  yAlignment: 2.2,
                  color: constColor,
                  size: 0.9,
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 550 * scale,
                  child: Column(
                    children: [
                      SizedBox(height: context.screenHeight * 0.02),
                      CustomTextFormFaild(
                        labelText: 'البريد الالكتروني',
                        icon: Icon(
                          Icons.email_outlined,
                          size: context.screenHeight * 0.04,
                        ),
                        onChange: (data) {
                          email = data;
                        },
                        validator: (data) => Validation().emailValidate(data!),
                      ),
                      SizedBox(height: context.screenHeight * 0.02),
                      CustomButtom(
                        tital: 'تسجيل الدخول',
                        onTap: () async {
                          // if (loginPageKey.currentState!.validate()) {
                          //   bool response = await LoginService.loginService(
                          //     email: email!,
                          //   );
                          //   if (response) {
                          //     Get.to(() => EnterOTBPage(email: email!));
                          //   }
                          // }
                          Get.to(() => EnterOTBPage(email: email!));
                        },
                      ),
                      SizedBox(height: context.screenHeight * 0.01),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
