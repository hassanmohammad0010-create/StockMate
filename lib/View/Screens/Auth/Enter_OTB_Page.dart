import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Auth/Enter_OTB_Controller.dart';
import 'package:stock_mate_project/Service/Auth/OTB_Service.dart';
import 'package:stock_mate_project/View/Screens/App/Main_Page.dart';
import 'package:stock_mate_project/View/Widget/Auth/Custom_Circle.dart';
import 'package:stock_mate_project/View/Widget/Auth/Custom_OTB.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

class EnterOTBPage extends StatelessWidget {
  const EnterOTBPage({super.key, required this.email});
  final String pageName = '/EnterOTBPage';
  final String email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EnterOTBController(email: email));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(width: double.infinity, height: 50, color: constLightBlue),
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
            // child: Image.asset('assets/Image/OTB.png'),
            size: 0.9,
          ),
          CustomCircle(
            xAlignment: 0,
            yAlignment: -1.2,
            size: 1.2,
            color: constLightBlue,
            child: Image.asset('assets/Image/OTB.png'),
          ),
          Positioned(
            top: 460,
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
                          fontSize: context.screenHeight * 0.028,
                          color: constColor,
                          fontFamily: cairo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: context.screenHeight * 0.01),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.screenWidth * 0.06,
                      ),
                      child: Text(
                        'قمنا بأرسال رمز التأكيد على الحساب المدخل الرجاء تفقد الحساب وادخال الرمز',
                        style: TextStyle(
                          fontSize: context.screenHeight * 0.022,
                          color: constGray,

                          fontFamily: cairo,
                        ),
                      ),
                    ),
                    SizedBox(height: context.screenHeight * 0.04),
                    CustomOtb(
                      onSubmit: (data) async {
                        bool response = await OtpService.verifyOtp(
                          email: email,
                          code: data,
                        );
                        if (response) {
                          Get.to(() => MainPage());
                        }
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
                              color: constColor,
                              fontFamily: lateef,
                            ),
                          ),
                          GestureDetector(
                            onTap: seconds == 0 && !isLoading
                                ? controller.resendCode
                                : null,
                            child: isLoading
                                ? SizedBox(
                                    height: context.screenHeight * 0.03,
                                    width: context.screenHeight * 0.03,
                                    child: CustomLoadingIndicator(
                                      size: context.screenHeight * 0.03,
                                    ), // بدل CircularProgressIndicator
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
        ],
      ),
    );
  }
}
