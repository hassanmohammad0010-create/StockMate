// lib/Controller/App/Live_Stock_Material_Controller.dart
import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Boss/Get_Live_Stock_Service.dart';
import 'package:stock_mate_project/core/models/New_MaterialItem.dart';

class LiveStockController extends GetxController {
  LiveStockController({required this.departmentId});

  final String departmentId;
  final GetLiveStockService _service = GetLiveStockService();

  final RxBool isLoading = false.obs;
  final RxList<MaterialItem> allMaterials = <MaterialItem>[].obs;

  int _currentPage = 1;
  int _totalPages = 1;
  final int _limit = 20;

  @override
  void onInit() {
    super.onInit();
    refreshMaterials();
  }

  Future<void> refreshMaterials() async {
    if (departmentId.isEmpty) return;

    isLoading.value = true;
    _currentPage = 1;

    final result = await _service.getLiveStock(
      departmentId: departmentId,
      page: _currentPage,
      limit: _limit,
    );

    if (result != null) {
      _totalPages = result.totalPages;
      allMaterials.assignAll(result.items);
    }

    isLoading.value = false;
  }

  Future<void> loadMore() async {
    if (_currentPage >= _totalPages) return;
    _currentPage++;

    final result = await _service.getLiveStock(
      departmentId: departmentId,
      page: _currentPage,
      limit: _limit,
    );

    if (result != null) {
      allMaterials.addAll(result.items);
    }
  }
}
