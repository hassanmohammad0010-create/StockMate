// lib/Service/Boss/Manager_Reject_Purchase_Request_Service.dart
// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';

/// سيرفس رفض المدير لطلب شراء
/// POST /purchasing/requests/{purchaseRequestId}/reject
class ManagerRejectPurchaseRequestService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<bool> rejectRequest({
    required String purchaseRequestId,
    required String reason,
  }) async {
    return _dispatcher.send<bool>(
      request: (token) {
        final uri = Uri.parse(
          '$baseUrl/purchasing/requests/$purchaseRequestId/reject',
        );

        return http.post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'reason': reason}),
        );
      },

      onSuccess: (body) {
        final jsonData = jsonDecode(body);
        return jsonData['success'] == true;
      },

      fallback: false,
    );
  }
}
