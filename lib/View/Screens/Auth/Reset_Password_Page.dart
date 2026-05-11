import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Function/Shared/Validation.dart';
import 'package:stock_mate_project/View/Screens/Auth/Enter_OTB_Page.dart';
import 'package:stock_mate_project/View/Widget/Auth/Custom_Circle.dart';
import 'package:stock_mate_project/View/Widget/Shared_Widget/Custom_Buttom.dart';
import 'package:stock_mate_project/View/Widget/Shared_Widget/Custom_Text_Failed.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage({super.key});
  final String pageName = '/ResetPasswordPage';
  final GlobalKey<FormState> resetPasswordPageKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: resetPasswordPageKey,
        child: Stack(
          children: [
            Image.asset('assets/Image/Reset_Password.png'),
            CustomCircle(
              xAlignment: 0,
              yAlignment: 4,
              size: 1.75,
              color: constColor,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 3 / 2,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.03,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'اعادة تعيين كلمة المرور',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: lateef,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Text(
                          'الرجاء ادخال كلمة المرور الجديدة ',
                          style: TextStyle(
                            color: constGray,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: lateef,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      CustomTextFormFaild(
                        labelText: 'كلمة المرور',
                        icon: Icon(Icons.lock_outline, size: 32),
                        onChange: (data) {},
                        validator: (data) {
                          return Validation().passwordValidator(data!);
                        },
                      ),
                      CustomTextFormFaild(
                        labelText: 'تأكيد كلمة المرور',
                        icon: Icon(Icons.lock_outline, size: 32),
                        onChange: (data) {},
                        validator: (data) {
                          return Validation().passwordValidator(data!);
                        },
                      ),
                      SizedBox(height: 32),
                      Align(
                        alignment: AlignmentGeometry.center,
                        child: CustomButtom(
                          tital: 'تأكيد',
                          onTap: () {
                            Get.toNamed(EnterOTBPage().pageName);
                          },
                        ),
                      ),
                    ],
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
