// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';

/// سيرفس تسجيل تسوية/إتلاف مادة
/// POST /inventory/adjustments
class PostInventoryAdjustmentService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  /// آخر رسالة خطأ من الباك اند
  String? lastError;

  Future<bool> createAdjustment({
    required String variantId,
    required String departmentId,
    required String batchId,
    required String adjustmentType,
    required int quantity,
    String stockCountSessionId = '',
    String notes = '',
  }) async {
    lastError = null;

    return _dispatcher.send<bool>(
      request: (token) async {
        // ✅✅✅ بناء الـ body ديناميكياً — الحقول الاختيارية تُضاف فقط إذا كانت ممتلئة
        final Map<String, dynamic> body = {
          'variantId': variantId,
          'departmentId': departmentId,
          'batchId': batchId,
          'adjustmentType': adjustmentType,
          'quantity': quantity,
        };

        // ✅ إضافة stockCountSessionId فقط إذا كان UUID صالح (غير فارغ)
        if (stockCountSessionId.trim().isNotEmpty) {
          body['stockCountSessionId'] = stockCountSessionId;
        }

        // ✅ إضافة notes فقط إذا كانت ممتلئة (اختياري)
        if (notes.trim().isNotEmpty) {
          body['notes'] = notes;
        }

        print('📤 Adjustment Body: ${jsonEncode(body)}');

        final response = await http.post(
          Uri.parse('$baseUrl/inventory/adjustments'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body),
        );

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
          print('✅ تم تسجيل التسوية بنجاح');
          return true;
        }

        lastError = jsonData['message']?.toString();
        print('❌ Adjustment | $lastError');
        return false;
      },

      fallback: false,
    );
  }
}
