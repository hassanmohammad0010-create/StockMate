// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Get_Medicine_List_Variants_Service.dart';
import 'package:stock_mate_project/core/models/Medicine_List_Variant.dart';
import 'package:stock_mate_project/core/models/Prescription_Model.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';

/// ✅ كونترولر مُشترك بين صفحة التفاصيل وصفحة الوصفات
class SendPrescriptionController extends GetxController {
  final GetMedicineVariantsService _variantsService =
      GetMedicineVariantsService();

  // ─── قائمة الوصفات الحالية ────────────────────────────────────────
  final RxList<Prescription> prescriptions = <Prescription>[].obs;

  // ─── قائمة الأدوية المتاحة (من السيرفر) ──────────────────────────
  final RxList<MedicineVariant> availableVariants = <MedicineVariant>[].obs;
  final RxBool isLoadingVariants = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVariants();
  }

  // ─── جلب قائمة الأدوية ──────────────────────────────────────────
  Future<void> fetchVariants() async {
    if (isLoadingVariants.value) return;
    isLoadingVariants.value = true;

    try {
      final variants = await _variantsService.getVariants(limit: 100);
      availableVariants.assignAll(variants);
      print('✅ تم جلب ${variants.length} دواء');
    } finally {
      isLoadingVariants.value = false;
    }
  }

  // ─── أسماء الأدوية للدروب داون ──────────────────────────────────
  List<String> get variantNames =>
      availableVariants.map((v) => v.variantName).toList();

  // ─── إدارة الوصفات ──────────────────────────────────────────────

  /// إضافة وصفة جديدة فارغة
  void addPrescription() {
    prescriptions.add(Prescription.empty());
  }

  /// حذف وصفة
  void removePrescription(String localId) {
    prescriptions.removeWhere((p) => p.localId == localId);
  }

  /// تحديث وصفة
  void updatePrescription(String localId, Prescription updated) {
    final i = prescriptions.indexWhere((p) => p.localId == localId);
    if (i != -1) {
      prescriptions[i] = updated;
      prescriptions.refresh();
    }
  }

  // ─── إدارة الأدوية داخل وصفة ────────────────────────────────────

  /// إضافة دواء لوصفة معينة
  void addMedicineToPrescription({
    required String prescriptionId,
    required String variantName,
  }) {
    final variant = availableVariants.firstWhereOrNull(
      (v) => v.variantName == variantName,
    );
    if (variant == null) {
      customSnackBar(
        title: 'خطأ',
        message: 'لم يتم العثور على الدواء',
        color: constRed,
        messageColor: Colors.white,
      );
      return;
    }

    final pi = prescriptions.indexWhere((p) => p.localId == prescriptionId);
    if (pi == -1) return;

    final newItem = PrescriptionItem.empty(
      variantId: variant.id,
      displayName: variant.variantName,
    );
    final updatedItems = [...prescriptions[pi].items, newItem];
    prescriptions[pi] = prescriptions[pi].copyWith(items: updatedItems);
    prescriptions.refresh();
  }

  /// حذف دواء من وصفة
  void removeMedicineFromPrescription({
    required String prescriptionId,
    required String itemLocalId,
  }) {
    final pi = prescriptions.indexWhere((p) => p.localId == prescriptionId);
    if (pi == -1) return;

    final updatedItems = prescriptions[pi]
        .items
        .where((item) => item.localId != itemLocalId)
        .toList();
    prescriptions[pi] = prescriptions[pi].copyWith(items: updatedItems);
    prescriptions.refresh();
  }

  /// تحديث دواء داخل وصفة
  void updateMedicineInPrescription({
    required String prescriptionId,
    required String itemLocalId,
    int? prescribedQuantity,
    String? dosage,
    String? frequency,
    int? durationDays,
  }) {
    final pi = prescriptions.indexWhere((p) => p.localId == prescriptionId);
    if (pi == -1) return;

    final items = prescriptions[pi].items.map((item) {
      if (item.localId == itemLocalId) {
        return item.copyWith(
          prescribedQuantity: prescribedQuantity,
          dosage: dosage,
          frequency: frequency,
          durationDays: durationDays,
        );
      }
      return item;
    }).toList();

    prescriptions[pi] = prescriptions[pi].copyWith(items: items);
    prescriptions.refresh();
  }

  // ─── helpers ──────────────────────────────────────────────────────

  bool get hasPrescriptions => prescriptions.isNotEmpty;

  void clearAll() => prescriptions.clear();
}