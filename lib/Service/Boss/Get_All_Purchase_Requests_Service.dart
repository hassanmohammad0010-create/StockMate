// lib/Service/Purchasing/Get_Purchase_Requests_List_Service.dart
// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Purchase_Request_Model.dart';

/// سيرفس جلب قائمة طلبات الشراء
/// GET /purchasing/requests
class GetPurchaseRequestsListService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<PurchaseRequestsPageData?> getRequests({
    int page = 1,
    int limit = 20,
  }) async {
    return _dispatcher.send<PurchaseRequestsPageData?>(
      request: (token) {
        final uri = Uri.parse(
          '$baseUrl/purchasing/requests?page=$page&limit=$limit',
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
          return PurchaseRequestsPageData.fromJson(
            jsonData['data'] as Map<String, dynamic>,
          );
        }

        print(
          '❌ List Purchase Requests | success = false: ${jsonData['message']}',
        );
        return null;
      },

      fallback: null,
    );
  }
}
