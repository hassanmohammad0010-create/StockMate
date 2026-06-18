// import 'package:get/get.dart';

// class OrdersController extends GetxController {
//   var initialFilter = 'الكل'.obs;
// }

import 'package:get/get.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';

class OrdersController extends GetxController {
  var initialFilter = 'الكل'.obs;

  // القائمة reactive
  final RxList<Order> orders = allOrders.obs;

  // getters تحسب تلقائياً من القائمة
  int get completedCount  => orders.where((o) => o.status == OrderStatus.completed).length;
  int get rejectedCount   => orders.where((o) => o.status == OrderStatus.rejected).length;
  int get inProgressCount => orders.where((o) => o.status == OrderStatus.inProgress).length;
  int get suspendedCount  => orders.where((o) => o.status == OrderStatus.suspended).length;
}