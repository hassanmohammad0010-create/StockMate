// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';

class OrdersController extends GetxController {
  var initialFilter = 'الكل'.obs;

  final RxList<Order> orders = allOrders.obs;

  // getters
  int get completedCount =>
      orders.where((o) => o.status == OrderStatus.completed).length;
  int get rejectedCount =>
      orders.where((o) => o.status == OrderStatus.rejected).length;
  int get inProgressCount =>
      orders.where((o) => o.status == OrderStatus.inProgress).length;
  int get suspendedCount =>
      orders.where((o) => o.status == OrderStatus.suspended).length;
  int get receivedCount =>
      orders.where((o) => o.status == OrderStatus.reserved).length;

  Order? getOrderById(String id) {
    final index = orders.indexWhere((o) => o.id == id);
    if (index == -1) return null;
    return orders[index];
  }

  bool confirmReceive(String orderId, {int? receivedQty}) {
    final index = orders.indexWhere((o) => o.id == orderId);
    if (index == -1) return false;

    final current = orders[index];

    if (current.receivedConfirmed) return false;

    final finalQty = receivedQty ?? current.quantity;

    if (finalQty > current.quantity) return false;

    orders[index] = current.copyWith(
      status: OrderStatus.reserved,
      receivedConfirmed: true,
      receivedQuantity: finalQty,
    );

    return true;
  }
}