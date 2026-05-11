import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/View/Widget/Auth/Custom_Circle.dart';
import 'package:stock_mate_project/View/Widget/Auth/Custom_OTB.dart';

class EnterOTBPage extends StatelessWidget {
  const EnterOTBPage({super.key});
  final String pageName = '/EnterOTBPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/Image/OTB.png'),
          CustomCircle(
            xAlignment: 0,
            yAlignment: 4.5,
            size: 1.75,
            color: constColor,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 3 / 2,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'تأكيد البريد الالكتروني',
                        style: TextStyle(
                          fontSize: 36,
                          color: Colors.white,
                          fontFamily: lateef,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'قمنا بأرسال رمز التأكيد على الحساب المدخل الرجاء تفقد الحساب وادخال الرمز',
                        style: TextStyle(
                          fontSize: 28,
                          color: constGray,
                          fontFamily: lateef,
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    CustomOtb(onSubmit: (data) {}),
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
