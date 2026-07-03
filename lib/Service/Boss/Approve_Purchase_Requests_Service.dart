import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Service/Api_Error_Handler.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';

class ApprovePurchaseRequestService {
  Future<bool> approvePurchaseRequest({required int requestId}) async {
    final Uri url = Uri.parse(
      'https://grud-2y91.onrender.com/api/purchase-requests/$requestId/approve',
    );
    //TODO Token
    try {
      final response = await http
          .patch(
            url,
            headers: {'Accept': 'application/json', 'Authorization': 'Bearer '},
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        customSnackBar(
          title: 'تمت الموافقة',
          message: 'تمت الموافقة على طلب الشراء بنجاح',
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
