// lib/Controller/App/Get_Disposal_Sale_Details_Controller.dart
import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Boss/Approve_Disposal_Sale_Service.dart';
import 'package:stock_mate_project/Service/Boss/Get_Disposal_Sale_Details_Service.dart';
import 'package:stock_mate_project/Service/Boss/Reject_Disposal_Sale_Service.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/Function/show_Loading_Dialog.dart';
import 'package:stock_mate_project/core/models/Disposal_Sale_Details_Model.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class GetDisposalSaleDetailsController extends GetxController {
  GetDisposalSaleDetailsController({required this.disposalSaleRequestId});

  final String disposalSaleRequestId;
  final GetDisposalSaleDetailsService _service =
      GetDisposalSaleDetailsService();
  final ApproveDisposalSaleService _approveService =
      ApproveDisposalSaleService();
  final RejectDisposalSaleService _rejectService = RejectDisposalSaleService();

  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final Rxn<DisposalSaleDetails> details = Rxn<DisposalSaleDetails>();

  final RxBool isApproving = false.obs;
  final RxBool isApproved = false.obs;

  final RxBool isRejecting = false.obs;
  final RxBool isRejected = false.obs;

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

  Future<void> approveRequest() async {
    if (isApproving.value) return;

    isApproving.value = true;
    showLoadingDialog();

    final success = await _approveService.approveRequest(
      disposalSaleRequestId: disposalSaleRequestId,
    );

    hideLoadingDialog();
    isApproving.value = false;

    if (success) {
      isApproved.value = true;

      customSnackBar(
        title: 'تمت الموافقة',
        message: 'تمت الموافقة بنجاح',
        color: constGreen,
        messageColor: constLightGreen,
      );

      await fetchDetails();
    } else {
      customSnackBar(
        title: 'خطأ',
        message: 'تعذر تنفيذ الموافقة، حاول مجددًا',
        color: constRed,
        messageColor: constLightRed,
      );
    }
  }

  Future<void> rejectRequest(String rejectionReason) async {
    if (isRejecting.value) return;
    if (rejectionReason.trim().isEmpty) {
      customSnackBar(
        title: 'خطأ',
        message: 'الرجاء إدخال سبب الرفض',
        color: constRed,
        messageColor: constLightRed,
      );
      return;
    }

    isRejecting.value = true;
    showLoadingDialog();

    final success = await _rejectService.rejectRequest(
      disposalSaleRequestId: disposalSaleRequestId,
      reason: rejectionReason.trim(),
    );

    hideLoadingDialog();
    isRejecting.value = false;

    if (success) {
      isRejected.value = true;

      customSnackBar(
        title: 'تم الرفض',
        message: 'تم رفض الطلب بنجاح',
        color: constGreen,
        messageColor: constLightGreen,
      );

      await fetchDetails();
    } else {
      customSnackBar(
        title: 'خطأ',
        message: 'تعذر تنفيذ الرفض، حاول مجددًا',
        color: constRed,
        messageColor: constLightRed,
      );
    }
  }
}
