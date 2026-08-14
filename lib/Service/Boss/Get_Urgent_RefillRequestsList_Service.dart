// lib/Service/Get_Urgent_Refill_Requests_List_Service.dart
// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Order_Item.dart';

/// سيرفس جلب الطلبات المستعجلة وبانتظار موافقة المستشفى فقط
/// GET /department-refills/requests?status=pending_hospital_approval&priority=urgent
class GetUrgentRefillRequestsListService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  /// ✅ جلب الطلبات المستعجلة لقسم معيّن
  Future<RefillRequestsPageData?> getUrgentRequests({
    required String departmentId,
    int page = 1,
    int limit = 20,
  }) async {
    return _dispatcher.send<RefillRequestsPageData?>(
      request: (token) {
        final uri = Uri.parse(
          '$baseUrl/department-refills/requests'
          '?status=pending_hospital_approval'
          '&priority=urgent'
          '&page=$page'
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
      onSuccess: (body) => _parseResponse(body, 'getUrgentRequests'),
      fallback: null,
    );
  }

  /// ✅ جلب كل الطلبات المستعجلة بدون تحديد قسم (للمستودع/البوس)
  Future<RefillRequestsPageData?> getAllUrgentRequests({
    int page = 1,
    int limit = 20,
  }) async {
    return _dispatcher.send<RefillRequestsPageData?>(
      request: (token) {
        final uri = Uri.parse(
          '$baseUrl/department-refills/requests'
          '?status=pending_hospital_approval'
          '&priority=urgent'
          '&page=$page'
          '&limit=$limit',
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
      onSuccess: (body) => _parseResponse(body, 'getAllUrgentRequests'),
      fallback: null,
    );
  }

  RefillRequestsPageData? _parseResponse(String body, String from) {
    final jsonData = jsonDecode(body);

    if (jsonData['success'] == true && jsonData['data'] != null) {
      return RefillRequestsPageData.fromJson(
        jsonData['data'] as Map<String, dynamic>,
      );
    }

    print('❌ $from | success = false: ${jsonData['message']}');
    return null;
  }
}
