import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Boss/Get_All_Department_Requests_Service.dart';
import 'package:stock_mate_project/core/models/Request_Model.dart';

class DepartmentRequestsController extends GetxController {
  final GetAllRequestService _requestService = GetAllRequestService();

  final RxList<RequestModel> allRequests = <RequestModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    isLoading.value = true;
    final List<RequestModel> result = await _requestService
        .getAllDepartmentRequests();
    allRequests.assignAll(result);
    isLoading.value = false;
  }

  Future<void> refreshRequests() async {
    await fetchRequests();
  }
}
