// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/UserProfile_Model.dart';

/// سيرفس جلب ملف المستخدم الكامل مع الصلاحيات
/// GET /users/me
class GetMyProfileService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<UserProfile?> getMyProfile() async {
    return _dispatcher.send<UserProfile?>(
      request: (token) {
        return http.get(
          Uri.parse('$baseUrl/users/me'),
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
          return UserProfile.fromJson(
            jsonData['data'] as Map<String, dynamic>,
          );
        }

        print('❌ My Profile | ${jsonData['message']}');
        return null;
      },

      fallback: null,
    );
  }
}