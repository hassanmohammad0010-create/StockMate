// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/App/Material_Info_Controller.dart';

class InventoryDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MaterialInfoController>(() => MaterialInfoController());
  }
}