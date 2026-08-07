// lib/Controller/Service/Request_Details_Controller.dart
import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Get_Refill_Request_Details_Service.dart';
import 'package:stock_mate_project/core/models/Order_Item_Details.dart';

class RequestItemController extends GetxController {
  RequestItemController({required this.requestId});

  final String requestId;
  final GetRefillRequestDetailsService _service =
      GetRefillRequestDetailsService();

  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final Rxn<OrderItemDetails> details = Rxn<OrderItemDetails>();

  @override
  void onInit() {
    super.onInit();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    isLoading.value = true;
    hasError.value = false;

    final result = await _service.getRequestDetails(requestId: requestId);

    details.value = result;
    hasError.value = result == null;
    isLoading.value = false;
  }
}
