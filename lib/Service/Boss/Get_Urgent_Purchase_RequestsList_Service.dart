// lib/Service/Purchasing/Get_Urgent_Purchase_Requests_List_Service.dart
// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Purchase_Request_Model.dart';

/// سيرفس جلب طلبات الشراء مع فلترة بالحالة والأولوية
/// GET /purchasing/requests?page=1&limit=20&status={status}&priority={priority}
class GetUrgentPurchaseRequestsListService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<PurchaseRequestsPageData?> getUrgentRequests({
    int page = 1,
    int limit = 20,
    required String status,
    String? priority, // ✅ صار اختياري
  }) async {
    return _dispatcher.send<PurchaseRequestsPageData?>(
      request: (token) {
        final Map<String, String> queryParams = {
          'page': page.toString(),
          'limit': limit.toString(),
          'status': status,
        };

        if (priority != null && priority.isNotEmpty) {
          queryParams['priority'] = priority; // ✅ يضاف بس لو موجود
        }

        final uri = Uri.parse(
          '$baseUrl/purchasing/requests',
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
          return PurchaseRequestsPageData.fromJson(
            jsonData['data'] as Map<String, dynamic>,
          );
        }
        return null;
      },
      fallback: null,
    );
  }
}
