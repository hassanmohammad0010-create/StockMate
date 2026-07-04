import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Boss/Get_Suppliers_Service.dart';
import 'package:stock_mate_project/core/models/Supplier_Model.dart';

class GetAllSuppliersController extends GetxController {
  List<SupplierModel>? suppliers;
  @override
  void onInit() async {
    super.onInit();
    suppliers = await GetSuppliersService().getSuppliersService();

    update();
  }
}
