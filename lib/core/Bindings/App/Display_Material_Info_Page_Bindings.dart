import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/App/Material_Info_Controller.dart';

class DisplayMaterialInfoPage extends Bindings {
  @override
  void dependencies() {
    final MaterialInfoController controller = Get.put(MaterialInfoController());
  }
}
