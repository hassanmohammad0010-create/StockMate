// lib/Controller/App/Get_Catalog_Variants_Controller.dart
import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Boss/Get_Catalog_Variants_Service.dart';
import 'package:stock_mate_project/core/models/Catalog_Variants_Page_Data_Model.dart';

class GetCatalogVariantsController extends GetxController {
  final GetCatalogVariantsService _service = GetCatalogVariantsService();

  final RxBool isLoading = false.obs;
  final RxList<CatalogVariant> variants = <CatalogVariant>[].obs;
  final Rxn<CatalogVariant> selectedVariant = Rxn<CatalogVariant>();

  int _currentPage = 1;
  int _totalPages = 1;
  final int _limit = 20;

  @override
  void onInit() {
    super.onInit();
    fetchVariants();
  }

  Future<void> fetchVariants() async {
    isLoading.value = true;
    _currentPage = 1;

    final result = await _service.getVariants(
      page: _currentPage,
      limit: _limit,
    );

    if (result != null) {
      _totalPages = result.totalPages;
      variants.assignAll(result.items);
    }

    isLoading.value = false;
  }

  Future<void> loadMore() async {
    if (_currentPage >= _totalPages) return;
    _currentPage++;

    final result = await _service.getVariants(
      page: _currentPage,
      limit: _limit,
    );

    if (result != null) {
      variants.addAll(result.items);
    }
  }
}
