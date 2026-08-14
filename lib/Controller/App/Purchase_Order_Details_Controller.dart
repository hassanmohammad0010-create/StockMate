// lib/Controller/App/Get_Purchase_Request_Details_Controller.dart
// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Boss/Get_Purchase_Request_Details_Service.dart';
import 'package:stock_mate_project/core/models/Purchase_Request_Model.dart';

class PurchaseOrderDetailsController extends GetxController {
  PurchaseOrderDetailsController({required this.requestId});

  final String requestId;
  final GetPurchaseRequestDetailsService _service =
      GetPurchaseRequestDetailsService();

  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final Rx<PurchaseRequestDetails?> details = Rx<PurchaseRequestDetails?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    isLoading.value = true;
    hasError.value = false;

    final result = await _service.getRequestDetails(requestId: requestId);

    if (result == null) {
      hasError.value = true;
    } else {
      details.value = result;
    }

    isLoading.value = false;
  }
}
