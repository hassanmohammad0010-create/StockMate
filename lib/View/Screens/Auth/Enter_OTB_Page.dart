import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/View/Screens/App/Main_Page.dart';
import 'package:stock_mate_project/View/Screens/Auth/Reset_Password_Page.dart';
import 'package:stock_mate_project/View/Widget/Auth/Custom_Circle.dart';
import 'package:stock_mate_project/View/Widget/Auth/Custom_OTB.dart';

class EnterOTBPage extends StatelessWidget {
  const EnterOTBPage({
    super.key,
    required this.email,
    required this.operationName,
  });
  final String pageName = '/EnterOTBPage';
  final String email;
  final String operationName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: context.screenHeight * 0.08),
            child: Image.asset('assets/Image/OTB.png'),
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
              size: 1.75,
              color: constColor,
              child: SizedBox(
                height: context.screenHeight * 1.5,
                width: context.screenWidth,
                child: Padding(
                  padding: EdgeInsets.only(top: context.screenHeight * 0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.screenWidth * 0.04,
                        ),
                        child: Text(
                          'تأكيد البريد الالكتروني',
                          style: TextStyle(
                            fontSize: context.screenHeight * 0.034,
                            color: Colors.white,
                            fontFamily: lateef,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.screenWidth * 0.06,
                        ),
                        child: Text(
                          'قمنا بأرسال رمز التأكيد على الحساب المدخل الرجاء تفقد الحساب وادخال الرمز',
                          style: TextStyle(
                            fontSize: context.screenHeight * 0.028,
                            color: constGray,
                            fontFamily: lateef,
                          ),
                        ),
                      ),
                      SizedBox(height: context.screenHeight * 0.04),
                      CustomOtb(
                        onSubmit: (data) {
                          operationName == 'confirm'
                              ? Get.offAllNamed(MainPage().pageName)
                              : Get.toNamed(ResetPasswordPage().pageName);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
