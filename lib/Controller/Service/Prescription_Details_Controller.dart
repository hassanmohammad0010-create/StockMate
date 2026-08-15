// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Service/Pharmacy_Dispense_Controller.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Cancel_Prescription_Service.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Dispense_Prescription_Service.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Get_Prescription_Details_Service.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/models/Dispense_Queue_Item.dart';
import 'package:stock_mate_project/core/models/Prescription_Details_Model.dart';

class PrescriptionDetailsController extends GetxController {
  PrescriptionDetailsController({required this.queueItem});

  /// عنصر الطابور (للحصول على prescriptionId)
  final DispenseQueueItem queueItem;

  final GetPrescriptionDetailsService _detailsService =
      GetPrescriptionDetailsService();
  final DispensePrescriptionService _dispenseService =
      DispensePrescriptionService();
  final CancelPrescriptionService _cancelService = CancelPrescriptionService();

  // ─── Reactive state ───────────────────────────────────────────────
  final Rxn<PrescriptionDetails> details = Rxn<PrescriptionDetails>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isConfirming = false.obs;

  /// ✅ حالة إلغاء الوصفة
  final RxBool isCancelling = false.obs;

  /// ✅ الكمية التي سيصرفها الصيدلي "هذه المرة" لكل دواء
  final RxMap<String, int> dispensedQuantities = <String, int>{}.obs;

  /// ✅ حقل الملاحظات الاختياري
  final TextEditingController notesController = TextEditingController();

  /// ✅ حقل سبب الإلغاء (اجباري في الديالوغ)
  final TextEditingController cancelReasonController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchDetails();
  }

  @override
  void onClose() {
    notesController.dispose();
    cancelReasonController.dispose();
    super.onClose();
  }

  String get prescriptionId => queueItem.prescriptionId;

  // ─── جلب التفاصيل ─────────────────────────────────────────────────
  Future<void> fetchDetails() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _detailsService.getPrescriptionDetails(
        prescriptionId: prescriptionId,
      );

      if (result == null) {
        errorMessage.value = 'تعذر تحميل تفاصيل الوصفة';
      } else {
        details.value = result;
        _initQuantities(result);
        print('✅ تم جلب تفاصيل الوصفة: ${result.id}');
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ─── ✅ الكمية المتبقية = المطلوبة − المصروفة سابقاً ──────────────
  int remainingFor(PrescriptionItem item) {
    final remaining = item.prescribedQuantity - item.dispensedQuantity;
    return remaining < 0 ? 0 : remaining;
  }

  /// ✅ تهيئة الكميات: كل دواء يبدأ على الكمية المتبقية تلقائياً
  void _initQuantities(PrescriptionDetails d) {
    dispensedQuantities.clear();
    for (final item in d.items) {
      dispensedQuantities[item.id] = remainingFor(item);
    }
  }

  /// ✅ تحديث كمية دواء معين (يُستدعى من الـ stepper)
  void updateQuantity(String itemId, int value) {
    dispensedQuantities[itemId] = value;
  }

  /// ✅ الكمية المختارة لدواء (افتراضي = المتبقية)
  int quantityFor(PrescriptionItem item) =>
      dispensedQuantities[item.id] ?? remainingFor(item);

  // ─── حساب الحالة النهائية ─────────────────────────────────────────
  CycleStatus computeFinalStatus() {
    final d = details.value;
    if (d == null) return CycleStatus.partially_delivered;

    bool allFull = true;
    for (final item in d.items) {
      if (quantityFor(item) < remainingFor(item)) {
        allFull = false;
        break;
      }
    }
    return allFull ? CycleStatus.delivered : CycleStatus.partially_delivered;
  }

  /// ✅ هل صُرف شيء فعلاً؟ (لمنع التأكيد بكمية 0 للجميع)
  bool get hasAnyDispensed {
    final d = details.value;
    if (d == null) return false;
    return d.items.any((item) => quantityFor(item) > 0);
  }

  /// ✅ ملخص: سيُصرف الآن / المتبقي الكلي
  String get summaryText {
    final d = details.value;
    if (d == null) return '';
    int totalRemaining = 0;
    int totalChosen = 0;
    for (final item in d.items) {
      totalRemaining += remainingFor(item);
      totalChosen += quantityFor(item);
    }
    return '$totalChosen / $totalRemaining';
  }

  // ─── ترجمة رسائل الخطأ من الباك اند ──────────────────────────────
  String _translateError(String? msg) {
    if (msg == null || msg.isEmpty) {
      return 'تعذر تنفيذ العملية، حاول مرة أخرى';
    }
    if (msg.contains('Insufficient')) {
      return 'المخزون في الصيدلية غير كافٍ لهذه الكمية — قلّل الكمية المصروفة وحاول مجدداً';
    }
    if (msg.contains('not found')) {
      return 'الوصفة غير موجودة';
    }
    return msg;
  }

  // ─── تأكيد الصرف → POST /pharmacy/dispensing ─────────────────────
  Future<void> confirmDispense() async {
    if (isConfirming.value || !hasAnyDispensed) return;

    isConfirming.value = true;
    try {
      final d = details.value!;

      final items = d.items
          .where((item) => quantityFor(item) > 0)
          .map(
            (item) => DispenseItemInput(
              prescriptionItemId: item.id,
              quantity: quantityFor(item),
            ),
          )
          .toList();

      final success = await _dispenseService.dispense(
        prescriptionId: prescriptionId,
        items: items,
        notes: notesController.text.trim(),
      );

      if (success) {
        final finalStatus = computeFinalStatus();

        customSnackBar(
          title: 'تم الصرف',
          message: 'تم صرف الوصفة بنجاح (${finalStatus.label})',
          color: constGreen,
          messageColor: Colors.white,
        );

        if (Get.isRegistered<PharmacyDispenseController>(
          tag: 'newPrescriptions',
        )) {
          Get.find<PharmacyDispenseController>(tag: 'newPrescriptions')
              .removeFromList(queueItem.id);
        }

        if (Get.isRegistered<PharmacyDispenseController>(
          tag: 'processedPrescriptions',
        )) {
          Get.find<PharmacyDispenseController>(tag: 'processedPrescriptions')
              .fetchPrescriptions();
        }

        Get.back();
      } else {
        customSnackBar(
          title: 'فشل الصرف',
          message: _translateError(_dispenseService.lastError),
          color: constRed,
          messageColor: Colors.white,
        );
      }
    } finally {
      isConfirming.value = false;
    }
  }

  // ─── ✅✅✅ إلغاء الوصفة → POST /prescriptions/{id}/cancel ────────
  Future<void> cancelPrescription(String reason) async {
    if (isCancelling.value) return;

    isCancelling.value = true;
    try {
      final success = await _cancelService.cancelPrescription(
        prescriptionId: prescriptionId,
        reason: reason,
      );

      if (success) {
        customSnackBar(
          title: 'تم الإلغاء',
          message: 'تم إلغاء الوصفة بنجاح',
          color: constRed,
          messageColor: Colors.white,
        );

        // ✅ إزالة الوصفة من قائمة "جاهز للصرف"
        if (Get.isRegistered<PharmacyDispenseController>(
          tag: 'newPrescriptions',
        )) {
          Get.find<PharmacyDispenseController>(tag: 'newPrescriptions')
              .removeFromList(queueItem.id);
        }

        // ✅ تحديث قائمة "المصروفة"
        if (Get.isRegistered<PharmacyDispenseController>(
          tag: 'processedPrescriptions',
        )) {
          Get.find<PharmacyDispenseController>(tag: 'processedPrescriptions')
              .fetchPrescriptions();
        }

        // ✅ العودة لقائمة الوصفات
        Get.back();
      } else {
        customSnackBar(
          title: 'فشل الإلغاء',
          message: _translateError(_cancelService.lastError),
          color: constRed,
          messageColor: Colors.white,
        );
      }
    } finally {
      isCancelling.value = false;
    }
  }
}