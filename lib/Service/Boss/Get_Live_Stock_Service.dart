// lib/Service/Get_Live_Stock_Service.dart
// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/New_MaterialItem.dart';

/// سيرفس جلب المخزون الحي لقسم معيّن
/// GET /inventory/department-inventory/live-stock
class GetLiveStockService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<LiveStockPageData?> getLiveStock({
    required String departmentId,
    int page = 1,
    int limit = 20,
  }) async {
    return _dispatcher.send<LiveStockPageData?>(
      request: (token) {
        final uri = Uri.parse(
          '$baseUrl/inventory/department-inventory/live-stock'
          '?departmentId=$departmentId&page=$page&limit=$limit',
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
          return LiveStockPageData.fromJson(
            jsonData['data'] as Map<String, dynamic>,
          );
        }

        print('❌ Live Stock | success = false: ${jsonData['message']}');
        return null;
      },

      fallback: null,
    );
  }
}
