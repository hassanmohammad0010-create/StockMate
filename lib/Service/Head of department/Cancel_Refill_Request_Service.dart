// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';

/// سيرفس إلغاء طلب إعادة التعبئة
/// POST /department-refills/requests/{refillRequestId}/cancel
class CancelRefillRequestService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  /// ✅ آخر رسالة خطأ من الباك اند
  String? lastError;

  Future<bool> cancelRequest({required String refillRequestId}) async {
    lastError = null;

    return _dispatcher.send<bool>(
      request: (token) async {
        final response = await http.post(
          Uri.parse(
            '$baseUrl/department-refills/requests/$refillRequestId/cancel',
          ),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        // ✅ التقاط رسالة الخطأ
        if (response.statusCode != 200) {
          try {
            final json = jsonDecode(response.body);
            lastError = json['message']?.toString();
          } catch (_) {}
        }

        return response;
      },

      onSuccess: (body) {
        final jsonData = jsonDecode(body);

        if (jsonData['success'] == true) {
          print('✅ تم إلغاء الطلب: $refillRequestId');
          return true;
        }

        lastError = jsonData['message']?.toString();
        print('❌ Cancel Refill | $lastError');
        return false;
      },

      fallback: false,
    );
  }
}