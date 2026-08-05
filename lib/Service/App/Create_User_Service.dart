// lib/Service/User_Service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';

class UserService {
  static const String _baseUrl =
      'https://stock-mate-qb40.onrender.com/api/users';

  /// POST /users
  /// [specialty] اختياري - يستخدم عادة لرول doctor
  /// يرجع true عند النجاح (201) و false عند أي فشل
  /// جميع الأخطاء تُعالج تلقائياً عبر Dispatcher + ApiErrorHandler
  static Future<bool> createUser({
    required String fullName,
    required String email,
    required String roleId,
    String? specialty,
  }) {
    return Dispatcher().send<bool>(
      request: (token) {
        final Map<String, dynamic> body = {
          'fullName': fullName,
          'email': email,
          'roleId': roleId,
        };
        if (specialty != null && specialty.isNotEmpty) {
          body['specialty'] = specialty;
        }

        return http.post(
          Uri.parse('$_baseUrl/users'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body),
        );
      },
      onSuccess: (responseBody) {
        final Map<String, dynamic> jsonBody = jsonDecode(responseBody);
        final bool isSuccess = jsonBody['success'] == true;

        if (isSuccess) {
          customSnackBar(
            title: 'تم بنجاح',
            message: 'تم إنشاء المستخدم بنجاح',
            color: constGreen,
            messageColor: constLightGreen,
          );
        }
        return isSuccess;
      },
      fallback: false,
    );
  }
}
