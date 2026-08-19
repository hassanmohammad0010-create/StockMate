// lib/Controller/App/Get_Disposal_Sales_Controller.dart
import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Boss/Get_Disposal_Sales_Service.dart';
import 'package:stock_mate_project/core/models/Disposal_Sales_Page_Data_Model.dart';

class GetDisposalSalesController extends GetxController {
  final GetDisposalSalesService _service = GetDisposalSalesService();

  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxList<DisposalSaleListItem> allRequests = <DisposalSaleListItem>[].obs;

  int _currentPage = 1;
  int _totalPages = 1;
  final int _limit = 20;

  @override
  void onInit() {
    super.onInit();
    refreshRequests();
  }

  Future<void> refreshRequests() async {
    isLoading.value = true;
    hasError.value = false;
    _currentPage = 1;

    final result = await _service.getDisposalSales(
      page: _currentPage,
      limit: _limit,
    );

    if (result != null) {
      _totalPages = result.totalPages;
      allRequests.assignAll(result.items);
    } else {
      hasError.value = true;
    }

    isLoading.value = false;
  }

  Future<void> loadMore() async {
    if (_currentPage >= _totalPages) return;
    _currentPage++;

    final result = await _service.getDisposalSales(
      page: _currentPage,
      limit: _limit,
    );

    if (result != null) {
      allRequests.addAll(result.items);
    }
  }
}
