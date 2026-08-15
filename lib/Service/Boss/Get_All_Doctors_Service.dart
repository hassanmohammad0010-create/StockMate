// lib/Service/Get_All_Doctors_Service.dart
// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/User_Model.dart';

/// سيرفس جلب كل الأطباء المتاحين كمدراء أقسام
/// GET /users?roleId=...&status=active&availableAsManager=true
class GetAllDoctorsService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  /// roleId ثابت لدور "doctor" — مطابق للقيمة الفعلية في السيرفر
  static const String _doctorRoleId = 'c61d81be-06ea-4756-af60-ad705f7664a6';

  final Dispatcher _dispatcher = Dispatcher();

  Future<UsersPageData?> getAllDoctors({int page = 1, int limit = 20}) async {
    return _dispatcher.send<UsersPageData?>(
      request: (token) {
        final uri = Uri.parse(
          '$baseUrl/users'
          '?page=$page'
          '&limit=$limit'
          '&roleId=$_doctorRoleId'
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

        print('❌ Get All Doctors | success = false: ${jsonData['message']}');
        return null;
      },

      fallback: null,
    );
  }
}
