// lib/Controller/App/Get_Inventory_Transactions_Controller.dart
import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Boss/Get_Inventory_Transactions_Service.dart';
import 'package:stock_mate_project/core/models/Inventory_Transactions_Page_Data.dart';

class GetInventoryTransactionsController extends GetxController {
  final GetInventoryTransactionsService _service =
      GetInventoryTransactionsService();

  final RxBool isLoading = false.obs;
  final RxList<InventoryTransactionItem> transactions =
      <InventoryTransactionItem>[].obs;

  int _currentPage = 1;
  int _totalPages = 1;
  final int _limit = 20;

  String? _departmentId;
  String? _variantId;
  String? _transactionType;

  Future<void> fetchTransactions({
    String? departmentId,
    String? variantId,
    String? transactionType,
  }) async {
    _departmentId = departmentId;
    _variantId = variantId;
    _transactionType = transactionType;

    isLoading.value = true;
    _currentPage = 1;

    final result = await _service.getTransactions(
      page: _currentPage,
      limit: _limit,
      departmentId: _departmentId,
      variantId: _variantId,
      transactionType: _transactionType,
    );

    if (result != null) {
      _totalPages = result.totalPages;
      transactions.assignAll(result.items);
    }

    isLoading.value = false;
  }

  Future<void> loadMore() async {
    if (_currentPage >= _totalPages) return;
    _currentPage++;

    final result = await _service.getTransactions(
      page: _currentPage,
      limit: _limit,
      departmentId: _departmentId,
      variantId: _variantId,
      transactionType: _transactionType,
    );

    if (result != null) {
      transactions.addAll(result.items);
    }
  }
}
