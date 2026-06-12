// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';

class AddOrdinaryOrderController extends GetxController {
  static const int maxOrders = 5;

  // ─── Reactive state ───────────────────────────────────────────────────────
  final RxList<OrderModel> orders          = <OrderModel>[OrderModel()].obs;
  final RxInt              activeOrderIndex = 0.obs;
  final RxBool             isLoading        = false.obs;

  // ─── TextEditingController للكمية + GlobalKey للـ Form لكل طلب ───────────
  final List<TextEditingController> _quantityControllers = [];
  final List<GlobalKey<FormState>>  formKeys             = [];

  // ─── Reactive بالحقول الفارغة لكل طلب (لإظهار border أحمر على الـ dropdowns) ─
  // Map<orderIndex, Set<fieldName>>
  final RxMap<int, Set<String>> invalidFields = <int, Set<String>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _addControllerSet();
  }

  @override
  void onClose() {
    for (final c in _quantityControllers) {
      c.dispose();
    }
    super.onClose();
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  void _addControllerSet() {
    _quantityControllers.add(TextEditingController());
    formKeys.add(GlobalKey<FormState>());
  }

  TextEditingController quantityCtrl([int? index]) =>
      _quantityControllers[index ?? activeOrderIndex.value];

  GlobalKey<FormState> formKey([int? index]) =>
      formKeys[index ?? activeOrderIndex.value];

  /// هل الحقل [field] في الطلب [index] يعاني من خطأ validation؟
  bool isFieldInvalid(int index, String field) =>
      invalidFields[index]?.contains(field) ?? false;

  void _markInvalid(int index, String field) {
    final set = invalidFields[index] ?? {};
    set.add(field);
    invalidFields[index] = set;
    invalidFields.refresh();
  }

  void _clearInvalid(int index, String field) {
    invalidFields[index]?.remove(field);
    invalidFields.refresh();
  }

  // ─── Order management ─────────────────────────────────────────────────────

  bool get canAddOrder    => orders.length < maxOrders;
  bool get canRemoveOrder => orders.length > 1;

  void addOrder() {
    if (!canAddOrder) {
      Get.snackbar(
        'تنبيه',
        'لا يمكنك إضافة أكثر من $maxOrders طلبات',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    _saveCurrentQuantity();
    orders.add(OrderModel());
    _addControllerSet();
    activeOrderIndex.value = orders.length - 1;
  }

  void removeOrder(int index) {
    if (!canRemoveOrder) return;
    _quantityControllers[index].dispose();
    _quantityControllers.removeAt(index);
    formKeys.removeAt(index);
    orders.removeAt(index);
    invalidFields.remove(index);

    // أعد ترقيم الـ invalidFields بعد الحذف
    final newMap = <int, Set<String>>{};
    invalidFields.forEach((k, v) {
      if (k < index) newMap[k] = v;
      if (k > index) newMap[k - 1] = v;
    });
    invalidFields.assignAll(newMap);

    if (activeOrderIndex.value >= orders.length) {
      activeOrderIndex.value = orders.length - 1;
    }
  }

  void selectOrder(int index) {
    _saveCurrentQuantity();
    activeOrderIndex.value = index;
    _loadQuantityToController(index);
  }

  // ─── Sync: quantity ↔ model ───────────────────────────────────────────────

  void _saveCurrentQuantity() {
    final i = activeOrderIndex.value;
    if (i >= orders.length) return;
    final qty = _quantityControllers[i].text;
    orders[i] = orders[i].copyWith(quantity: qty);
    // امسح خطأ الكمية إذا أُدخلت
    if (qty.trim().isNotEmpty) _clearInvalid(i, 'quantity');
  }

  void _loadQuantityToController(int index) {
    _quantityControllers[index].text = orders[index].quantity;
  }

  // ─── Dropdown updates ─────────────────────────────────────────────────────

  void updateMedicineName(int index, String? value) {
    if (index >= orders.length) return;
    // نمرر null صراحةً عند المسح — copyWith يدعمه بالـ sentinel
    orders[index] = orders[index].copyWith(medicineName: value);
    if (value != null && value.isNotEmpty) {
      _clearInvalid(index, 'medicineName');
    } else {
      _markInvalid(index, 'medicineName');
    }
    orders.refresh();
  }

  void updateUnit(int index, String? value) {
    if (index >= orders.length) return;
    orders[index] = orders[index].copyWith(unit: value);
    if (value != null && value.isNotEmpty) {
      _clearInvalid(index, 'unit');
    } else {
      _markInvalid(index, 'unit');
    }
    orders.refresh();
  }

  void updateBrand(int index, String? value) {
    if (index >= orders.length) return;
    orders[index] = orders[index].copyWith(brand: value);
    if (value != null && value.isNotEmpty) {
      _clearInvalid(index, 'brand');
    } else {
      _markInvalid(index, 'brand');
    }
    orders.refresh();
  }

  void updatePriority(int index, String priority) {
    if (index >= orders.length) return;
    orders[index] = orders[index].copyWith(priority: priority);
    orders.refresh();
  }

  // ─── Submission ───────────────────────────────────────────────────────────

  Future<void> submitOrders() async {
    _saveCurrentQuantity();

    // 1. validate الـ TextFormField بالـ Form key للطلب النشط
    final currentFormValid =
        formKey(activeOrderIndex.value).currentState?.validate() ?? true;

    // 2. validate كل الطلبات
    bool allValid = currentFormValid;
    for (int i = 0; i < orders.length; i++) {
      final o = orders[i];
      bool orderOk = true;

      if (o.medicineName == null || o.medicineName!.trim().isEmpty) {
        _markInvalid(i, 'medicineName');
        orderOk = false;
      }
      if (o.quantity.trim().isEmpty) {
        _markInvalid(i, 'quantity');
        orderOk = false;
      }
      if (o.unit == null || o.unit!.trim().isEmpty) {
        _markInvalid(i, 'unit');
        orderOk = false;
      }
      if (o.brand == null || o.brand!.trim().isEmpty) {
        _markInvalid(i, 'brand');
        orderOk = false;
      }

      if (!orderOk) {
        allValid = false;
        // انتقل لأول طلب فيه خطأ
        if (i != activeOrderIndex.value) {
          selectOrder(i);
          // أعد تشغيل الـ form validate بعد الانتقال
          WidgetsBinding.instance.addPostFrameCallback((_) {
            formKey(i).currentState?.validate();
          });
        }
        break;
      }
    }

    if (!allValid) {
      Get.snackbar(
        'بيانات ناقصة',
        'يرجى تعبئة جميع الحقول المطلوبة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
      );
      return;
    }

    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 2)); // TODO: API call

      final payload = orders.map((o) => o.toJson()).toList();
      debugPrint('Submitting: $payload');

      Get.snackbar(
        'تم الإرسال ✓',
        'تم إرسال ${orders.length} طلب بنجاح',
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