// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';

/// عنصر دواء داخل طلب الصرف
class DispenseItemInput {
  final String prescriptionItemId;
  final int quantity;

  const DispenseItemInput({
    required this.prescriptionItemId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
    'prescriptionItemId': prescriptionItemId,
    'quantity': quantity,
  };
}

/// سيرفس صرف الوصفة
/// POST /pharmacy/dispensing
class DispensePrescriptionService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  /// ✅✅✅ آخر رسالة خطأ وصلت من الباك اند
  String? lastError;

  Future<bool> dispense({
    required String prescriptionId,
    required List<DispenseItemInput> items,
    String notes = '',
  }) async {
    lastError = null;

    return _dispatcher.send<bool>(
      request: (token) async {
        final response = await http.post(
          Uri.parse('$baseUrl/pharmacy/dispensing'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'prescriptionId': prescriptionId,
            'items': items.map((e) => e.toJson()).toList(),
            'notes': notes,
          }),
        );

        // ✅✅✅ التقاط رسالة الخطأ من أي استجابة غير ناجحة
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
          print('✅ تم صرف الوصفة: $prescriptionId');
          return true;
        }

        lastError = jsonData['message']?.toString();
        print('❌ Dispense | $lastError');
        return false;
      },

      fallback: false,
    );
  }
}
