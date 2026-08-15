// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/User_Model.dart';

/// سيرفس جلب رؤساء الأقسام (department_manager) المتاحين
/// GET /users?roleId=...&status=active&availableAsManager=true
class GetDepartmentHeaderWithoutPostionService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  /// roleId ثابت لدور "department_manager" — مطابق للقيمة الفعلية في السيرفر
  static const String _departmentManagerRoleId =
      '429973d2-106f-4a30-a64c-bfbc39614527';

  final Dispatcher _dispatcher = Dispatcher();

  Future<UsersPageData?> getDepartmentHeaderWithoutPostion({
    int page = 1,
    int limit = 20,
  }) async {
    return _dispatcher.send<UsersPageData?>(
      request: (token) {
        final uri = Uri.parse(
          '$baseUrl/users'
          '?page=$page'
          '&limit=$limit'
          '&roleId=$_departmentManagerRoleId'
          '&status=active'
          '&availableAsManager=true',
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
          return UsersPageData.fromJson(
            jsonData['data'] as Map<String, dynamic>,
          );
        }

        print(
          '❌ Get Department Header Without Postion | success = false: ${jsonData['message']}',
        );
        return null;
      },

      fallback: null,
    );
  }
}
