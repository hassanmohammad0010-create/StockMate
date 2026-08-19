// lib/Service/Boss/Get_Disposal_Sale_Details_Service.dart
// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Disposal_Sale_Details_Model.dart';

/// سيرفس جلب تفاصيل طلب بيع إتلاف
/// GET /disposal/sales/{id}
class GetDisposalSaleDetailsService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<DisposalSaleDetails?> getDetails({
    required String disposalSaleRequestId,
  }) async {
    return _dispatcher.send<DisposalSaleDetails?>(
      request: (token) {
        final uri = Uri.parse('$baseUrl/disposal/sales/$disposalSaleRequestId');

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
          return DisposalSaleDetails.fromJson(
            jsonData['data'] as Map<String, dynamic>,
          );
        }
        print(
          '❌ Disposal Sale Details | success = false: ${jsonData['message']}',
        );
        return null;
      },
      fallback: null,
    );
  }
}
