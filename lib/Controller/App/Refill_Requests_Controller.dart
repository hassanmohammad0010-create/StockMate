import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Get_Refill_Requests_List_Service.dart';
import 'package:stock_mate_project/Service/Token_Storage.dart';
import 'package:stock_mate_project/core/models/Order_Item.dart';

class RefillRequestsController extends GetxController {
  final GetRefillRequestsListService _service = GetRefillRequestsListService();

  final RxBool isLoading = false.obs;
  final RxList<OrdertItem> allRequests = <OrdertItem>[].obs;

  int _currentPage = 1;
  int _totalPages = 1;
  final int _limit = 20;

  /// لو true → بيستخدم getAllRequests (كل الطلبات)
  /// لو false → بيستخدم getRequests (طلبات قسم معيّن)
  final bool fetchAll;
  String? _departmentId;

  RefillRequestsController({this.fetchAll = true});

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    if (!fetchAll) {
      _departmentId = await TokenStorage.getDepartmentID();
    }
    await refreshRequests();
  }

  Future<void> refreshRequests() async {
    isLoading.value = true;
    _currentPage = 1;

    final result = fetchAll
        ? await _service.getAllRequests(page: _currentPage, limit: _limit)
        : (_departmentId == null || _departmentId!.isEmpty)
        ? null
        : await _service.getRequests(
            departmentId: _departmentId!,
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

    final result = fetchAll
        ? await _service.getAllRequests(page: _currentPage, limit: _limit)
        : (_departmentId == null)
        ? null
        : await _service.getRequests(
            departmentId: _departmentId!,
            page: _currentPage,
            limit: _limit,
          );

    if (result != null) {
      allRequests.addAll(result.items);
    }
  }
}
