// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';

/// سيرفس تعديل بيانات المستخدم (بما فيها ربط القسم)
/// PATCH /users/{userId}
class UpdateUserService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<bool> updateUser({
    required String userId,
    String? fullName,
    String? email,
    String? departmentId,
    String? specialty,
  }) async {
    return _dispatcher.send<bool>(
      request: (token) {
        final uri = Uri.parse('$baseUrl/users/$userId');

        // ✅ نبني الـ body بس بالحقول اللي اتبعتت فعليًا
        final Map<String, dynamic> body = {};
        if (fullName != null) body['fullName'] = fullName;
        if (email != null) body['email'] = email;
        if (departmentId != null) body['departmentId'] = departmentId;
        if (specialty != null) body['specialty'] = specialty;

        return http.patch(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body),
        );
      },

      onSuccess: (responseBody) {
        final jsonData = jsonDecode(responseBody);
        return jsonData['success'] == true;
      },

      fallback: false,
    );
  }
}
