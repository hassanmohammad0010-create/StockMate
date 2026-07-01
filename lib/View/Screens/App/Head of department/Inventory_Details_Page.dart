// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Material_Info_Controller.dart';
import 'package:stock_mate_project/Controller/Logic/Cart_Controller.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/Custom_Dialog.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/DialogType.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Inventory_Quantity_Card.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Inventory_Batches_Card.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Inventory_Info_Card.dart';

class InventoryDetailsPage extends GetView<MaterialInfoController> {
  const InventoryDetailsPage({super.key, required this.item});

  final MaterialItem item;

  @override
  Widget build(BuildContext context) {
    // ✅ Guard احتياطي (زي ما عملنا في الصفحة السابقة)
    // بيضمن اشتغال الصفحة حتى لو الـ Binding ما اتمررش وقت التنقل
    if (!Get.isRegistered<MaterialInfoController>()) {
      Get.put(MaterialInfoController());
    }

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          const CustomBackContainer(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InventoryInfoCard(item: item),
                  InventoryQuantityCard(item: item),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      context.screenWidth * 0.02,
                      context.screenHeight * 0.01,
                      context.screenWidth * 0.02,
                      context.screenHeight * 0.02,
                    ),
                    child: InventoryBatchesCard(
                      item: item,
                      controller: controller,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _AddToCartButton(item: item, controller: controller),
          SizedBox(height: context.screenHeight * 0.02),
        ],
      ),
    );
  }
}

class _AddToCartButton extends StatelessWidget {
  const _AddToCartButton({required this.item, required this.controller});

  final MaterialItem item;
  final MaterialInfoController controller;

  @override
  Widget build(BuildContext context) {
    return CustomMainButtom(
      title: 'اضافة الى السلة',
      color: constBlue,
      fontcolor: Colors.white,
      onPressed: () {
        controller.quantityController.clear();
        CustomDialog.show(
          type: DialogType.info,
          title: 'اضافة الى السلة',
          message: 'هل أنت متأكد من إضافة هذا العنصر الى السلة؟',
          showTextField: true,
          textFieldHint: 'الكمية المراد اضافتها (افتراضياً 1)',
          textFieldKeyboard: TextInputType.number,
          textFieldController: controller.quantityController,
          confirmText: 'اضافة',
          textFieldValidator: (value) {
            if (value == null || value.trim().isEmpty) return null;
            final n = int.tryParse(value.trim());
            if (n == null) return 'يرجى ادخال رقم صحيح';
            if (n <= 0) return 'الكمية يجب ان تكون اكبر من صفر';
            final available = item.batches
                .where((b) => b.status != BatchStatus.expired)
                .fold(0, (sum, b) => sum + b.quantity);
            if (n > available) {
              return 'الكمية المتوفرة غير كافية (المتوفر: $available)';
            }
            return null;
          },
          onConfirm: () {
            final raw = controller.quantityController.text.trim();
            final int quantity = raw.isEmpty ? 1 : int.parse(raw);
            final error = CartController.to.addToCart(item, quantity);
            Get.back();
            CustomDialog.show(
              type: error == null ? DialogType.success : DialogType.danger,
              title: error == null ? 'تمت الإضافة' : 'تنبيه',
              message:
                  error ?? 'تمت إضافة $quantity من ${item.name} الى السلة.',
              showCancel: false,
            );
          },
        );
      },
    );
  }
}