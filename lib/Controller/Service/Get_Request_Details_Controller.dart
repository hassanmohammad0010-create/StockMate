// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Get_Refill_Request_Details_Service.dart';
import 'package:stock_mate_project/core/models/Order_Item_Details.dart';

class RequestDetailsController extends GetxController {
  RequestDetailsController({required this.requestId});

  final String requestId;

  final GetRefillRequestDetailsService _detailsService =
      GetRefillRequestDetailsService();

  // ─── Reactive state ───────────────────────────────────────────────
  final Rxn<OrderItemDetails> details = Rxn<OrderItemDetails>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _detailsService.getRequestDetails(
        requestId: requestId,
      );

      if (result == null) {
        errorMessage.value = 'تعذر تحميل تفاصيل الطلب';
      } else {
        details.value = result;
        print('✅ تم جلب تفاصيل الطلب: ${result.requestNumber}');
      }
    } finally {
      isLoading.value = false;
    }
  }
}
