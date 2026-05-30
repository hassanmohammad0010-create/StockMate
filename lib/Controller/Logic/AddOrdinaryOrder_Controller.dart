// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderItem {
  RxString medicine = ''.obs;
  RxString brand = ''.obs;    // الوكيل / الماركة
  RxInt quantity = 1.obs;
  RxString priority = 'عادي'.obs;
}

class AddOrdinaryOrderController extends GetxController {
  static const int maxOrders = 5;

  final RxList<OrderItem> orders = <OrderItem>[].obs;
  final RxInt expandedIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    addOrder(); // ابدأ بطلب واحد افتراضياً
  }

  void addOrder() {
    if (orders.length >= maxOrders) return;
    orders.add(OrderItem());
    expandedIndex.value = orders.length - 1; // افتح الجديد تلقائياً
  }

  void removeOrder(int index) {
    if (orders.length <= 1) return;
    orders.removeAt(index);
    if (expandedIndex.value == index) {
      expandedIndex.value = -1;
    } else if (expandedIndex.value > index) {
      expandedIndex.value--;
    }
  }

  void toggleExpanded(int index) {
    expandedIndex.value = expandedIndex.value == index ? -1 : index;
  }

  bool get canAddMore => orders.length < maxOrders;

 void confirmOrders() {
  final incomplete = orders.any(
    (o) =>
      o.medicine.value.trim().isEmpty ||  // لم يختر مادة
      o.brand.value.trim().isEmpty ||     // لم يختر ماركة
      o.quantity.value <= 0,             // الكمية صفر أو أقل
  );

  if (incomplete) {
    Get.snackbar(
      'تنبيه',
      'يرجى تعبئة جميع حقول الطلبات قبل الإرسال',
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      snackPosition: SnackPosition.TOP,
    );
    return;
  }

  // هنا القيم جاهزة للإرسال
  for (final order in orders) {
    debugPrint('دواء: ${order.medicine.value}');
    debugPrint('ماركة: ${order.brand.value}');
    debugPrint('كمية: ${order.quantity.value}');
    debugPrint('أولوية: ${order.priority.value}');
  }
}
}