// lib/Service/Get_Inventory_Transactions_Service.dart
// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Inventory_Transactions_Page_Data.dart';

/// سيرفس جلب قائمة حركات المخزون التفصيلية
/// GET /inventory/transactions
class GetInventoryTransactionsService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<InventoryTransactionsPageData?> getTransactions({
    int page = 1,
    int limit = 20,
    String? departmentId,
    String? variantId,
    String? transactionType,
  }) async {
    return _dispatcher.send<InventoryTransactionsPageData?>(
      request: (token) {
        final queryParams = <String, String>{
          'page': page.toString(),
          'limit': limit.toString(),
        };

        if (departmentId != null) queryParams['departmentId'] = departmentId;
        if (variantId != null) queryParams['variantId'] = variantId;
        if (transactionType != null) {
          queryParams['transactionType'] = transactionType;
        }

        final uri = Uri.parse(
          '$baseUrl/inventory/transactions',
        ).replace(queryParameters: queryParams);

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
          return InventoryTransactionsPageData.fromJson(
            jsonData['data'] as Map<String, dynamic>,
          );
        }

        print(
          '❌ Inventory Transactions | success = false: ${jsonData['message']}',
        );
        return null;
      },

      fallback: null,
    );
  }
}
