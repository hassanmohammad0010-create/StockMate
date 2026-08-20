// lib/Service/Boss/Approve_Disposal_Sale_Service.dart
// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';

/// سيرفس الموافقة على طلب بيع إتلاف
/// POST /disposal/sales/{disposalSaleRequestId}/approve
class ApproveDisposalSaleService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<bool> approveRequest({required String disposalSaleRequestId}) async {
    return _dispatcher.send<bool>(
      request: (token) {
        final uri = Uri.parse(
          '$baseUrl/disposal/sales/$disposalSaleRequestId/approve',
        );

        return http.post(
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
        return jsonData['success'] == true;
      },

      fallback: false,
    );
  }
}
