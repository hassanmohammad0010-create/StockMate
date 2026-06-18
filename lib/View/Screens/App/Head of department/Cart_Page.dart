// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Cart_Controller.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Cart_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final cartController = CartController.to;

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          CustomBackContainer(),
          SizedBox(height: h * 0.01),
          CustomHeadContainer(title: 'السلة اليومية'),
          Expanded(
            child: Obx(() {
              if (cartController.cartItems.isEmpty) {
                return Center(
                  child: Text(
                    'السلة فارغة',
                    style: TextStyle(fontFamily: cairo, color: Colors.grey),
                  ),
                );
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                  child: Column(
                    children: [
                      SizedBox(height: h * 0.01),
                      ...cartController.cartItems.map(
                        (cartItem) => CustomCartContainer(
                          key: ValueKey(cartItem.id),
                          title: cartItem.materialName,
                          subtitle: '${cartItem.quantity}',
                          buttonText: 'ارجاع الى المخزون',
                          buttonColor: constLightRed,
                          buttonTextColor: constRed,
                          maxReturnQuantity: cartItem.quantity,
                          onReturnConfirm: (returnQty) {
                            cartController.returnToStock(cartItem, returnQty);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.01),
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