import 'package:get/get.dart';

class VisibleController extends GetxController {
  bool isVisib = false;

  void isVisible() {
    isVisib = true;
    update();
  }

  void isntVisible() {
    isVisib = false;
    update();
  }
}
