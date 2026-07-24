// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/View/Screens/Auth/Enter_OTB_Page.dart';
import 'package:stock_mate_project/core/Function/Validation.dart';
import 'package:stock_mate_project/View/Widget/Auth/Custom_Circle.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Text_Failed.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Drop_Down_Buttom.dart';
import 'package:stock_mate_project/main.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final String pageName = '/LoginPage';
  final GlobalKey<FormState> loginPageKey = GlobalKey();
  String? email;
  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Form(
        key: loginPageKey,
        child: SizedBox(
          height: context.screenHeight,
          child: Stack(
            children: [
              CustomCircle(
                xAlignment: 1.0,
                yAlignment: -1.6,
                color: constBlue,
                size: 0.9,
              ),
              CustomCircle(
                xAlignment: -11.5,
                yAlignment: -0.9,
                color: constColor,
                size: 0.9,
              ),
              CustomCircle(
                xAlignment: -2.2,
                yAlignment: -1.2,
                size: 0.8,
                color: constLightBlue,
                child: Image.asset('assets/Image/Logo/Text_Logo.png'),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: context.screenHeight * 0.28,
                  right: context.screenWidth * 0.04,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اهلا بك !  ',
                      style: TextStyle(
                        color: constColor,
                        fontSize: context.screenHeight * 0.055,
                        fontWeight: FontWeight.bold,
                        fontFamily: lateef,
                      ),
                    ),
                    Text(
                      'الرجاء اكمال المعلومات لتسجيل الدخول',
                      style: TextStyle(
                        color: constGray,
                        fontSize: context.screenHeight * 0.03,
                        fontFamily: lateef,
                      ),
                    ),
                  ],
                ),
              ),
              CustomCircle(
                xAlignment: 4,
                yAlignment: 1.6,
                size: 0.9,
                color: constLightBlue,
              ),

              CustomCircle(
                xAlignment: -3,
                yAlignment: 1.9,
                color: constBlue,
                size: 0.9,
              ),
              CustomCircle(
                xAlignment: 9.5,
                yAlignment: 1.7,
                color: constColor,
                size: 0.9,
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 220,
                child: Column(
                  children: [
                    SizedBox(height: context.screenHeight * 0.02),
                    CustomDropDown(
                      itemList: identities,
                      hintText: 'الهوية',
                      icon: Icon(
                        Icons.person_2_outlined,
                        size: context.screenHeight * 0.04,
                      ),
                      onChanched: (data) {
                        identitySharedPreferences!.setString('identity', data!);
                      },
                    ),

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

                    SizedBox(height: context.screenHeight * 0.04),
                    CustomButtom(
                      tital: 'تسجيل الدخول',
                      onTap: () {
                        if (loginPageKey.currentState!.validate()) {
                          Get.to(() => EnterOTBPage(email: email!));
                        }
                        // Get.offNamed(AppRoutes.MainPage);
                        // Get.offNamed(AppRoutes.DepartmentHeadsMainPage);
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
    );
  }
}
