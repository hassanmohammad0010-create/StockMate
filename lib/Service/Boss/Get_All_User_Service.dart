// lib/Service/Get_Users_List_Service.dart
// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/User_Model.dart';

/// سيرفس جلب قائمة المستخدمين
/// GET /users
class GetUsersListService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<UsersPageData?> getUsers({int page = 1, int limit = 20}) async {
    return _dispatcher.send<UsersPageData?>(
      request: (token) {
        final uri = Uri.parse('$baseUrl/users?page=$page&limit=$limit');

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

        print('❌ List Users | success = false: ${jsonData['message']}');
        return null;
      },

      fallback: null,
    );
  }
}
