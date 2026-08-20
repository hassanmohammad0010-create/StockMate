// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Confirm_Delivery_Service.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Get_Refill_Delivery_Details_Service.dart';
import 'package:stock_mate_project/Controller/Service/Refill_Deliveries_Controller.dart';
import 'package:stock_mate_project/core/models/Refill_Delivery_Details_Model.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';

class RefillDeliveryDetailsController extends GetxController {
  RefillDeliveryDetailsController({required this.deliveryId});

  final String deliveryId;

  final GetRefillDeliveryDetailsService _detailsService =
      GetRefillDeliveryDetailsService();
  final ConfirmDeliveryService _confirmService = ConfirmDeliveryService();

  // ─── Reactive state ───────────────────────────────────────────────
  final Rxn<RefillDeliveryDetails> details = Rxn<RefillDeliveryDetails>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // ─── ✅✅✅ حالة تأكيد الاستلام ───────────────────────────────────
  /// الكمية المستلمة لكل صنف (تبدأ = الكمية المرسلة تلقائياً)
  final RxMap<String, int> receivedQuantities = <String, int>{}.obs;

  /// حقل الملاحظات الاختياري
  final TextEditingController notesController = TextEditingController();

  /// حالة الإرسال
  final RxBool isConfirming = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDetails();
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }

  // ─── جلب التفاصيل ─────────────────────────────────────────────────
  Future<void> fetchDetails() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _detailsService.getDeliveryDetails(
        deliveryId: deliveryId,
      );

      if (result == null) {
        errorMessage.value = 'تعذر تحميل تفاصيل التسليم';
      } else {
        details.value = result;
        _initQuantities(result);
        print('✅ تم جلب تفاصيل التسليم: ${result.id}');
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ تهيئة الكميات المستلمة = الكميات المرسلة تلقائياً
  void _initQuantities(RefillDeliveryDetails d) {
    receivedQuantities.clear();
    for (final item in d.items) {
      receivedQuantities[item.id] = item.shippedQuantity;
    }
  }

  /// ✅ تحديث كمية مستلمة (من الـ stepper في الديالوغ)
  void updateReceivedQuantity(String itemId, int value) {
    receivedQuantities[itemId] = value;
  }

  /// ✅ الكمية المستلمة المختارة لصنف (افتراضي = المرسلة)
  int quantityFor(DeliveryItem item) =>
      receivedQuantities[item.id] ?? item.shippedQuantity;

  /// ✅ هل تم تأكيد هذا التسليم مسبقاً؟
  bool get isConfirmed => details.value?.confirmedAt != null;

  // ─── ✅✅✅ تأكيد الاستلام → POST .../confirm ─────────────────────
  Future<void> confirmReceipt() async {
    if (isConfirming.value) return;

    final d = details.value;
    if (d == null || d.items.isEmpty) return;

    isConfirming.value = true;
    try {
      // ✅ بناء العناصر: deliveryItemId + receivedQuantity
      final items = d.items
          .map(
            (item) => ConfirmDeliveryItemInput(
              deliveryItemId: item.id,
              receivedQuantity: quantityFor(item),
            ),
          )
          .toList();

      final success = await _confirmService.confirmDelivery(
        deliveryId: deliveryId,
        items: items,
        notes: notesController.text.trim(),
      );

      if (success) {
        // ✅ 1) إغلاق الديالوغ
        Get.back();

        // ✅ 2) snackbar النجاح
        customSnackBar(
          title: 'تم التأكيد',
          message: 'تم تأكيد استلام التسليم بنجاح',
          color: constGreen,
          messageColor: Colors.white,
        );

        // ✅ 3) تحديث قائمة التسليمات
        if (Get.isRegistered<RefillDeliveriesController>(tag: 'deliveries')) {
          Get.find<RefillDeliveriesController>(tag: 'deliveries')
              .fetchDeliveries();
        }

        // ✅ 4) العودة لقائمة التسليمات
        await Future.delayed(const Duration(milliseconds: 250));
        Get.back();
      } else {
        // ❌ فشل → البقاء في الديالوغ مع رسالة خطأ
        customSnackBar(
          title: 'فشل التأكيد',
          message: _translateError(_confirmService.lastError),
          color: constRed,
          messageColor: Colors.white,
        );
      }
    } finally {
      isConfirming.value = false;
    }
  }

  String _translateError(String? msg) {
    if (msg == null || msg.isEmpty) {
      return 'تعذر تأكيد الاستلام، حاول مرة أخرى';
    }
    if (msg.contains('not found')) {
      return 'التسليم غير موجود';
    }
    if (msg.contains('already')) {
      return 'تم تأكيد هذا التسليم مسبقاً';
    }
    return msg;
  }
}