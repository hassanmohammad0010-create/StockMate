// lib/Service/Boss/Assign_Department_Manager_Service.dart
// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';

/// سيرفس ربط رئيس قسم بقسم معيّن
/// PATCH /departments/{departmentId}/manager
class AssignDepartmentManagerService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<bool> assignManager({
    required String departmentId,
    required String managerId,
  }) async {
    return _dispatcher.send<bool>(
      request: (token) {
        final uri = Uri.parse('$baseUrl/departments/$departmentId/manager');

        return http.patch(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'managerId': managerId}),
        );
      },

      onSuccess: (body) {
        final jsonData = jsonDecode(body);
        return jsonData['success'] == true;
      },

      fallback: false,
    );
  }
}
