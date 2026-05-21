import 'package:stock_mate_project/core/models/Order_Models.dart';

class FindStatus {
  findOrderPriority({required OrderPriority orderPriority}) {
    if (orderPriority == OrderPriority.normal) {
      return 'عادي';
    } else if (orderPriority == OrderPriority.urgent) {
      return 'ضروري';
    }
  }
}
