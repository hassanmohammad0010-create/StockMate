import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';
import 'package:stock_mate_project/main.dart';

class OrdersController extends GetxController {
  var initialFilter = 'الكل'.obs;

  // القائمة reactive
  final RxList<Order> orders = allOrders.obs;

  // مفتاح التخزين في SharedPreferences
  static const String _receivedOrdersPrefsKey = 'received_orders';

  @override
  void onInit() {
    super.onInit();
    _loadReceivedOrdersFromPrefs();
  }

  // getters تحسب تلقائياً من القائمة
  int get completedCount =>
      orders.where((o) => o.status == OrderStatus.completed).length;
  int get rejectedCount =>
      orders.where((o) => o.status == OrderStatus.rejected).length;
  int get inProgressCount =>
      orders.where((o) => o.status == OrderStatus.inProgress).length;
  int get suspendedCount =>
      orders.where((o) => o.status == OrderStatus.suspended).length;

  /// يرجع الطلب الحالي (المحدث reactively) بالاعتماد على الـ id
  /// استخدمها داخل Obx لمتابعة أي تغيير يطرأ على الطلب (مثل تأكيد الاستلام)
  Order? getOrderById(String id) {
    final index = orders.indexWhere((o) => o.id == id);
    if (index == -1) return null;
    return orders[index];
  }

  /// تأكيد استلام طلب (لمرة واحدة فقط).
  /// [receivedQty] الكمية الفعلية المستلمة (null أو 0 تعني استلام الكمية كاملة).
  /// يرجع true لو نجحت العملية، false لو الطلب غير موجود أو مؤكد مسبقاً
  /// أو الكمية المدخلة أكبر من الكمية المطلوبة.
  bool confirmReceive(String orderId, {int? receivedQty}) {
    final index = orders.indexWhere((o) => o.id == orderId);
    if (index == -1) return false;

    final current = orders[index];

    // منع التأكيد أكثر من مرة
    if (current.receivedConfirmed) return false;

    // لو ما أدخل شيء => استلم الكمية كاملة
    final finalQty = receivedQty ?? current.quantity;

    // التحقق: لا يمكن استلام كمية أكبر من المطلوبة
    if (finalQty > current.quantity) return false;

    orders[index] = current.copyWith(
      receivedConfirmed: true,
      receivedQuantity: finalQty,
    );

    _saveReceivedOrdersToPrefs();

    return true;
  }

  // ── حفظ/تحميل حالة الطلبات المؤكدة عبر SharedPreferences ─────────────

  /// يحفظ Map بصيغة {orderId: receivedQty} لكل الطلبات المؤكدة فقط.
  /// لا نحفظ الطلب كاملاً، فقط حالة التأكيد والكمية المستلمة، لأن باقي
  /// بيانات الطلب مصدرها الثابت allOrders.
  Future<void> _saveReceivedOrdersToPrefs() async {
    final prefs = shareprefs;
    if (prefs == null) return;

    final Map<String, int> receivedMap = {
      for (final o in orders)
        if (o.receivedConfirmed) o.id!: (o.receivedQuantity ?? o.quantity),
    };

    await prefs.setString(_receivedOrdersPrefsKey, jsonEncode(receivedMap));
  }

  Future<void> _loadReceivedOrdersFromPrefs() async {
    final prefs = shareprefs;
    if (prefs == null) return;

    final raw = prefs.getString(_receivedOrdersPrefsKey);
    if (raw == null || raw.isEmpty) return;

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;

      for (var i = 0; i < orders.length; i++) {
        final order = orders[i];
        if (decoded.containsKey(order.id)) {
          final qty = decoded[order.id] as int;
          orders[i] = order.copyWith(
            receivedConfirmed: true,
            receivedQuantity: qty,
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('OrdersController: failed to parse received orders: $e');
      }
    }
  }
}