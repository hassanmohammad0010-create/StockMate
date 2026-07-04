import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Boss/Get_Medicine_Items_Service.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';

class GetMedicineInventoryMaterialController extends GetxController {
  List<MaterialItem>? medicine;

  @override
  void onInit() async {
    super.onInit();
    medicine = await GetMedicineItemsService().getMedicineItemsService();
    update();
  }
}
