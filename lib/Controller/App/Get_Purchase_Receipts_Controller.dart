// lib/Controller/App/Get_Purchase_Receipts_Controller.dart
import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Boss/Get_Purchase_Receipts_List_Service.dart';

import 'package:stock_mate_project/core/models/Purchase_Receipts_Page_Data_Model.dart';

class GetPurchaseReceiptsController extends GetxController {
  GetPurchaseReceiptsController({this.purchaseRequestId});

  /// لو null → بيجيب كل الإيصالات، لو معبّى → بيفلتر على طلب شراء معيّن
  final String? purchaseRequestId;

  final GetPurchaseReceiptsListService _service =
      GetPurchaseReceiptsListService();

  final RxBool isLoading = false.obs;
  final RxList<PurchaseReceiptItem> receipts = <PurchaseReceiptItem>[].obs;

  int _currentPage = 1;
  int _totalPages = 1;
  final int _limit = 20;

  @override
  void onInit() {
    super.onInit();
    refreshReceipts();
  }

  Future<void> refreshReceipts() async {
    isLoading.value = true;
    _currentPage = 1;

    final result = await _service.getReceipts(
      page: _currentPage,
      limit: _limit,
      purchaseRequestId: purchaseRequestId,
    );

    if (result != null) {
      _totalPages = result.totalPages;
      receipts.assignAll(result.items);
    }

    isLoading.value = false;
  }

  Future<void> loadMore() async {
    if (_currentPage >= _totalPages) return;
    _currentPage++;

    final result = await _service.getReceipts(
      page: _currentPage,
      limit: _limit,
      purchaseRequestId: purchaseRequestId,
    );

    if (result != null) {
      receipts.addAll(result.items);
    }
  }
}
