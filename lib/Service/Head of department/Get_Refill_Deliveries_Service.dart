// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Refill_Delivery_Model.dart';

/// سيرفس جلب سجل التسليمات (الطلبات الموافق عليها)
/// GET /department-refills/deliveries?page=1&limit=20
class GetRefillDeliveriesService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<RefillDeliveryPageData?> getDeliveries({
    int page = 1,
    int limit = 20,
  }) async {
    return _dispatcher.send<RefillDeliveryPageData?>(
      request: (token) {
        final uri = Uri.parse(
          '$baseUrl/department-refills/deliveries'
          '?page=$page'
          '&limit=$limit',
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

      onSuccess: (body) {
        final jsonData = jsonDecode(body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          return RefillDeliveryPageData.fromJson(
            jsonData['data'] as Map<String, dynamic>,
          );
        }

        print('❌ Refill Deliveries | ${jsonData['message']}');
        return null;
      },

      fallback: null,
    );
  }
}