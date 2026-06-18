import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Logic/Toggle_Controller.dart';

class CompletedRequestPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ToggleController>(
      () => ToggleController(),
      tag: 'CompletedRequestPage',
    );
  }
}
