import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Function/Shared/Validation.dart';
import 'package:stock_mate_project/View/Screens/Auth/Enter_OTB_Page.dart';
import 'package:stock_mate_project/View/Widget/Auth/Custom_Circle.dart';
import 'package:stock_mate_project/View/Widget/Shared_Widget/Custom_Buttom.dart';
import 'package:stock_mate_project/View/Widget/Shared_Widget/Custom_Text_Failed.dart';

class ConfirmAccountPage extends StatelessWidget {
  ConfirmAccountPage({super.key});
  final String pageName = '/ConfirmAccountPage';
  final GlobalKey<FormState> confirmAccountKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: confirmAccountKey,
        child: Stack(
          children: [
            Image.asset('assets/Image/Verify_Email.png'),
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
                    top: MediaQuery.of(context).size.height * 0.05,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'البريد الالكتروني',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: lateef,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'الرجاء ادخال البريد الالكتروني الخاص بك من اجل رمز التحقق',
                          style: TextStyle(
                            color: constGray,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: lateef,
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      CustomTextFormFaild(
                        labelText: 'البريد الالكتروني',
                        icon: Icon(Icons.email_outlined, size: 32),
                        onChange: (data) {},
                        validator: (data) {
                          return Validation().emailValidate(data!);
                        },
                      ),
                      SizedBox(height: 40),
                      Align(
                        alignment: AlignmentGeometry.center,
                        child: CustomButtom(
                          tital: 'تأكيد',
                          onTap: () {
                            if (confirmAccountKey.currentState!.validate()) {
                              Get.toNamed(EnterOTBPage().pageName);
                            }
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
