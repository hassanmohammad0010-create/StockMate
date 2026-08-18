// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Cart_Controller.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Cart_Container.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/Custom_Dialog.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/DialogType.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Text_Field/Custom_My_TextFormFaild.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    final cartController = CartController.to;

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          const CustomBackContainer(),
          SizedBox(height: h * 0.01),
          const CustomHeadContainer(title: 'السلة اليومية'),

          // ── قائمة السلة ──
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

          // ─── ✅✅✅ حقل الملاحظات الاختياري (نهاية الصفحة) ───
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.05),
            child: CustomMyTextFormField(
              prefixIcon: Icons.edit_note_outlined,
              label: 'ملاحظات (اختياري)',
              hint: 'أضف أي ملاحظات حول الاستهلاك اليومي',
              controller: cartController.notesController,
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.05,
              vertical: h * 0.01,
            ),
            child: const Divider(),
          ),

          // ── زر تأكيد السلة ──
          Padding(
            padding: EdgeInsets.only(bottom: h * 0.02),
            child: Obx(() {
              final isEmpty = cartController.cartItems.isEmpty;
              final confirming = cartController.isConfirming.value;

              return CustomMainButtom(
                title: confirming ? 'جارٍ التأكيد...' : 'تأكيد السلة اليومية',
                color: isEmpty || confirming ? constLightBlue : constBlue,
                fontcolor: isEmpty || confirming ? constBlue : Colors.white,
                onPressed: (isEmpty || confirming)
                    ? null
                    : () {
                        CustomDialog.show(
                          type: DialogType.warning,
                          title: 'تأكيد السلة',
                          message:
                              'هل أنت متأكد من تأكيد السلة اليومية؟\nسيتم تسجيل الاستهلاك في المخزون.',
                          confirmText: 'تأكيد',
                          onConfirm: () {
                            Get.back();
                            // ✅✅✅ استدعاء الإند بوينت الفعلي
                            cartController.confirmDailyCart();
                          },
                        );
                      },
              );
            }),
          ),
        ],
      ),
    );
  }
}
