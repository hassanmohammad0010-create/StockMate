import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Logic/Toggle_Controller.dart';

class UnderImplementationRequestPageBindings extends Bindings {
  @override
  void dependencies() {
    final ToggleController controller = Get.put(
      ToggleController(),
      tag: 'UnderImplementationRequestPage',
    );
  }
}
