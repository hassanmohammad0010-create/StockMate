import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Boss/Get_Consumable_Items_Service.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';

class GetConsunbleInventoryMaterialController extends GetxController {
  List<MaterialItem>? consunble;

  @override
  void onInit() async {
    super.onInit();
    consunble = await GetConsumableItemsService().getConsumableItemsService();
    update();
  }
}
