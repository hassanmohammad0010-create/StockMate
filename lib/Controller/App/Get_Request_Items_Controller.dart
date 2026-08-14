// lib/Controller/Service/Request_Details_Controller.dart
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Service/Boss/Hospital_Approve_RefillRequest_Service.dart';
import 'package:stock_mate_project/Service/Boss/Hospital_Reject_RefillRequest_Service.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Get_Refill_Request_Details_Service.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/Function/show_Loading_Dialog.dart';
import 'package:stock_mate_project/core/models/Order_Item_Details.dart';

class RequestItemController extends GetxController {
  RequestItemController({required this.requestId});

  final String requestId;
  final GetRefillRequestDetailsService _service =
      GetRefillRequestDetailsService();
  final HospitalApproveRefillRequestService _approveService =
      HospitalApproveRefillRequestService();
  final HospitalRejectRefillRequestService _rejectService =
      HospitalRejectRefillRequestService();

  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final Rxn<OrderItemDetails> details = Rxn<OrderItemDetails>();

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

    final result = await _service.getRequestDetails(requestId: requestId);

    details.value = result;
    hasError.value = result == null;
    isLoading.value = false;
  }

  /// الموافقة على الطلب من طرف المستشفى
  Future<void> approveRequest() async {
    if (isApproving.value) return;

    isApproving.value = true;
    showLoadingDialog();

    final success = await _approveService.approveRequest(
      refillRequestId: requestId,
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
    }
  }

  /// رفض الطلب من طرف المستشفى
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
      refillRequestId: requestId,
      rejectionReason: rejectionReason.trim(),
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
    }
  }
}
