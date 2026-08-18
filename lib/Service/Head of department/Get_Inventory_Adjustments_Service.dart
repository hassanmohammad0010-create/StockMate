// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Inventory_Adjustments_Model.dart';

/// سيرفس جلب سجل التسويات/الإتلاف
/// GET /inventory/adjustments?page=1&limit=20&departmentId={id}
class GetInventoryAdjustmentsService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<InventoryAdjustmentsPageData?> getAdjustments({
    required String departmentId,
    int page = 1,
    int limit = 20,
  }) async {
    return _dispatcher.send<InventoryAdjustmentsPageData?>(
      request: (token) {
        final uri = Uri.parse(
          '$baseUrl/inventory/adjustments'
          '?page=$page'
          '&limit=$limit'
          '&departmentId=$departmentId',
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
          return InventoryAdjustmentsPageData.fromJson(
            jsonData['data'] as Map<String, dynamic>,
          );
        }

        print('❌ Adjustments | ${jsonData['message']}');
        return null;
      },

      fallback: null,
    );
  }
}