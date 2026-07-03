import 'package:stock_mate_project/core/models/Order_Models.dart';

class FindOrderStatus {
  findOrderStatus({required OrderStatus orderStatus}) {
    if (orderStatus == OrderStatus.completed) {
      return 'منجز';
    } else if (orderStatus == OrderStatus.inProgress) {
      return 'قيد التنفيذ';
    } else if (orderStatus == OrderStatus.rejected) {
      return 'مرفوضة';
    } else if (orderStatus == OrderStatus.suspended) {
      return 'معلق';
    }
  }
}
