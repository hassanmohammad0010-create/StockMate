import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/models/Order_Item.dart';

class FindColor {
  // ─────────────────────────────────────────────────────────
  // الدوال اللي بتاخد String (للاستخدام مع statusLabel/priorityLabel
  // أو أي نص جاهز في الواجهة)
  // ─────────────────────────────────────────────────────────
  findFontColorFunction({required String word}) {
    if (word == 'مستلم') {
      return constGreen;
    } else if (word == 'منجز') {
      return constGreen;
    } else if (word == 'قيد التنفيذ') {
      return constBlue;
    } else if (word == 'بأنتظار موافقتك') {
      return constOrange;
    } else if (word == 'ضروري') {
      return constRed;
    } else if (word == 'عادي') {
      return constBlue;
    } else if (word == 'مرفوض') {
      return constRed;
    } else if (word == 'يومي' || word == 'شهري' || word == 'أسبوعي') {
      return constBlue;
    }
  }

  findBackgroundColor({required String word}) {
    if (word == 'مستلم') {
      return constLightGreen;
    } else if (word == 'منجز') {
      return constLightGreen;
    } else if (word == 'قيد التنفيذ') {
      return constLightBlue;
    } else if (word == 'بأنتظار موافقتك') {
      return constLightOrange;
    } else if (word == 'ضروري') {
      return constLightRed;
    } else if (word == 'عادي') {
      return constLightBlue;
    } else if (word == 'مرفوض') {
      return constLightRed;
    } else if (word == 'يومي' || word == 'شهري' || word == 'أسبوعي') {
      return constLightBlue;
    }
  }

  // ─────────────────────────────────────────────────────────
  // الدوال اللي بتاخد OrderStatus / OrderPriority (المودل الجديد)
  // ─────────────────────────────────────────────────────────

  findFontColorStausFunction({required OrderStatus requestStatus}) {
    switch (requestStatus) {
      case OrderStatus.draft:
      case OrderStatus.pending_hospital_approval:
        return constOrange;
      case OrderStatus.pending_manager_approval:
      case OrderStatus.preparing:
        return constBlue;
      case OrderStatus.hospital_rejected:
      case OrderStatus.manager_rejected:
      case OrderStatus.cancelled:
        return constRed;
      case OrderStatus.partially_complete:
        return constGreen;
      case OrderStatus.complete:
        return constGreen;
    }
  }

  findBackgroundStausColor({required OrderStatus requestStatus}) {
    switch (requestStatus) {
      case OrderStatus.draft:
      case OrderStatus.pending_hospital_approval:
        return constLightOrange;
      case OrderStatus.pending_manager_approval:
      case OrderStatus.preparing:
        return constLightBlue;
      case OrderStatus.hospital_rejected:
      case OrderStatus.manager_rejected:
      case OrderStatus.cancelled:
        return constLightRed;
      case OrderStatus.partially_complete:
        return constLightGreen;
      case OrderStatus.complete:
        return constLightGreen;
    }
  }

  findFontColorPriorityFunction({required OrderPriority requestPriority}) {
    if (requestPriority == OrderPriority.normal) {
      return constBlue;
    } else if (requestPriority == OrderPriority.urgent) {
      return constRed;
    }
  }

  findBackgroundPriorityColor({required OrderPriority requestPriority}) {
    if (requestPriority == OrderPriority.normal) {
      return constLightBlue;
    } else if (requestPriority == OrderPriority.urgent) {
      return constLightRed;
    }
  }
}
