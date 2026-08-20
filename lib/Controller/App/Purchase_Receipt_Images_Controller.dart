// lib/Controller/Service/Get_Purchase_Receipt_Images_Controller.dart
import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Boss/Get_Purchase_Receipt_Images_Service.dart';
import 'package:stock_mate_project/core/models/Purchase_Receipt_Image_Url.dart';

class PurchaseReceiptImagesController extends GetxController {
  PurchaseReceiptImagesController({required this.receiptId});

  final String receiptId;
  final GetPurchaseReceiptImagesService _service =
      GetPurchaseReceiptImagesService();

  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxList<PurchaseReceiptImageUrl> images =
      <PurchaseReceiptImageUrl>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchImages();
  }

  Future<void> fetchImages() async {
    isLoading.value = true;
    hasError.value = false;

    final result = await _service.getImages(receiptId: receiptId);

    if (result != null) {
      images.assignAll(result);
    }
    hasError.value = result == null;

    isLoading.value = false;
  }
}
