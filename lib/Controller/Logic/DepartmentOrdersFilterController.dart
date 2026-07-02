// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Logic/Orders_Controller.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';

class DepartmentOrdersFilterController extends GetxController {
  final OrdersController ordersController = Get.find();

  final RxString selectedFilter = 'الكل'.obs;

  late final Worker _worker;

  final List<String> filters = [
    'الكل',
    'منجز',
    'طلبات مستلمة',
    'معلق',
    'قيد التنفيذ',
    'الطلبات الدورية',
    'مرفوض',
  ];

  @override
  void onInit() {
    super.onInit();
    // === نفس منطق initState القديم ===
    setFilter(ordersController.initialFilter.value);
    _worker = ever(ordersController.initialFilter, (filter) {
      setFilter(filter);
    });
  }

  @override
  void onClose() {
    // === نفس منطق dispose القديم ===
    _worker.dispose();
    ordersController.initialFilter.value = 'الكل';
    super.onClose();
  }

  void setFilter(String filter) => selectedFilter.value = filter;

  void resetFilter() => selectedFilter.value = 'الكل';

  /// منطق الفلترة انتقل من الـ View إلى الـ Controller
  /// (فصل كامل بين المنطق والواجهة كما تتطلب معمارية GetX)
  List<Order> get filteredOrders {
    final orders = ordersController.orders;

    switch (selectedFilter.value) {
      case 'الكل':
        return orders.toList();
      case 'منجز':
        return orders.where((o) => o.status == OrderStatus.completed).toList();
      case 'طلبات مستلمة':
        return orders.where((o) => o.status == OrderStatus.reserved).toList();
      case 'معلق':
        return orders.where((o) => o.status == OrderStatus.suspended).toList();
      case 'قيد التنفيذ':
        return orders.where((o) => o.status == OrderStatus.inProgress).toList();
      case 'الطلبات الدورية':
        return orders.where((o) => o.isRecurring).toList();
      case 'مرفوض':
        return orders.where((o) => o.status == OrderStatus.rejected).toList();
      default:
        return orders.toList();
    }
  }
}