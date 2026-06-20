// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Function/Shared/Validation.dart';
import 'package:stock_mate_project/View/Screens/Auth/Enter_OTB_Page.dart';
import 'package:stock_mate_project/View/Widget/Auth/Custom_Circle.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Text_Failed.dart';

class EnterAccountPage extends StatelessWidget {
  EnterAccountPage({super.key, required this.operationName});
  final String pageName = '/EnterAccountPage';
  final GlobalKey<FormState> confirmAccountKey = GlobalKey();
  String? email;
  String operationName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: confirmAccountKey,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: context.screenHeight * 0.05),
              child: Image.asset('assets/Image/Verify_Email.png'),
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
                yAlignment: 4,
                size: 1.75,
                color: constColor,
                child: SizedBox(
                  height: context.screenHeight * 1.5,
                  width: context.screenWidth,
                  child: Padding(
                    padding: EdgeInsets.only(top: context.screenHeight * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: context.screenHeight * 0.04),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.screenWidth * 0.04,
                          ),
                          child: Text(
                            'البريد الالكتروني',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: context.screenHeight * 0.038,
                              fontWeight: FontWeight.bold,
                              fontFamily: lateef,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.screenWidth * 0.04,
                          ),
                          child: Text(
                            'الرجاء ادخال البريد الالكتروني الخاص بك من اجل رمز التحقق',
                            style: TextStyle(
                              color: constGray,
                              fontSize: context.screenHeight * 0.028,
                              fontWeight: FontWeight.bold,
                              fontFamily: lateef,
                            ),
                          ),
                        ),
                        SizedBox(height: context.screenHeight * 0.04),
                        CustomTextFormFaild(
                          labelText: 'البريد الالكتروني',
                          icon: Icon(
                            Icons.email_outlined,
                            size: context.screenHeight * 0.04,
                          ),
                          onChange: (data) {
                            email = data;
                          },
                          validator: (data) {
                            return Validation().emailValidate(data!);
                          },
                        ),
                        SizedBox(height: context.screenHeight * 0.05),
                        Align(
                          alignment: AlignmentGeometry.center,
                          child: CustomButtom(
                            tital: 'تأكيد',
                            onTap: () {
                              if (confirmAccountKey.currentState!.validate()) {
                                Get.to(
                                  () => EnterOTBPage(
                                    email: email!,
                                    operationName: operationName,
                                  ),
                                );
                              }
                            },
                          ),
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
    );
  }
}
