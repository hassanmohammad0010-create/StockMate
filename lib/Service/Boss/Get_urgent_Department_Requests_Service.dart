import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/models/Request_Model.dart';

class GetUrgentDepartmentRequestsService {
  Future<List<RequestModel>> getUrgentDepartmentRequestsService() async {
    try {
      final http.Response response = await http
          .get(
            Uri.parse(
              'https://grud-2y91.onrender.com/api/request-orders/pending/urgent',
            ), //TODO
            headers: {
              'Accept': 'application/json',
              'Authorization':
                  'Bearer 23|RkmrnP7Yu8yUd9iDbJ2uboTmRU4ZoOj28XHRWGKI8dd678c7',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return _parseResponse(response.body);
      }

      _showErrorByStatusCode(response.statusCode);
      return [];
    } on SocketException {
      customSnackBar(
        title: 'لا يوجد اتصال',
        message: 'تأكد من اتصالك بالانترنت وحاول مرة أخرى',
        color: constRed,
        messageColor: constLightRed,
      );
      return [];
    } on TimeoutException {
      customSnackBar(
        title: 'انتهت المهلة',
        message: 'الخادم لا يستجيب، حاول لاحقاً',
        color: constRed,
        messageColor: constLightRed,
      );
      return [];
    } on FormatException {
      customSnackBar(
        title: 'خطأ في البيانات',
        message: 'حدث خطأ غير متوقع في استجابة الخادم',
        color: constRed,
        messageColor: constLightRed,
      );
      return [];
    } catch (e) {
      customSnackBar(
        title: 'حدث خطأ',
        message: 'الرجاء المحاولة لاحقاً',
        color: constRed,
        messageColor: constLightRed,
      );
      return [];
    }
  }

  List<RequestModel> _parseResponse(String body) {
    final dynamic jsonBody = jsonDecode(body);

    if (jsonBody is! Map<String, dynamic> || jsonBody['data'] is! List) {
      return [];
    }

    final List<dynamic> data = jsonBody['data'];
    final List<RequestModel> requests = [];

    for (final item in data) {
      try {
        if (item is Map<String, dynamic>) {
          requests.add(RequestModel.fromJson(item));
        }
      } catch (_) {
        // تجاهل العنصر التالف بدل ما توقف كل القائمة
        continue;
      }
    }

    return requests;
  }

  void _showErrorByStatusCode(int statusCode) {
    if (statusCode == 401 || statusCode == 403) {
      customSnackBar(
        title: 'انتهت الجلسة',
        message: 'الرجاء تسجيل الدخول من جديد',
        color: constRed,
        messageColor: constLightRed,
      );
    } else {
      customSnackBar(
        title: 'حدث خطأ',
        message: 'الرجاء التحقق من اتصالك بالانترنت والمحاولة لاحقاً',
        color: constRed,
        messageColor: constLightRed,
      );
    }
  }
}
