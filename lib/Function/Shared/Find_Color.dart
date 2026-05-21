import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';

class FindColor {
  findFontColorFunction({required String word}) {
    if (word == 'تم الانجاز') {
      return constGreen;
    } else if (word == 'قيد التنفيذ') {
      return constBlue;
    } else if (word == 'بأنتظار موافقتك') {
      return constOrange;
    } else if (word == 'ضروري') {
      return constRed;
    } else if (word == 'عادي') {
      return constBlue;
    }
  }

  findBackgroundColor({required String word}) {
    if (word == 'تم الانجاز') {
      return constlightGreen;
    } else if (word == 'قيد التنفيذ') {
      return constLightBlue;
    } else if (word == 'بأنتظار موافقتك') {
      return constLightOrange;
    } else if (word == 'ضروري') {
      return constLightRed;
    } else if (word == 'عادي') {
      return constLightBlue;
    }
  }

  findFontColorStausFunction({required OrderStatus orderStatus}) {
    if (orderStatus == OrderStatus.completed) {
      return constGreen;
    } else if (orderStatus == OrderStatus.inProgress) {
      return constBlue;
    } else if (orderStatus == OrderStatus.suspended) {
      return constOrange;
    } else if (orderStatus == OrderStatus.rejected) {
      return constRed;
    }
  }

  findFontColorPriorityFunction({required OrderPriority orderPriority}) {
    if (orderPriority == OrderPriority.normal) {
      return constBlue;
    } else if (orderPriority == OrderPriority.urgent) {
      return constRed;
    }
  }

  findBackgroundStausColor({required OrderStatus orderStatus}) {
    if (orderStatus == OrderStatus.completed) {
      return constlightGreen;
    } else if (orderStatus == OrderStatus.inProgress) {
      return constLightBlue;
    } else if (orderStatus == OrderStatus.suspended) {
      return constLightOrange;
    } else if (orderStatus == OrderStatus.rejected) {
      return constLightRed;
    }
  }

  findBackgroundPriorityColor({required OrderPriority orderPriority}) {
    if (orderPriority == OrderPriority.normal) {
      return constLightBlue;
    } else if (orderPriority == OrderPriority.urgent) {
      return constLightRed;
    }
  }
}
