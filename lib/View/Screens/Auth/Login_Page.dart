import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Function/Shared/Validation.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Department-Heads_Main_Page.dart';
import 'package:stock_mate_project/View/Screens/Auth/Enter_Account_Page.dart';
import 'package:stock_mate_project/View/Widget/Auth/Custom_Circle.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Text_Failed.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Drop_Down_Buttom.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final String pageName = '/ReceptionPage';
  final GlobalKey<FormState> loginPageKey = GlobalKey();
  @override
  Widget build(context) {
    return Scaffold(
      body: Form(
        key: loginPageKey,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
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
                  top: MediaQuery.of(context).size.height * 0.24,
                  right: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اهلا بك !  ',
                      style: TextStyle(
                        color: constColor,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        fontFamily: lateef,
                      ),
                    ),
                    Text(
                      'الرجاء اكمال المعلومات لتسجيل الدخول',
                      style: TextStyle(
                        color: constGray,
                        fontSize: 25,
                        fontFamily: lateef,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedAlign(
                duration: Duration(milliseconds: 300),
                alignment: MediaQuery.of(context).viewInsets.bottom > 0
                    ? Alignment(0, -0.5)
                    : Alignment(0, -1.2),
                child: CustomCircle(
                  xAlignment: 0,
                  yAlignment: 4.5,
                  size: 1.88,
                  color: constColor,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 3 / 2,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.07,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontFamily: lateef,
                            ),
                          ),
                          SizedBox(height: 16),

                          CustomDropDown(
                            itemList: specialties,
                            hintText: 'الهوية',
                            icon: Icon(Icons.person_2_outlined, size: 32),
                            onChanched: (data) {},
                          ),

                          CustomTextFormFaild(
                            labelText: 'البريد الالكتروني',
                            icon: Icon(Icons.email_outlined, size: 32),
                            onChange: (data) {},
                            validator: (data) =>
                                Validation().emailValidate(data!),
                          ),

                          CustomTextFormFaild(
                            labelText: 'كلمة المرور',
                            icon: Icon(Icons.lock_outline, size: 32),
                            onChange: (data) {},
                            validator: (data) =>
                                Validation().passwordValidator(data!),
                          ),

                          SizedBox(height: 32),
                          CustomButtom(
                            tital: 'تسجيل الدخول',
                            onTap: () {
                              if (loginPageKey.currentState!.validate()) {}
                              // Get.offNamed(MainPage().pageName);
                              Get.offNamed(DepartmentHeadsMainPage().pageName);
                            },
                          ),

                          SizedBox(height: 8),
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
                                    fontSize: 24,
                                    fontFamily: lateef,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
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
                                    fontSize: 24,
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
