// lib/Controller/App/Get_Disposal_Sale_Details_Controller.dart
import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Boss/Get_Disposal_Sale_Details_Service.dart';
import 'package:stock_mate_project/core/models/Disposal_Sale_Details_Model.dart';

class GetDisposalSaleDetailsController extends GetxController {
  GetDisposalSaleDetailsController({required this.disposalSaleRequestId});

  final String disposalSaleRequestId;
  final GetDisposalSaleDetailsService _service =
      GetDisposalSaleDetailsService();

  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final Rxn<DisposalSaleDetails> details = Rxn<DisposalSaleDetails>();

  @override
  void onInit() {
    super.onInit();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    isLoading.value = true;
    hasError.value = false;

    final result = await _service.getDetails(
      disposalSaleRequestId: disposalSaleRequestId,
    );

    details.value = result;
    hasError.value = result == null;
    isLoading.value = false;
  }
}
