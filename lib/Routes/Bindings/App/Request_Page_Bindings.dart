import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
import 'package:stock_mate_project/Controller/Logic/Toggle_Controller.dart';

class RequestPageBindings extends Bindings {
  @override
  void dependencies() {
    final FilterController filterController = Get.put(
      FilterController(),
      tag: 'RequestPage',
    );

    final ToggleController toggleController = Get.put(
      ToggleController(),
      tag: 'RequestPage',
    );
  }
}
