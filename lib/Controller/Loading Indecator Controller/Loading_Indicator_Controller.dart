// ignore_for_file: file_names

import 'package:get/get.dart';

class LoadingIndicatorController extends GetxController {
  bool load = false;
  @override
  isLoad() {
    super.onInit();
    load = true;
    update();
  }

  isntLoad() {
    super.onInit();
    load = false;
    update();
  }
}
