// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Logic/Cart_Controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CartController(), permanent: true);
  }
}