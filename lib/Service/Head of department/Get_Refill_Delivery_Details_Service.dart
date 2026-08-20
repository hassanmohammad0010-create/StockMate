// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Refill_Delivery_Details_Model.dart';

/// سيرفس جلب تفاصيل التسليم
/// GET /department-refills/deliveries/{deliveryId}
class GetRefillDeliveryDetailsService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<RefillDeliveryDetails?> getDeliveryDetails({
    required String deliveryId,
  }) async {
    return _dispatcher.send<RefillDeliveryDetails?>(
      request: (token) {
        return http.get(
          Uri.parse('$baseUrl/department-refills/deliveries/$deliveryId'),
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
          return RefillDeliveryDetails.fromJson(
            jsonData['data'] as Map<String, dynamic>,
          );
        }

        print('❌ Delivery Details | ${jsonData['message']}');
        return null;
      },

      fallback: null,
    );
  }
}