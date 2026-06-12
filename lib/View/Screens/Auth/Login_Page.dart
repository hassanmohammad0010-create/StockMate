// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Function/Shared/Validation.dart';
import 'package:stock_mate_project/View/Screens/App/Main_Page.dart';
import 'package:stock_mate_project/View/Screens/Auth/Enter_Account_Page.dart';
import 'package:stock_mate_project/View/Widget/Auth/Custom_Circle.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Text_Failed.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Drop_Down_Buttom.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final String pageName = '/LoginPage';
  final GlobalKey<FormState> loginPageKey = GlobalKey();

  @override
  Widget build(context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: loginPageKey,
        child: SizedBox(
          height: context.screenHeight,
          child: Stack(
            children: [
              CustomCircle(
                xAlignment: -0.2,
                yAlignment: -1.6,
                color: constBlue,
                size: 0.8,
              ),
              CustomCircle(
                xAlignment: -5.5,
                yAlignment: -0.9,
                color: constColor,
                size: 0.8,
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
                  top: context.screenHeight * 0.24,
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
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
                transform: Matrix4.translationValues(
                  0,
                  -context.keyboard + context.screenHeight * 0.09,
                  0,
                ),
                child: CustomCircle(
                  xAlignment: 0,
                  yAlignment: 4.5,
                  size: 1.88,
                  color: constColor,
                  child: SizedBox(
                    height: context.screenHeight * 1.5,
                    width: context.screenWidth,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: context.screenHeight * 0.07,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: context.screenHeight * 0.055,
                              fontFamily: lateef,
                            ),
                          ),
                          SizedBox(height: context.screenHeight * 0.02),

                          CustomDropDown(
                            itemList: specialties,
                            hintText: 'الهوية',
                            icon: Icon(
                              Icons.person_2_outlined,
                              size: context.screenHeight * 0.04,
                            ),
                            onChanched: (data) {},
                          ),

                          CustomTextFormFaild(
                            labelText: 'البريد الالكتروني',
                            icon: Icon(
                              Icons.email_outlined,
                              size: context.screenHeight * 0.04,
                            ),
                            onChange: (data) {},
                            validator: (data) =>
                                Validation().emailValidate(data!),
                          ),

                          CustomTextFormFaild(
                            labelText: 'كلمة المرور',
                            icon: Icon(
                              Icons.lock_outline,
                              size: context.screenHeight * 0.04,
                            ),
                            onChange: (data) {},
                            validator: (data) =>
                                Validation().passwordValidator(data!),
                          ),

                          SizedBox(height: context.screenHeight * 0.04),
                          CustomButtom(
                            tital: 'تسجيل الدخول',
                            onTap: () {
                              if (loginPageKey.currentState!.validate()) {}
                              Get.offNamed(MainPage().pageName);
                            },
                          ),

                          SizedBox(height: context.screenHeight * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(
                                    EnterAccountPage(operationName: 'confirm'),
                                  );
                                },
                                child: Text(
                                  'تأكيد حسابك ؟ ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: context.screenHeight * 0.028,
                                    fontFamily: lateef,
                                  ),
                                ),
                              ),
                              SizedBox(width: context.screenWidth * 0.02),
                              GestureDetector(
                                onTap: () {
                                  Get.to(
                                    EnterAccountPage(operationName: 'change'),
                                  );
                                },
                                child: Text(
                                  'هل نسيت كلمة المرور؟',
                                  style: TextStyle(
                                    color: constBlue,
                                    fontSize: context.screenHeight * 0.028,
                                    fontFamily: lateef,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
