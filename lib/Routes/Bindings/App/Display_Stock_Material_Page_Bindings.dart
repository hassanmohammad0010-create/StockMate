import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';

class DisplayStockMaterialPageBindings extends Bindings {
  @override
  void dependencies() {
    final FilterController filterController = Get.put(
      FilterController(),
      tag: 'DisplayStockPage',
    );
  }
}
