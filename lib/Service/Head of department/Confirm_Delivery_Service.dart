// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';

/// عنصر صنف داخل طلب تأكيد الاستلام
class ConfirmDeliveryItemInput {
  final String deliveryItemId;
  final int receivedQuantity;

  const ConfirmDeliveryItemInput({
    required this.deliveryItemId,
    required this.receivedQuantity,
  });

  Map<String, dynamic> toJson() => {
        'deliveryItemId': deliveryItemId,
        'receivedQuantity': receivedQuantity,
      };
}

/// سيرفس تأكيد استلام التسليم
/// POST /department-refills/deliveries/{deliveryId}/confirm
class ConfirmDeliveryService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  /// ✅ آخر رسالة خطأ من الباك اند
  String? lastError;

  Future<bool> confirmDelivery({
    required String deliveryId,
    required List<ConfirmDeliveryItemInput> items,
    String notes = '',
  }) async {
    lastError = null;

    return _dispatcher.send<bool>(
      request: (token) async {
        // ✅ notes تُضاف فقط إذا كانت ممتلئة
        final Map<String, dynamic> body = {
          'items': items.map((e) => e.toJson()).toList(),
        };
        if (notes.trim().isNotEmpty) {
          body['notes'] = notes;
        }

        print('📤 Confirm Body: ${jsonEncode(body)}');

        final response = await http.post(
          Uri.parse('$baseUrl/department-refills/deliveries/$deliveryId/confirm'),
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
          print('✅ تم تأكيد الاستلام بنجاح');
          return true;
        }

        lastError = jsonData['message']?.toString();
        print('❌ Confirm Delivery | $lastError');
        return false;
      },

      fallback: false,
    );
  }
}