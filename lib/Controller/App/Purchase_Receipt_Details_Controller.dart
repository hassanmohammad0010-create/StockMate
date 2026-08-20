// lib/Controller/Service/Get_Purchase_Receipt_Details_Controller.dart
import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Boss/Get_Purchase_Receipt_Details_Service.dart';
import 'package:stock_mate_project/core/models/Purchase_Receipt_Details_Model.dart';

class PurchaseReceiptDetailsController extends GetxController {
  PurchaseReceiptDetailsController({required this.receiptId});

  final String receiptId;
  final GetPurchaseReceiptDetailsService _service =
      GetPurchaseReceiptDetailsService();

  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final Rxn<PurchaseReceiptDetails> details = Rxn<PurchaseReceiptDetails>();

  @override
  void onInit() {
    super.onInit();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    isLoading.value = true;
    hasError.value = false;

    final result = await _service.getReceiptDetails(receiptId: receiptId);

    details.value = result;
    hasError.value = result == null;
    isLoading.value = false;
  }
}
