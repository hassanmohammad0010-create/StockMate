import 'package:stock_mate_project/Constant/Const.dart';

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
}
