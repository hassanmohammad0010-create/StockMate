// lib/Service/App/Logout_Service.dart
// ignore_for_file: file_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/Service/Token_Storage.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';

class LogoutService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  static final Dispatcher _dispatcher = Dispatcher();

  /// POST /auth/logout
  /// بيسجل خروج من السيرفر، بيعرض رسالة نجاح أو خطأ، وبعدين (بغض النظر
  /// عن نتيجة السيرفر) بيمسح التوكنات المحلية ويرجّع المستخدم لصفحة
  /// تسجيل الدخول (LoginPage)
  static Future<bool> logout() async {
    final success = await _dispatcher.send<bool>(
      request: (token) {
        final uri = Uri.parse('$baseUrl/auth/logout');

        return http.post(
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
        return jsonData['success'] == true;
      },
      fallback: false,
    );

    // ✅ رسالة نجاح أو خطأ حسب نتيجة الطلب
    if (success) {
      customSnackBar(
        title: 'تم بنجاح',
        message: 'تم تسجيل الخروج بنجاح',
        color: constGreen,
        messageColor: constLightGreen,
      );
    } else {
      customSnackBar(
        title: 'خطأ',
        message: 'حدث خطأ أثناء تسجيل الخروج',
        color: constRed,
        messageColor: constLightRed,
      );
    }

    // ✅ نمسح التوكنات محلياً ونرجع لصفحة الدخول دايماً،
    // حتى لو فشل الطلب (متلاً التوكن أصلاً منتهي عند السيرفر)
    await TokenStorage.clearTokens();
    Get.offAllNamed(AppRoutes.LoginPage);

    return success;
  }
}
