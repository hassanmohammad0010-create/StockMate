// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';

// class MaterialInfoController extends GetxController {
//   // final Rx<MaterialItem> material = dummyMaterial.obs;
//   final RxBool showBatches = true.obs;

//   void toggleBatches() => showBatches.toggle();
// }

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class MaterialInfoController extends GetxController {
  final RxBool showBatches = false.obs;
  final TextEditingController quantityController = TextEditingController();

  void toggleBatches() => showBatches.toggle();

  @override
  void onClose() {
    quantityController.dispose();
    super.onClose();
  }
}
