// lib/Service/Boss/Get_Inventory_Adjustments_Service.dart
// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Adjustment_Type_Model.dart';

/// سيرفس جلب قائمة تسويات المخزون
/// GET /inventory/adjustments?page=1&limit=20
class GetInventoryAdjustmentsService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<AdjustmentsRowsPage?> getAdjustments({
    int page = 1,
    int limit = 20,
  }) async {
    return _dispatcher.send<AdjustmentsRowsPage?>(
      request: (token) {
        final uri = Uri.parse('$baseUrl/inventory/adjustments').replace(
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
          // ✅ الـ data هون شكلها مباشرة items/total/page/limit/totalPages
          // (مو AdjustmentsReport اللي فيه summary/byDepartment/series/rows)
          return AdjustmentsRowsPage.fromJson(
            jsonData['data'] as Map<String, dynamic>,
          );
        }

        print(
          '❌ Inventory Adjustments | success = false: ${jsonData['message']}',
        );
        return null;
      },

      fallback: null,
    );
  }
}
