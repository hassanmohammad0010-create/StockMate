import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/models/Request_Model.dart';

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
      return constLightGreen;
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

  findFontColorStausFunction({required RequestStatus requestStatus}) {
    if (requestStatus == RequestStatus.deliveried) {
      return constGreen;
    } else if (requestStatus == RequestStatus.in_progress) {
      return constBlue;
    } else if (requestStatus == RequestStatus.pending) {
      return constOrange;
    } else if (requestStatus == RequestStatus.rejected) {
      return constRed;
    }
  }

  findFontColorPriorityFunction({required RequestPriority requestPriority}) {
    if (requestPriority == RequestPriority.normal) {
      return constBlue;
    } else if (requestPriority == RequestPriority.urgent) {
      return constRed;
    }
  }

  findBackgroundStausColor({required RequestStatus requestStatus}) {
    if (requestStatus == RequestStatus.deliveried) {
      return constLightGreen;
    } else if (requestStatus == RequestStatus.in_progress) {
      return constLightBlue;
    } else if (requestStatus == RequestStatus.pending) {
      return constLightOrange;
    } else if (requestStatus == RequestStatus.rejected) {
      return constLightRed;
    } else if (requestStatus == RequestStatus.ready_for_delivery) {
      return constLightGreen;
    }
  }

  findBackgroundPriorityColor({required RequestPriority requestPriority}) {
    if (requestPriority == RequestPriority.normal) {
      return constLightBlue;
    } else if (requestPriority == RequestPriority.urgent) {
      return constLightRed;
    }
  }
}
