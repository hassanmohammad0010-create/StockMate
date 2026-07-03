import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Service/Api_Error_Handler.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';

class RejectPurchaseRequestService {
  Future<bool> rejectPurchaseRequest({
    required int requestId,
    required String rejectionReason,
  }) async {
    final Uri url = Uri.parse(
      'https://grud-2y91.onrender.com/api/purchase-requests/$requestId/reject',
    );
    //TODO Tokens
    try {
      final response = await http
          .patch(
            url,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ',
            },
            body: jsonEncode({'rejection_reason': rejectionReason}),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        customSnackBar(
          title: 'تم الرفض',
          message: 'تم رفض طلب الشراء بنجاح',
          color: constGreen,
          messageColor: constLightGreen,
        );
        return true;
      }

      ApiErrorHandler.handleStatusCode(response.statusCode);
      return false;
    } catch (e) {
      ApiErrorHandler.handleException(e);
      return false;
    }
  }
}
