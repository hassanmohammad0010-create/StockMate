import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Logic/DatePicker_Controller.dart';

class ElectronicInventoryPageBindings extends Bindings {
  @override
  void dependencies() {
    final DatePickerController controller = Get.put(DatePickerController());
  }
}
