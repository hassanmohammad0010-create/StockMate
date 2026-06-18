import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Logic/Toggle_Controller.dart';

class InventoryPageBindings extends Bindings {
  @override
  void dependencies() {
    final ToggleController controller = Get.put(
      ToggleController(),
      tag: 'InventoryPage',
    );
  }
}
