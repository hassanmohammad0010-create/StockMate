// lib/Controller/App/Purchase_Requests_Controller.dart
import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Boss/Get_All_Purchase_Requests_Service.dart';
import 'package:stock_mate_project/core/models/Purchase_Request_Model.dart';

class PurchaseRequestsController extends GetxController {
  final GetPurchaseRequestsListService _service =
      GetPurchaseRequestsListService();

  final RxBool isLoading = false.obs;
  final RxList<PurchaseRequestListItem> allRequests =
      <PurchaseRequestListItem>[].obs;

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
    _currentPage = 1;

    final result = await _service.getRequests(
      page: _currentPage,
      limit: _limit,
    );

    if (result != null) {
      _totalPages = result.totalPages;
      allRequests.assignAll(result.items);
    }

    isLoading.value = false;
  }

  Future<void> loadMore() async {
    if (_currentPage >= _totalPages) return;
    _currentPage++;

    final result = await _service.getRequests(
      page: _currentPage,
      limit: _limit,
    );

    if (result != null) {
      allRequests.addAll(result.items);
    }
  }
}
