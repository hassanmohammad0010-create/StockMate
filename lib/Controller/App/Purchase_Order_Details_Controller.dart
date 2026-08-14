// lib/Controller/App/Purchase_Order_Details_Controller.dart
// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Boss/Get_Purchase_Request_Details_Service.dart';
import 'package:stock_mate_project/Service/Boss/Hospital_Approve_PurchaseRequest_Service.dart';
import 'package:stock_mate_project/Service/Boss/Hospital_Reject_PurshaseRequest_Service.dart';
import 'package:stock_mate_project/core/Function/show_Loading_Dialog.dart';
import 'package:stock_mate_project/core/models/Purchase_Request_Model.dart';

class PurchaseOrderDetailsController extends GetxController {
  PurchaseOrderDetailsController({required this.requestId});

  final String requestId;

  final GetPurchaseRequestDetailsService _detailsService =
      GetPurchaseRequestDetailsService();
  final HospitalApprovePurchaserequestService _approveService =
      HospitalApprovePurchaserequestService();
  final HospitalRejectPurshaserequestService _rejectService =
      HospitalRejectPurshaserequestService();

  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final Rx<PurchaseRequestDetails?> details = Rx<PurchaseRequestDetails?>(null);

  // ← نفس متغيرات RequestItemController
  final RxBool isApproved = false.obs;
  final RxBool isRejected = false.obs;
  final RxBool isApproving = false.obs;
  final RxBool isRejecting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    isLoading.value = true;
    hasError.value = false;

    final result = await _detailsService.getRequestDetails(
      requestId: requestId,
    );

    if (result == null) {
      hasError.value = true;
    } else {
      details.value = result;
    }

    isLoading.value = false;
  }

  Future<void> approveRequest() async {
    isApproving.value = true;
    showLoadingDialog(); // ← يظهر للمستخدم إنه الطلب رايح عالسيرفر

    final success = await _approveService.approveRequest(
      purchaseRequestId: requestId,
    );

    Get.back(); // ← يقفل ديالوج التحميل

    if (success) {
      isApproved.value = true;
      await fetchDetails(); // ← تحديث الحالة الحقيقية من السيرفر
    }

    isApproving.value = false;
  }

  Future<void> rejectRequest(String reason) async {
    isRejecting.value = true;
    showLoadingDialog(); // ← يظهر للمستخدم إنه الطلب رايح عالسيرفر

    final success = await _rejectService.rejectRequest(
      purchaseRequestId: requestId,
      rejectionReason: reason,
    );

    Get.back(); // ← يقفل ديالوج التحميل

    if (success) {
      isRejected.value = true;
      await fetchDetails(); // ← تحديث الحالة الحقيقية من السيرفر
    }

    isRejecting.value = false;
  }
}
