// lib/Controller/App/Get_Supplier_Materials_Controller.dart
import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Boss/Get_All_Material_Reletedto_Supplier_Service.dart';
import 'package:stock_mate_project/core/models/Supplier_Material_Model.dart';

class GetSupplierMaterialsController extends GetxController {
  GetSupplierMaterialsController({required this.supplierId});

  final String supplierId;
  List<SupplierMaterialModel>? materials; // null = لسا عم يحمّل

  @override
  void onInit() {
    super.onInit();
    _loadMaterials();
  }

  Future<void> _loadMaterials() async {
    materials = await SupplierMaterialService.getSupplierMaterials(
      supplierId: supplierId,
    );
    update();
  }
}
