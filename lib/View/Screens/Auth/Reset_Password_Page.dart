import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Function/Shared/Validation.dart';
import 'package:stock_mate_project/View/Screens/Auth/Login_Page.dart';
import 'package:stock_mate_project/View/Widget/Auth/Custom_Circle.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Text_Failed.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage({super.key});
  final String pageName = '/ResetPasswordPage';
  final GlobalKey<FormState> resetPasswordPageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: resetPasswordPageKey,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: context.screenHeight * 0.04),
              child: Image.asset('assets/Image/Reset_Password.png'),
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
                    padding: EdgeInsets.only(top: context.screenHeight * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: context.screenHeight * 0.04),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.screenWidth * 0.04,
                          ),
                          child: Text(
                            'اعادة تعيين كلمة المرور',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: context.screenHeight * 0.034,
                              fontFamily: lateef,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.screenWidth * 0.07,
                          ),
                          child: Text(
                            'الرجاء ادخال كلمة المرور الجديدة ',
                            style: TextStyle(
                              color: constGray,
                              fontSize: context.screenHeight * 0.028,
                              fontFamily: lateef,
                            ),
                          ),
                        ),
                        SizedBox(height: context.screenHeight * 0.02),
                        CustomTextFormFaild(
                          labelText: 'كلمة المرور',
                          icon: Icon(
                            Icons.lock_outline,
                            size: context.screenHeight * 0.04,
                          ),
                          onChange: (data) {},
                          validator: (data) {
                            return Validation().passwordValidator(data!);
                          },
                        ),
                        CustomTextFormFaild(
                          labelText: 'تأكيد كلمة المرور',
                          icon: Icon(
                            Icons.lock_outline,
                            size: context.screenHeight * 0.04,
                          ),
                          onChange: (data) {},
                          validator: (data) {
                            return Validation().passwordValidator(data!);
                          },
                        ),
                        SizedBox(height: context.screenHeight * 0.02),
                        Align(
                          alignment: AlignmentGeometry.center,
                          child: CustomButtom(
                            tital: 'تأكيد',
                            onTap: () {
                              Get.offAllNamed(AppRoutes.LoginPage);
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
