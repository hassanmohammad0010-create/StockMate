// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Logic/Cart_Controller.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';
import 'package:stock_mate_project/Constant/Const.dart';

/// أسباب حذف الكمية المتاحة للاختيار من القائمة.
const List<String> kBatchDeletionReasons = [
  'منتهية الصلاحية',
  'فاسدة',
  'مكسورة',
  'أخرى',
];

class BatchDeletionController extends GetxController {
  BatchDeletionController({
    required this.material,
    required this.batch,
  });

  final MaterialItem material;
  final MaterialBatch batch;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController quantityController = TextEditingController();

  /// السبب المختار من القائمة (أحد عناصر kBatchDeletionReasons).
  final Rxn<String> selectedReason = Rxn<String>();

  /// يظهر فقط عند اختيار "أخرى".
  final TextEditingController otherReasonController = TextEditingController();

  /// لعرض رسالة خطأ تحت الـ Dropdown عند عدم اختيار سبب.
  final RxBool reasonError = false.obs;

  bool get isOtherSelected => selectedReason.value == 'أخرى';

  void selectReason(String? value) {
    selectedReason.value = value;
    if (value != null) reasonError.value = false;
    if (value != 'أخرى') otherReasonController.clear();
  }

  String _fmt(int n) => n.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );

  String get dateStr {
    final d = batch.expiryDate;
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  String get formattedBatchQuantity => _fmt(batch.quantity);

  void confirmDeletion() {
    final isFormValid = formKey.currentState?.validate() ?? false;

    if (selectedReason.value == null) {
      reasonError.value = true;
    }

    if (!isFormValid || selectedReason.value == null) return;

    final quantity = int.parse(quantityController.text.trim());
    final reason = isOtherSelected
        ? otherReasonController.text.trim()
        : selectedReason.value!;

    final error = CartController.to.requestBatchDeletion(
      item: material,
      batch: batch,
      quantity: quantity,
      reason: reason,
    );

    if (error != null) {
      customSnackBar(
        title: 'تنبيه',
        message: error,
        color: constRed,
        messageColor: Colors.white,
      );
      return;
    }

    customSnackBar(
      title: 'تم إرسال الطلب',
      message: 'تم تسجيل طلب حذف $quantity من ${material.name}.',
      color: constGreen,
      messageColor: Colors.white,
    );

    Get.back();
  }

  @override
  void onClose() {
    quantityController.dispose();
    otherReasonController.dispose();
    super.onClose();
  }
}