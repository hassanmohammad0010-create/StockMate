import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Auth/Enter_OTB_Controller.dart';
import 'package:stock_mate_project/View/Widget/Auth/Custom_Circle.dart';
import 'package:stock_mate_project/View/Widget/Auth/Custom_OTB.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';

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
    final controller = Get.put(EnterOTBController(email: email));

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
              0,
              // -context.keyboard + context.screenHeight * 0.09,
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
                              ? Get.offAllNamed(AppRoutes.MainPage)
                              : Get.toNamed(AppRoutes.ResetPasswordPage);
                        },
                      ),
                      SizedBox(height: context.screenHeight * 0.03),
                      Obx(() {
                        final seconds = controller.secondsRemaining.value;
                        final isLoading = controller.isLoading.value;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'الم يصلك رمز التحقق؟ ',
                              style: TextStyle(
                                fontSize: context.screenHeight * 0.026,
                                color: Colors.white,
                                fontFamily: lateef,
                              ),
                            ),
                            GestureDetector(
                              onTap: seconds == 0 && !isLoading
                                  ? controller.resendCode
                                  : null,
                              child: isLoading
                                  ? SizedBox(
                                      height: context.screenHeight * 0.02,
                                      width: context.screenHeight * 0.02,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              constBlue,
                                            ),
                                      ),
                                    )
                                  : Text(
                                      seconds > 0
                                          ? 'إعادة إرسال ($seconds ث)'
                                          : 'إعادة إرسال',
                                      style: TextStyle(
                                        fontSize: context.screenHeight * 0.026,
                                        color: seconds > 0
                                            ? constGray
                                            : constBlue,
                                        fontFamily: lateef,
                                        fontWeight: FontWeight.bold,
                                        decoration: seconds > 0
                                            ? TextDecoration.none
                                            : TextDecoration.underline,
                                      ),
                                    ),
                            ),
                          ],
                        );
                      }),
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
