// lib/Service/Auth/Otp_Service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Service/Api_Error_Handler.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';

class LoginService {
  /// يطلب إرسال OTP للإيميل المحدد
  /// [email] البريد الإلكتروني للمستخدم
  /// [channel] قناة الإرسال، افتراضياً 'email'
  /// بيرجع true إذا نجح الطلب، false إذا فشل
  static Future<bool> loginService({
    required String email,
    String channel = 'email',
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(
              'https://stock-mate-qb40.onrender.com/api/auth/otp/request',
            ),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'email': email, 'channel': channel}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = jsonDecode(response.body);
        final bool success = jsonBody['success'] == true;

        if (success) {
          final Map<String, dynamic>? data = jsonBody['data'] is Map
              ? jsonBody['data']
              : null;
          final String? otpCode = data?['code'] as String?;
          print(otpCode);
          customSnackBar(
            title: 'تم إرسال الرمز',
            message: otpCode != null
                ? 'رمز التحقق (تجريبي): $otpCode'
                : (jsonBody['message'] as String? ?? 'تم إرسال الرمز بنجاح'),
            color: constBlue, // بدّلها للون النجاح المناسب عندك إذا في واحد
            messageColor: constLightBlue,
          );
        }

        return success;
      }

      ApiErrorHandler.handleStatusCode(response.statusCode);
      return false;
    } on SocketException {
      ApiErrorHandler.handleException(const SocketException('No connection'));
      return false;
    } on TimeoutException {
      ApiErrorHandler.handleException(TimeoutException('Request timeout'));
      return false;
    } catch (e) {
      ApiErrorHandler.handleException(e);
      return false;
    }
  }
}
