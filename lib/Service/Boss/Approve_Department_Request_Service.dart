import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/models/Request_Model.dart';

class ApproveDepartmentRequestService {
  Future<bool> approveRequest(int requestId) async {
    final Uri url = Uri.parse(
      'https://grud-2y91.onrender.com/api/request-orders/$requestId/approve',
    );
    //TODO
    //TOken
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
          message: 'تمت الموافقة على الطلب بنجاح',
          color: constGreen, // أو أي لون نجاح عندك
          messageColor: constLightGreen,
        );
        return true;
      }

      _showErrorByStatusCode(response.statusCode);
      return false;
    } on SocketException {
      customSnackBar(
        title: 'حدث خطأ',
        message: 'لا يوجد اتصال بالإنترنت، تحقق من الشبكة',
        color: constRed,
        messageColor: constLightRed,
      );
      return false;
    } on TimeoutException {
      customSnackBar(
        title: 'انتهت المهلة',
        message: 'الخادم لا يستجيب، حاول لاحقاً',
        color: constRed,
        messageColor: constLightRed,
      );
      return false;
    } catch (e) {
      debugPrint('approveRequest error: $e');
      customSnackBar(
        title: 'حدث خطأ',
        message: 'الرجاء المحاولة لاحقاً',
        color: constRed,
        messageColor: constLightRed,
      );
      return false;
    }
  }

  void _showErrorByStatusCode(int statusCode) {
    if (statusCode == 401 || statusCode == 403) {
      customSnackBar(
        title: 'غير مصرح',
        message: 'ليس لديك صلاحية للموافقة على هذا الطلب',
        color: constRed,
        messageColor: constLightRed,
      );
    } else if (statusCode == 404) {
      customSnackBar(
        title: 'غير موجود',
        message: 'الطلب غير موجود',
        color: constRed,
        messageColor: constLightRed,
      );
    } else {
      customSnackBar(
        title: 'حدث خطأ',
        message: 'فشلت عملية الموافقة، حاول لاحقاً',
        color: constRed,
        messageColor: constLightRed,
      );
    }
  }
}
