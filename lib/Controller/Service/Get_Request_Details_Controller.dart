// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Get_Refill_Request_Details_Service.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Cancel_Refill_Request_Service.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/models/Order_Item.dart';
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

  // ─── ✅✅✅ منطق إلغاء الطلب ─────────────────────────────────────
  final CancelRefillRequestService _cancelService =
      CancelRefillRequestService();

  final RxBool isCancelling = false.obs;

  /// ✅ هل يمكن إلغاء الطلب؟ (فقط بانتظار موافقة المستشفى)
  bool get canCancel =>
      details.value?.status == OrderStatus.pending_hospital_approval;

  /// ✅✅✅ إلغاء الطلب → POST /department-refills/requests/{id}/cancel
  Future<void> cancelRequest() async {
    if (isCancelling.value || !canCancel) return;

    isCancelling.value = true;
    try {
      final success = await _cancelService.cancelRequest(
        refillRequestId: requestId, // ✅ نستخدم الـ requestId الموجود أصلاً
      );

      if (success) {
        customSnackBar(
          title: 'تم الإلغاء',
          message: 'تم إلغاء الطلب بنجاح',
          color: constGreen,
          messageColor: Colors.white,
        );

        // ✅ إعادة جلب التفاصيل → الحالة تصبح cancelled → الزر يختفي تلقائياً
        await fetchDetails();
      } else {
        customSnackBar(
          title: 'فشل الإلغاء',
          message: _translateCancelError(_cancelService.lastError),
          color: constRed,
          messageColor: Colors.white,
        );
      }
    } finally {
      isCancelling.value = false;
    }
  }

  String _translateCancelError(String? msg) {
    if (msg == null || msg.isEmpty) {
      return 'تعذر إلغاء الطلب، حاول مرة أخرى';
    }
    if (msg.contains('not found')) return 'الطلب غير موجود';
    if (msg.contains('pending_hospital_approval') || msg.contains('cannot')) {
      return 'لا يمكن إلغاء الطلب في حالته الحالية';
    }
    return msg;
  }
}
