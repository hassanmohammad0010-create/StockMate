import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';

class GetMedicineItemsService {
  Future<List<MaterialItem>> getMedicineItemsService() async {
    final Uri url = Uri.parse(
      'https://grud-2y91.onrender.com/api/warehouse/products/medicine',
    );

    try {
      final response = await http
          .get(
            url,
            headers: {
              'Accept': 'application/json',
              'Authorization':
                  'Bearer 1|SfcbNRti68N8PRTHP9VhxoTuFN5KgebevoCTRUVj28a9a130',
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
      debugPrint('getMedicineItemsService error: $e');
      customSnackBar(
        title: 'حدث خطأ',
        message: 'الرجاء المحاولة لاحقاً',
        color: constRed,
        messageColor: constLightRed,
      );
      return [];
    }
  }

  List<MaterialItem> _parseResponse(String body) {
    final dynamic jsonBody = jsonDecode(body);

    if (jsonBody is! Map<String, dynamic> || jsonBody['data'] is! List) {
      return [];
    }

    final List<dynamic> data = jsonBody['data'];
    final List<MaterialItem> items = [];

    for (final item in data) {
      try {
        if (item is Map<String, dynamic>) {
          items.add(MaterialItem.fromJson(item));
        }
      } catch (_) {
        continue;
      }
    }

    return items;
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
        message: 'فشل تحميل البيانات، حاول لاحقاً',
        color: constRed,
        messageColor: constLightRed,
      );
    }
  }
}
