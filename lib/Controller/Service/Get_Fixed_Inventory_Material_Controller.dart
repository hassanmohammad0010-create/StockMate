import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Boss/Get_Fixed_Items_Service.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';

class GetFixedInventoryMaterialController extends GetxController {
  List<MaterialItem>? fixed;

  @override
  void onInit() async {
    super.onInit();
    fixed = await GetFixedItemsService().getFixedItemsService();
    update();
  }
}
