// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Logic/Orders_Controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OrdersController());
  }
}