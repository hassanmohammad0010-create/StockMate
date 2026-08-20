// lib/Service/Boss/Get_Disposal_Sales_Service.dart
// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Disposal_Sales_Page_Data_Model.dart';

/// سيرفس جلب قائمة مبيعات الإتلاف
/// GET /disposal/sales
class GetDisposalSalesService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<DisposalSalesPageData?> getDisposalSales({
    int page = 1,
    int limit = 20,
  }) async {
    return _dispatcher.send<DisposalSalesPageData?>(
      request: (token) {
        final uri = Uri.parse('$baseUrl/disposal/sales').replace(
          queryParameters: {'page': page.toString(), 'limit': limit.toString()},
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
          return DisposalSalesPageData.fromJson(
            jsonData['data'] as Map<String, dynamic>,
          );
        }
        return null;
      },
      fallback: null,
    );
  }
}
