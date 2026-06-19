// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Dialog.dart';

class AddRecurringOrderController extends GetxController {
  // ─── Reactive state ───────────────────────────────────────────────────────
  final Rx<OrderModel> order = OrderModel().obs;
  final RxBool isLoading = false.obs;

  // ─── TextEditingController للكمية + GlobalKey للـ Form ───────────────────
  final TextEditingController quantityController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ─── التكرار — القيمة الافتراضية: أسبوعي ─────────────────────────────────
  final RxString selectedRecurring = 'weekly'.obs;

  static const Map<String, String> recurringLabels = {
    'daily': 'يومي',
    'weekly': 'أسبوعي',
    'monthly': 'شهري',
  };

  // ─── Reactive بالحقول الفارغة ─────────────────────────────────────────────
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

  void markInvalidPublic(String field) {
    invalidFields.add(field);
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

  void _saveQuantity() {
    final qty = quantityController.text;
    order.value = order.value.copyWith(quantity: qty);
    if (qty.trim().isNotEmpty) {
      _clearInvalid('quantity');
    } else {
      _markInvalid('quantity');
    }
  }

  // ─── STEP 1 : التحقق فقط ثم الانتقال لصفحة التأكيد ──────────────────────
  void validateAndGoToConfirm() {
    _saveQuantity();

    final isFormValid = formKey.currentState?.validate() ?? false;
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

    // ❌ حقول ناقصة — أظهر snackbar وابقَ في الصفحة
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

    // ✅ كل شيء صحيح — انتقل لصفحة التأكيد فقط بدون إرسال
    Get.toNamed('/RecurringConfirmPage');
  }

  // ─── STEP 2 : الإرسال الفعلي من صفحة التأكيد فقط ────────────────────────
  Future<void> submitOrder() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 2)); // TODO: API call

      final payload = {
        ...order.value.toJson(),
        'recurring': selectedRecurring.value,
      };
      debugPrint('Submitting: $payload');

      CustomDialog.show(
        type: DialogType.success,
        title: 'تم الإرسال',
        message: 'تم إرسال الطلب بنجاح',
        onConfirm: () => Get.offAllNamed(AppRoutes.DepartmentHeadsMainPage),
      );

      // TODO: Get.offAllNamed('/HomePage') بعد الإرسال الناجح
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
