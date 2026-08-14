// lib/Service/Get_Filtered_Departments_Service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Department_Model.dart';

/// سيرفس جلب الأقسام النشطة اللي بدون مدير
/// GET /departments?page=1&limit=20&isActive=true&hasManager=false
class GetFilteredDepartmentsService {
  static const String _baseUrl =
      'https://stock-mate-qb40.onrender.com/api/departments';

  static Future<List<DepartmentModel>> getFilteredDepartments({
    int page = 1,
    int limit = 20,
  }) async {
    return await Dispatcher().send<List<DepartmentModel>>(
      request: (token) {
        final uri = Uri.parse(_baseUrl).replace(
          queryParameters: {
            'page': page.toString(),
            'limit': limit.toString(),
            'isActive': 'true',
            'hasManager': 'false',
          },
        );

        return http.get(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );
      },
      onSuccess: (body) {
        final Map<String, dynamic> jsonBody = jsonDecode(body);
        final Map<String, dynamic> data =
            jsonBody['data'] as Map<String, dynamic>;
        final List<dynamic> items = data['items'] as List<dynamic>? ?? [];

        return items
            .map((e) => DepartmentModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      fallback: <DepartmentModel>[],
    );
  }
}
