// lib/Controller/Service/Urgent_Purchase_Requests_Controller.dart
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:stock_mate_project/Service/Boss/Get_Urgent_Purchase_RequestsList_Service.dart';
import 'package:stock_mate_project/core/models/Purchase_Request_Model.dart';

class UrgentPurchaseRequestsController extends GetxController {
  final GetUrgentPurchaseRequestsListService _service =
      GetUrgentPurchaseRequestsListService();

  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
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
    hasError.value = false;
    _currentPage = 1;

    final result = await _service.getUrgentRequests(
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

    final result = await _service.getUrgentRequests(
      page: _currentPage,
      limit: _limit,
    );

    if (result != null) {
      allRequests.addAll(result.items);
    }
  }
}
