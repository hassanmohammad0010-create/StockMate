// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Cart_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  final String pageName = '/CartPage';

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          CustomBackContainer(),
          SizedBox(height: h * 0.01),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                child: Column(
                  children: [
                    CustomHeadContainer(title: 'السلة اليومية'),
                    SizedBox(height: h * 0.01),
                    CustomCartContainer(
                      buttonText: 'ارجاع الى المخزون',
                      title: 'باراسيتامول 500 مجم',
                      subtitle: '50',
                      buttonColor: constLightRed,
                      buttonTextColor: constRed,
                    ),
                    CustomCartContainer(
                      buttonText: 'ارجاع الى المخزون',
                      title: 'أموكسيسيلين 250 مجم',
                      subtitle: '30',
                      buttonColor: constLightRed,
                      buttonTextColor: constRed,
                    ),
                    CustomCartContainer(
                      buttonText: 'ارجاع الى المخزون',
                      title: 'إيبوبروفين 200 مجم',
                      subtitle: '40',
                      buttonColor: constLightRed,
                      buttonTextColor: constRed,
                    ),
                    CustomCartContainer(
                      buttonText: 'ارجاع الى المخزون',
                      title: 'سيتالوبين 10 مجم',
                      subtitle: '20',
                      buttonColor: constLightRed,
                      buttonTextColor: constRed,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.05,
              vertical: h * 0.01,
            ),
            child: Divider(),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: h * 0.02),
            child: CustomMainButtom(
              title: 'تأكيد السلة اليومية',
              color: constBlue,
              fontcolor: Colors.white,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
