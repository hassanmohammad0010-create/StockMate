import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/models/Request_Model.dart';

class RequestService {
  Future<List<RequestModel>> getAllDepartmentRequests() async {
    final Uri url = Uri.parse(
      'https://grud-2y91.onrender.com/api/get/department-requests',
    );

    try {
      final response = await http
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
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
        title: 'حدث خطأ',
        message: 'لا يوجد اتصال بالإنترنت، تحقق من الشبكة',
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
        title: 'حدث خطأ',
        message: 'حدث خطأ أثناء معالجة البيانات المستلمة',
        color: constRed,
        messageColor: constLightRed,
      );
      return [];
    } catch (e) {
      debugPrint('getAllDepartmentRequests error: $e');
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
    final dynamic jsonData = jsonDecode(body);

    if (jsonData is! Map<String, dynamic> || jsonData['data'] is! List) {
      return [];
    }

    final List<dynamic> data = jsonData['data'];
    final List<RequestModel> requests = [];

    for (final item in data) {
      try {
        if (item is Map<String, dynamic>) {
          requests.add(RequestModel.fromJson(item));
        }
      } catch (_) {
        continue; // تجاهل العنصر التالف بدل ما توقف كل القائمة
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
        message: 'فشل تحميل الطلبات، حاول لاحقاً',
        color: constRed,
        messageColor: constLightRed,
      );
    }
  }
}
