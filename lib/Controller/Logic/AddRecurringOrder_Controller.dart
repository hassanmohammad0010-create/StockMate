// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';

class AddRecurringOrderController extends GetxController {

  // ─── Reactive state ───────────────────────────────────────────────────────
  final Rx<OrderModel>  order     = OrderModel().obs;
  final RxBool          isLoading = false.obs;

  // ─── TextEditingController للكمية + GlobalKey للـ Form ───────────────────
  final TextEditingController quantityController = TextEditingController();
  final GlobalKey<FormState>  formKey            = GlobalKey<FormState>();

  // ─── التكرار — القيمة الافتراضية: أسبوعي ─────────────────────────────────
  final RxString selectedRecurring = 'weekly'.obs;

  static const Map<String, String> recurringLabels = {
    'daily'  : 'يومي',
    'weekly' : 'أسبوعي',
    'monthly': 'شهري',
  };

  // ─── Reactive بالحقول الفارغة (لإظهار border أحمر على الـ dropdowns) ──────
  final RxSet<String> invalidFields = <String>{}.obs;

  @override
  void onClose() {
    quantityController.dispose();
    super.onClose();
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  bool isFieldInvalid(String field) => invalidFields.contains(field);

  void _markInvalid(String field) {
    invalidFields.add(field);
    invalidFields.refresh();
  }

  void _clearInvalid(String field) {
    invalidFields.remove(field);
    invalidFields.refresh();
  }

  // ─── التكرار ──────────────────────────────────────────────────────────────

  void selectRecurring(String value) {
    selectedRecurring.value = value;
  }

  // ─── Dropdown updates ─────────────────────────────────────────────────────

  void updateMedicineName(String? value) {
    order.value = order.value.copyWith(medicineName: value);
    if (value != null && value.isNotEmpty) {
      _clearInvalid('medicineName');
    } else {
      _markInvalid('medicineName');
    }
    order.refresh();
  }

  void updateUnit(String? value) {
    order.value = order.value.copyWith(unit: value);
    if (value != null && value.isNotEmpty) {
      _clearInvalid('unit');
    } else {
      _markInvalid('unit');
    }
    order.refresh();
  }

  void updateBrand(String? value) {
    order.value = order.value.copyWith(brand: value);
    if (value != null && value.isNotEmpty) {
      _clearInvalid('brand');
    } else {
      _markInvalid('brand');
    }
    order.refresh();
  }

  // ─── Sync: quantity ↔ model ───────────────────────────────────────────────

  void _saveQuantity() {
    final qty = quantityController.text;
    order.value = order.value.copyWith(quantity: qty);
    if (qty.trim().isNotEmpty) {
      _clearInvalid('quantity');
    } else {
      _markInvalid('quantity');
    }
  }

  // ─── Submission ───────────────────────────────────────────────────────────

  Future<void> submitOrder() async {
    _saveQuantity();

    final isFormValid = formKey.currentState?.validate() ?? false;

    // validate الـ Dropdowns يدوياً
    final o = order.value;
    bool dropsValid = true;

    if (o.medicineName == null || o.medicineName!.trim().isEmpty) {
      _markInvalid('medicineName');
      dropsValid = false;
    }
    if (o.unit == null || o.unit!.trim().isEmpty) {
      _markInvalid('unit');
      dropsValid = false;
    }
    if (o.brand == null || o.brand!.trim().isEmpty) {
      _markInvalid('brand');
      dropsValid = false;
    }

    if (!isFormValid || !dropsValid) {
      Get.snackbar(
        'بيانات ناقصة',
        'يرجى تعبئة جميع الحقول المطلوبة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        titleText: const SizedBox.shrink(),
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
      return;
    }

    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 2)); // TODO: API call

      final payload = {
        ...o.toJson(),
        'recurring': selectedRecurring.value,
      };
      debugPrint('Submitting: $payload');

      Get.snackbar(
        'تم الإرسال ✓',
        'تم إرسال الطلب بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
      );
      // Get.back();
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء الإرسال، يرجى المحاولة مجدداً',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
      );
    } finally {
      isLoading.value = false;
    }
  }
}