// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Order_Item_Details.dart';

/// سيرفس جلب تفاصيل الطلب — Get Refill Request By Id
/// GET /department-refills/requests/{id}
class GetRefillRequestDetailsService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<OrderItemDetails?> getRequestDetails({
    required String requestId,
  }) async {
    return _dispatcher.send<OrderItemDetails?>(
      // ─── الطلب الفعلي: Dispatcher بيمرر التوكن جاهز ───
      request: (token) {
        final uri = Uri.parse(
          '$baseUrl/department-refills/requests/$requestId',
        );

        return http.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      },

      // ─── عند نجاح الطلب: نحوّل الـ body لـ RefillRequestDetails ───
      onSuccess: (body) {
        final jsonData = jsonDecode(body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          return OrderItemDetails.fromJson(
            jsonData['data'] as Map<String, dynamic>,
          );
        }

        print('❌ Request Details | success = false: ${jsonData['message']}');
        return null;
      },

      // ─── القيمة المرتجعة عند أي فشل ───
      fallback: null,
    );
  }
}