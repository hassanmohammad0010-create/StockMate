// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Auth/Enter_OTB_Controller.dart';
import 'package:stock_mate_project/Controller/Loading%20Indecator%20Controller/Loading_Indicator_Controller.dart';
import 'package:stock_mate_project/Service/Auth/OTB_Service.dart';
import 'package:stock_mate_project/Service/Token_Storage.dart';
import 'package:stock_mate_project/View/Screens/App/Doctor/Doctor_Main_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20Purchasing%20committee/Main_Page_Heap_of_Purchasing.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Department-Heads_Main_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Main_Page.dart';
import 'package:stock_mate_project/View/Widget/Auth/Custom_Circle.dart';
import 'package:stock_mate_project/View/Widget/Auth/Custom_OTB.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

class EnterOTBPage extends StatelessWidget {
  EnterOTBPage({super.key, required this.email});
  final String pageName = '/EnterOTBPage';
  final String email;

  // ارتفاع التصميم المرجعي اللي اتبنت عليه القيمة الثابتة الأصلية (top: 460)
  static const double _designHeight = 800;
  LoadingIndicatorController loadingIndicatorController = Get.put(
    LoadingIndicatorController(),
  );
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EnterOTBController(email: email));
    final double scale = context.screenHeight / _designHeight;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: constBackgroundColor,
        // خليها true عشان الشاشة تتفاعل مع الكيبورد
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: context.screenHeight,
            width: context.screenWidth,
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
                  top: 420 * scale,
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
                          GetBuilder<LoadingIndicatorController>(
                            builder: (loadingIndicatorController) {
                              return Column(
                                children: [
                                  CustomOtb(
                                    onSubmit: (data) async {
                                      loadingIndicatorController.isLoad();
                                      bool response =
                                          await OtpService.verifyOtp(
                                            email: email,
                                            code: data,
                                          );
                                      loadingIndicatorController.isntLoad();
                                      if (response) {
                                        String? role =
                                            await TokenStorage.getUserRole();
                                        if (role != null) {
                                          String? role =
                                              await TokenStorage.getUserRole();
                                          if (role != null) {
                                            role == 'department_manager' ||
                                                    role == 'pharmacy_staff'
                                                ? Get.offAll(
                                                    () =>
                                                        DepartmentHeadsMainPage(),
                                                  )
                                                : role == 'purchasing_manager'
                                                ? Get.offAll(
                                                    () =>
                                                        MainPageHeadOfPurchasingPage(),
                                                  )
                                                : role == 'hospital_manager'
                                                ? Get.offAll(() => MainPage())
                                                : role == 'doctor'
                                                ? Get.offAll(
                                                    () => DoctorMainPage(),
                                                  )
                                                : Get.offAll(() => MainPage());
                                          } else {
                                            customSnackBar(
                                              title: 'حدث خطأ ',
                                              message:
                                                  'الرجاء تسجيل الدخول مجددا',
                                              color: constRed,
                                              messageColor: constLightRed,
                                            );
                                          }
                                        } else {
                                          customSnackBar(
                                            title: 'حدث خطأ ',
                                            message:
                                                'الرجاء تسجيل الدخول مجددا',
                                            color: constRed,
                                            messageColor: constLightRed,
                                          );
                                        }
                                      }
                                    },
                                  ),
                                  SizedBox(height: context.screenHeight * 0.03),
                                  Obx(() {
                                    final seconds =
                                        controller.secondsRemaining.value;
                                    final isLoading =
                                        controller.isLoading.value;

                                    return loadingIndicatorController.load
                                        ? CustomLoadingIndicator()
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'الم يصلك رمز التحقق؟ ',
                                                style: TextStyle(
                                                  fontSize:
                                                      context.screenHeight *
                                                      0.026,
                                                  color: constColor,
                                                  fontFamily: lateef,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap:
                                                    seconds == 0 && !isLoading
                                                    ? controller.resendCode
                                                    : null,
                                                child: isLoading
                                                    ? SizedBox(
                                                        height:
                                                            context
                                                                .screenHeight *
                                                            0.03,
                                                        width:
                                                            context
                                                                .screenHeight *
                                                            0.03,
                                                        child: CustomLoadingIndicator(
                                                          size:
                                                              context
                                                                  .screenHeight *
                                                              0.03,
                                                        ),
                                                      )
                                                    : Text(
                                                        seconds > 0
                                                            ? 'إعادة إرسال ($seconds ث)'
                                                            : 'إعادة إرسال',
                                                        style: TextStyle(
                                                          fontSize:
                                                              context
                                                                  .screenHeight *
                                                              0.026,
                                                          color: seconds > 0
                                                              ? constGray
                                                              : constBlue,
                                                          fontFamily: lateef,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          decoration:
                                                              seconds > 0
                                                              ? TextDecoration
                                                                    .none
                                                              : TextDecoration
                                                                    .underline,
                                                        ),
                                                      ),
                                              ),
                                            ],
                                          );
                                  }),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
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
