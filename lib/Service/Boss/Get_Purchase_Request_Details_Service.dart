// lib/Service/Purchasing/Get_Purchase_Request_Details_Service.dart
// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Purchase_Request_Model.dart';

/// سيرفس جلب تفاصيل طلب شراء
/// GET /purchasing/requests/{id}
class GetPurchaseRequestDetailsService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<PurchaseRequestDetails?> getRequestDetails({
    required String requestId,
  }) async {
    return _dispatcher.send<PurchaseRequestDetails?>(
      request: (token) {
        final uri = Uri.parse('$baseUrl/purchasing/requests/$requestId');

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
          return PurchaseRequestDetails.fromJson(
            jsonData['data'] as Map<String, dynamic>,
          );
        }

        print(
          '❌ Purchase Request Details | success = false: ${jsonData['message']}',
        );
        return null;
      },

      fallback: null,
    );
  }
}
