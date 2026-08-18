import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:stock_mate_project/Service/Boss/Get_All_Suppliers_Service.dart';
import 'package:stock_mate_project/core/models/Supplier_Model.dart';

class GetAllSuppliersController extends GetxController {
  List<SupplierModel>? suppliers;

  @override
  void onInit() {
    super.onInit();
    _loadSuppliers();
  }

  Future<void> _loadSuppliers() async {
    suppliers = await SupplierService.getSuppliers();
    update();
  }
}
