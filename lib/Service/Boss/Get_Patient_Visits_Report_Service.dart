// lib/Service/Boss/Get_Patient_Visits_Report_Service.dart
// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Patient_Visits_Report_Model.dart';

/// سيرفس جلب تقرير زيارات المرضى
/// GET /reports/patient-visits
class GetPatientVisitsReportService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<PatientVisitsReport?> getReport({
    required String from,
    required String to,
    int page = 1,
    int limit = 20,
    String? departmentId,
    String? doctorId,
    String? patientId,
    String? groupBy, // ← اختياري، نفس نمط تقرير المخزون
  }) async {
    return _dispatcher.send<PatientVisitsReport?>(
      request: (token) {
        final queryParams = <String, String>{
          'page': page.toString(),
          'limit': limit.toString(),
          'from': from,
          'to': to,
          'status': 'completed', // ← ثابتة دايماً
        };

        if (departmentId != null) queryParams['departmentId'] = departmentId;
        if (doctorId != null) queryParams['doctorId'] = doctorId;
        if (patientId != null) queryParams['patientId'] = patientId;
        if (groupBy != null) queryParams['groupBy'] = groupBy;

        final uri = Uri.parse(
          '$baseUrl/reports/patient-visits',
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
          return PatientVisitsReport.fromJson(
            jsonData['data'] as Map<String, dynamic>,
          );
        }
        print(
          '❌ Patient Visits Report | success = false: ${jsonData['message']}',
        );
        return null;
      },
      fallback: null,
    );
  }

  /// ✅ يجيب أول صفحة، وبعدين كل الصفحات الباقية، ويرجّع تقرير واحد
  /// فيه كل الزيارات جوا rows.items
  Future<PatientVisitsReport?> getFullReport({
    required String from,
    required String to,
    String? departmentId,
    String? doctorId,
    String? patientId,
    String? groupBy,
    int pageSize = 100,
  }) async {
    final firstPage = await getReport(
      from: from,
      to: to,
      page: 1,
      limit: pageSize,
      departmentId: departmentId,
      doctorId: doctorId,
      patientId: patientId,
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
        doctorId: doctorId,
        patientId: patientId,
        groupBy: groupBy,
      );
      if (nextPage != null) {
        allItems.addAll(nextPage.rows.items);
      }
    }

    return PatientVisitsReport(
      summary: firstPage.summary,
      byDepartment: firstPage.byDepartment,
      series: firstPage.series,
      rows: VisitRowsPageData(
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
