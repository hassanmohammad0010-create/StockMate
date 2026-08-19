// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';

/// عنصر مادة داخل طلب الاستهلاك
class ConsumptionItemInput {
  final String variantId;
  final int quantity;

  const ConsumptionItemInput({
    required this.variantId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        'variantId': variantId,
        'quantity': quantity,
      };
}

/// سيرفس تسجيل الاستهلاك اليومي (تأكيد السلة)
/// POST /inventory/consumption
class RecordConsumptionService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  /// ✅ آخر رسالة خطأ من الباك اند
  String? lastError;

  Future<bool> recordConsumption({
    required String departmentId,
    required List<ConsumptionItemInput> items,
    String notes = '',
  }) async {
    lastError = null;

    return _dispatcher.send<bool>(
      request: (token) async {
        final body = {
          'departmentId': departmentId,
          'items': items.map((e) => e.toJson()).toList(),
          'notes': notes,
        };

        print('📤 Consumption Body: ${jsonEncode(body)}');

        final response = await http.post(
          Uri.parse('$baseUrl/inventory/consumption'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body),
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
          print('✅ تم تسجيل الاستهلاك بنجاح');
          return true;
        }

        lastError = jsonData['message']?.toString();
        print('❌ Consumption | $lastError');
        return false;
      },

      fallback: false,
    );
  }
}