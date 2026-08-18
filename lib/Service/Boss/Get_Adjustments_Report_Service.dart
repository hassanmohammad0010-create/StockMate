// lib/Service/Get_Adjustments_Report_Service.dart
// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Adjustment_Type_Model.dart';

/// سيرفس تقرير التسويات — GET /reports/adjustments
class GetAdjustmentsReportService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  /// [from] و [to] بصيغة yyyy-MM-dd
  /// [departmentId], [variantId], [adjustmentType] فلاتر اختيارية
  /// [groupBy] القيمة الافتراضية "day"
  Future<AdjustmentsReport?> getReport({
    int page = 1,
    int limit = 20,
    String? from,
    String? to,
    String? departmentId,
    String? variantId,
    String? adjustmentType,
    String groupBy = 'day',
  }) async {
    return _dispatcher.send<AdjustmentsReport?>(
      request: (token) {
        final queryParams = {
          'page': page.toString(),
          'limit': limit.toString(),
          'groupBy': groupBy,
          if (from != null && from.isNotEmpty) 'from': from,
          if (to != null && to.isNotEmpty) 'to': to,
          if (departmentId != null && departmentId.isNotEmpty)
            'departmentId': departmentId,
          if (variantId != null && variantId.isNotEmpty) 'variantId': variantId,
          if (adjustmentType != null && adjustmentType.isNotEmpty)
            'adjustmentType': adjustmentType,
        };

        final uri = Uri.parse(
          '$baseUrl/reports/adjustments',
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
          return AdjustmentsReport.fromJson(
            jsonData['data'] as Map<String, dynamic>,
          );
        }

        print('❌ Adjustments Report | success = false: ${jsonData['message']}');
        return null;
      },
      fallback: null,
    );
  }
}
