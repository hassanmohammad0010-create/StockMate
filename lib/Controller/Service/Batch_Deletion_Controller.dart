// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Service/Get_Name_Roll_Of_User.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/PostInventory_Adjustment_Service.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/models/New_MaterialItem.dart';

/// كونترولر إتلاف/تسوية كمية من دفعة معينة
/// يُرسل POST /inventory/adjustments مباشرة للباك اند
class BatchDeletionController extends GetxController {
  BatchDeletionController({required this.material, required this.batch});

  final MaterialItem material;
  final MaterialBatch batch;

  final PostInventoryAdjustmentService _adjustmentService =
      PostInventoryAdjustmentService();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController quantityController = TextEditingController();

  /// حقل الملاحظات
  final TextEditingController notesController = TextEditingController();

  // ─── ✅ أنواع التسوية: عربي للعرض ───────────────────────────────
  static const List<String> adjustmentReasonsArabic = [
    'تالف',
    'منتهي الصلاحية',
    'نقص / فقد',
    'زيادة مخزنية',
  ];

  /// ✅ الخريطة: عربي (عرض) → إنكليزي (إرسال)
  static const Map<String, String> _arabicToApi = {
    'تالف': 'damaged',
    'منتهي الصلاحية': 'expired',
    'نقص / فقد': 'shrinkage',
    'زيادة مخزنية': 'found',
  };

  /// القيمة المختارة (بالعربي — للعرض)
  final RxString selectedReason = ''.obs;

  /// خطأ عدم اختيار النوع
  final RxBool reasonError = false.obs;

  /// حالة الإرسال
  final RxBool isSubmitting = false.obs;

  /// ✅ القيمة التي ستُرسل للباك اند (بالإنكليزي)
  String? get selectedReasonApi => _arabicToApi[selectedReason.value];

  void selectReason(String? value) {
    selectedReason.value = value ?? '';
    reasonError.value = false;
  }

  // ─── Helpers للعرض ───────────────────────────────────────────────
  String get formattedBatchQuantity => batch.quantity.toString();

  String get dateStr {
    final d = batch.expiryDate;
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year}';
  }

  @override
  void onClose() {
    quantityController.dispose();
    notesController.dispose();
    super.onClose();
  }

  // ─── ✅✅✅ تأكيد الإتلاف → POST /inventory/adjustments ──────────
  Future<void> confirmDeletion() async {
    if (isSubmitting.value) return;

    if (!(formKey.currentState?.validate() ?? false)) return;

    if (selectedReason.value.isEmpty) {
      reasonError.value = true;
      return;
    }

    final quantity = int.tryParse(quantityController.text.trim()) ?? 0;
    final adjustmentType = selectedReasonApi;
    if (adjustmentType == null || quantity <= 0) {
      reasonError.value = true;
      return;
    }

    isSubmitting.value = true;
    try {
      final success = await _adjustmentService.createAdjustment(
        variantId: material.variantId,
        departmentId: Get.find<GetNameRollOfUserController>().id.value ?? '',
        batchId: batch.batchId,
        adjustmentType: adjustmentType,
        quantity: quantity,
        notes: notesController.text.trim(),
      );

      // ✅✅✅ إنهاء حالة التحميل قبل أي تنقل
      isSubmitting.value = false;

      if (success) {
        // ✅✅✅ 1) العودة للصفحة السابقة أولاً
        Get.back();

        // ✅✅✅ 2) ثم إظهار snackbar النجاح فوق الصفحة السابقة
        customSnackBar(
          title: 'تم الإتلاف',
          message:
              'تم تسجيل ${selectedReason.value} لكمية $quantity من ${material.name} بنجاح',
          color: constGreen,
          messageColor: Colors.white,
        );
      } else {
        // ❌ فشل → البقاء في الصفحة مع snackbar خطأ
        customSnackBar(
          title: 'فشل الإتلاف',
          message: _translateError(_adjustmentService.lastError),
          color: constRed,
          messageColor: Colors.white,
        );
      }
    } catch (e) {
      // ✅ حماية من أي خطأ غير متوقع
      isSubmitting.value = false;
      customSnackBar(
        title: 'خطأ',
        message: 'حدث خطأ غير متوقع، حاول مرة أخرى',
        color: constRed,
        messageColor: Colors.white,
      );
    }
  }

  // ─── ترجمة رسائل الخطأ ───────────────────────────────────────────
  String _translateError(String? msg) {
    if (msg == null || msg.isEmpty) {
      return 'تعذر تسجيل الإتلاف، حاول مرة أخرى';
    }
    if (msg.contains('not found')) {
      return 'الدفعة أو المادة غير موجودة';
    }
    if (msg.contains('exceed') || msg.contains('Insufficient')) {
      return 'الكمية المدخلة أكبر من المتوفر في الدفعة';
    }
    return msg;
  }
}
