// lib/Service/Get_Inventory_Movement_Report_Service.dart
// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Inventory_Movement_Report_Model.dart';

/// سيرفس جلب تقرير حركة المخزون
/// GET /reports/inventory-movement
class GetInventoryMovementReportService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<InventoryMovementReport?> getReport({
    required String from,
    required String to,
    int page = 1,
    int limit = 20,
    String? departmentId,
    String? variantId,
    String? transactionType,
    String? groupBy, // ← صار اختياري، بدون قيمة افتراضية
  }) async {
    return _dispatcher.send<InventoryMovementReport?>(
      request: (token) {
        final queryParams = <String, String>{
          'page': page.toString(),
          'limit': limit.toString(),
          'from': from,
          'to': to,
        };

        if (departmentId != null) queryParams['departmentId'] = departmentId;
        if (variantId != null) queryParams['variantId'] = variantId;
        if (transactionType != null) {
          queryParams['transactionType'] = transactionType;
        }
        // ← نضيفها فقط لو المستخدم فعلاً بعتها
        if (groupBy != null) queryParams['groupBy'] = groupBy;

        final uri = Uri.parse(
          '$baseUrl/reports/inventory-movement',
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
          return InventoryMovementReport.fromJson(
            jsonData['data'] as Map<String, dynamic>,
          );
        }
        print(
          '❌ Inventory Movement Report | success = false: ${jsonData['message']}',
        );
        return null;
      },
      fallback: null,
    );
  }

  /// ✅ يجيب أول صفحة، وبعدين كل الصفحات الباقية، ويرجّع تقرير واحد
  /// فيه كل الحركات جوا rows.items (مفيد لتصدير Excel كامل)
  Future<InventoryMovementReport?> getFullReport({
    required String from,
    required String to,
    String? departmentId,
    String? variantId,
    String? transactionType,
    String? groupBy, // ← صار اختياري هون كمان
    int pageSize = 100,
  }) async {
    final firstPage = await getReport(
      from: from,
      to: to,
      page: 1,
      limit: pageSize,
      departmentId: departmentId,
      variantId: variantId,
      transactionType: transactionType,
      groupBy: groupBy,
    );

    if (firstPage == null) return null;

    final allItems = [...firstPage.rows.items];
    final totalPages = firstPage.rows.totalPages;

    for (int p = 2; p <= totalPages; p++) {
      final nextPage = await getReport(
        from: from,
        to: to,
        page: p,
        limit: pageSize,
        departmentId: departmentId,
        variantId: variantId,
        transactionType: transactionType,
        groupBy: groupBy,
      );
      if (nextPage != null) {
        allItems.addAll(nextPage.rows.items);
      }
    }

    return InventoryMovementReport(
      summary: firstPage.summary,
      byDepartment: firstPage.byDepartment,
      series: firstPage.series,
      rows: MovementRowsPageData(
        items: allItems,
        total: firstPage.rows.total,
        page: 1,
        limit: allItems.length,
        totalPages: 1,
      ),
      groupBy: firstPage.groupBy,
    );
  }
}
