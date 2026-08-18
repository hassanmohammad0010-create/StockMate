// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';

class NotificationService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';
  final Dispatcher _dispatcher = Dispatcher();

  /// يرسل fcmToken الخاص بهذا الجهاز إلى الباك اند
  /// يُستدعى بعد تسجيل الدخول مباشرة، وأيضاً كلما تغيّر التوكن (onTokenRefresh)
  Future<bool> registerDeviceToken({
    required String fcmToken,
    String platform = 'mobile',
  }) async {
    final result = await _dispatcher.send<bool>(
      request: (token) => http.post(
        Uri.parse('$baseUrl/notifications/device-tokens'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'fcmToken': fcmToken,
          'platform': platform,
        }),
      ),
      onSuccess: (body) => true,
      fallback: false,
    );
    return result;
  }
}