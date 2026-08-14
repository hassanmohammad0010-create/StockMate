// lib/Service/Update_User_Status_Service.dart
// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';

/// سيرفس تغيير حالة المستخدم (تفعيل / تعطيل)
/// PATCH /users/{userId}/status
class UpdateUserStatusService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  /// [isActive] = true → "active" | false → "inactive"
  Future<bool> updateUserStatus({
    required String userId,
    required String status,
  }) async {
    return _dispatcher.send<bool>(
      request: (token) {
        final uri = Uri.parse('$baseUrl/users/$userId/status');

        return http.patch(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'status': status}),
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
