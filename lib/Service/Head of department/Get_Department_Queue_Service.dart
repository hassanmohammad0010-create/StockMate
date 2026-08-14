// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Department_Queue_Entry.dart';

/// سيرفس جلب طابور القسم — Department Queue
/// GET /department-queue?page=1&limit=20&departmentId={id}&status=waiting&search=
class GetDepartmentQueueService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<DepartmentQueuePageData?> getDepartmentQueue({
    required String departmentId,
    int page = 1,
    int limit = 20,
    String status = 'waiting', // ✅ فقط المنتظرون افتراضياً
    String search = '',        // ✅ جاهز للبحث لاحقاً
  }) async {
    return _dispatcher.send<DepartmentQueuePageData?>(
      request: (token) {
        final uri = Uri.parse(
          '$baseUrl/department-queue'
          '?page=$page'
          '&limit=$limit'
          '&departmentId=$departmentId'
          '&status=$status'
          '&search=${Uri.encodeQueryComponent(search)}',
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
          return DepartmentQueuePageData.fromJson(
            jsonData['data'] as Map<String, dynamic>,
          );
        }

        print('❌ Department Queue | success = false: ${jsonData['message']}');
        return null;
      },

      fallback: null,
    );
  }
}