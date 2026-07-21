// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';

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

  // ─── المدة (عدد التكرارات) — إجبارية ولا يمكن أن تكون null ──────────────
  // تُهيَّأ في onInit() بأول خيار مطابق لقيمة selectedRecurring الافتراضية
  late final RxString selectedDuration;

  // ─── Reactive بالحقول الفارغة ─────────────────────────────────────────────
  final RxSet<String> invalidFields = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // تهيئة المدة بأول خيار من القائمة المطابقة للتكرار الافتراضي (weekly → اسبوعين)
    selectedDuration = durationOptions.first.obs;
    order.value = order.value.copyWith(duration: selectedDuration.value);
  }

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
    // إعادة ضبط المدة تلقائياً لأول خيار في القائمة الجديدة (لا تصبح أبداً null)
    final firstOption = durationOptions.first;
    selectedDuration.value = firstOption;
    order.value = order.value.copyWith(duration: firstOption);
    _clearInvalid('duration');
  }

  // ─── المدة ────────────────────────────────────────────────────────────────

  /// يولّد قائمة نصوص المدة بالعربية بناءً على نوع التكرار الحالي.
  /// daily   → من يومين إلى 365 يوم
  /// weekly  → من اسبوعين إلى 52 اسبوع
  /// monthly → من شهرين إلى 12 شهر
  List<String> get durationOptions {
    switch (selectedRecurring.value) {
      case 'daily':
        return List.generate(364, (i) => _dayLabel(i + 2));
      case 'monthly':
        return List.generate(11, (i) => _monthLabel(i + 2));
      case 'weekly':
      default:
        return List.generate(51, (i) => _weekLabel(i + 2));
    }
  }

  String _dayLabel(int n) {
    if (n == 2) return 'يومين';
    if (n >= 3 && n <= 10) return '$n أيام';
    return '$n يوم';
  }

  String _weekLabel(int n) {
    if (n == 2) return 'اسبوعين';
    if (n >= 3 && n <= 10) return '$n اسابيع';
    return '$n اسبوع';
  }

  String _monthLabel(int n) {
    if (n == 2) return 'شهرين';
    if (n >= 3 && n <= 10) return '$n اشهر';
    return '$n شهر';
  }

  void updateDuration(String value) {
    selectedDuration.value = value;
    order.value = order.value.copyWith(duration: value);
    _clearInvalid('duration');
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

  // void updateUnit(String? value) {
  //   order.value = order.value.copyWith(unit: value);
  //   if (value != null && value.isNotEmpty) {
  //     _clearInvalid('unit');
  //   } else {
  //     _markInvalid('unit');
  //   }
  //   order.refresh();
  // }

  // void updateBrand(String? value) {
  //   order.value = order.value.copyWith(brand: value);
  //   if (value != null && value.isNotEmpty) {
  //     _clearInvalid('brand');
  //   } else {
  //     _markInvalid('brand');
  //   }
  //   order.refresh();
  // }

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
    // if (o.unit == null || o.unit!.trim().isEmpty) {
    //   _markInvalid('unit');
    //   dropsValid = false;
    // }
    // if (o.brand == null || o.brand!.trim().isEmpty) {
    //   _markInvalid('brand');
    //   dropsValid = false;
    // }
    // لا حاجة للتحقق من duration هنا — مضمون دائماً أن يحمل قيمة منذ onInit()

    // ❌ حقول ناقصة — أظهر snackbar وابقَ في الصفحة
    if (!isFormValid || !dropsValid) {
      customSnackBar(
        title: 'بيانات ناقصة',
        message: 'يرجى تعبئة جميع الحقول المطلوبة',
        color: constRed,
        messageColor: Colors.white,
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

      customSnackBar(
        title: 'تم الإرسال',
        message: 'تم إرسال الطلب بنجاح',
        color: constGreen,
        messageColor: Colors.white,
      );
      Get.offAllNamed(AppRoutes.DepartmentHeadsMainPage);

      // TODO: Get.offAllNamed('/HomePage') بعد الإرسال الناجح
    } catch (e) {
      customSnackBar(
        title: 'خطأ',
        message: 'حدث خطأ أثناء الإرسال، يرجى المحاولة مجدداً',
        color: constRed,
        messageColor: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}