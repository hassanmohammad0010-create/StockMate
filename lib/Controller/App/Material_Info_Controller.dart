import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class MaterialInfoController extends GetxController {
  // final Rx<MaterialItem> material = dummyMaterial.obs;
  final RxBool showBatches = true.obs;

  void toggleBatches() => showBatches.toggle();
}
