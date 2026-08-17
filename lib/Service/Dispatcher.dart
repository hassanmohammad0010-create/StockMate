import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Service/Api_Error_Handler.dart';
import 'package:stock_mate_project/Service/Token_Storage.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';

enum RefreshResult { success, sessionExpired, connectionError }

class Dispatcher {
  Dispatcher._internal();
  static final Dispatcher _instance = Dispatcher._internal();
  factory Dispatcher() => _instance;

  bool _isRefreshing = false;
  Completer<RefreshResult>? _refreshCompleter;

  bool _isSuccess(int statusCode) => statusCode >= 200 && statusCode < 300;

  // ─────────────────────────────────────────────────────────
  // ✅ الدالة الأصلية — بدون أي تعديل
  // ─────────────────────────────────────────────────────────
  Future<T> send<T>({
    required Future<http.Response> Function(String token) request,
    required T Function(String body) onSuccess,
    required T fallback,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    try {
      final token = await TokenStorage.getAccessToken();
      print(token);

      if (token == null) {
        ApiErrorHandler.handleException('لا يوجد جلسة. الرجاء تسجيل الدخول');
        return fallback;
      }
      var response = await request(token).timeout(timeout);
      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return onSuccess(response.body);
      }

      if (response.statusCode == 401) {
        final result = await _refreshToken();

        if (result == RefreshResult.success) {
          final newToken = await TokenStorage.getAccessToken();
          response = await request(newToken!).timeout(timeout);
          if (response.statusCode >= 200 && response.statusCode < 300) {
            return onSuccess(response.body);
          }
          ApiErrorHandler.handleStatusCode(response.statusCode);
          return fallback;
        }

        if (result == RefreshResult.connectionError) {
          ApiErrorHandler.handleException(
            const SocketException('No connection'),
          );
          return fallback;
        }

        return fallback;
      }

      ApiErrorHandler.handleStatusCode(response.statusCode);
      return fallback;
    } catch (e) {
      ApiErrorHandler.handleException(e);
      return fallback;
    }
  }

  // ─────────────────────────────────────────────────────────
  // ✅ جديدة — لطلبات multipart (رفع ملفات/صور)
  // نفس منطق send تمامًا (توكن + retry بعد 401 + معالجة أخطاء)
  // بس بتاخد MultipartRequest جاهز بدل http.Response
  // ─────────────────────────────────────────────────────────
  Future<T> sendMultipart<T>({
    required Future<http.MultipartRequest> Function(String token) request,
    required T Function(String body) onSuccess,
    required T fallback,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      final token = await TokenStorage.getAccessToken();

      if (token == null) {
        ApiErrorHandler.handleException('لا يوجد جلسة. الرجاء تسجيل الدخول');
        return fallback;
      }

      var multipartRequest = await request(token);
      var streamedResponse = await multipartRequest.send().timeout(timeout);
      var response = await http.Response.fromStream(streamedResponse);

      if (_isSuccess(response.statusCode)) {
        return onSuccess(response.body);
      }

      if (response.statusCode == 401) {
        final result = await _refreshToken();

        if (result == RefreshResult.success) {
          final newToken = await TokenStorage.getAccessToken();
          // ✅ لازم نبني الـ MultipartRequest من جديد لأنه ما بينعاد استخدامه بعد send()
          multipartRequest = await request(newToken!);
          streamedResponse = await multipartRequest.send().timeout(timeout);
          response = await http.Response.fromStream(streamedResponse);

          if (_isSuccess(response.statusCode)) {
            return onSuccess(response.body);
          }
          ApiErrorHandler.handleStatusCode(response.statusCode);
          return fallback;
        }

        if (result == RefreshResult.connectionError) {
          ApiErrorHandler.handleException(
            const SocketException('No connection'),
          );
          return fallback;
        }

        return fallback;
      }

      ApiErrorHandler.handleStatusCode(response.statusCode);
      return fallback;
    } catch (e) {
      ApiErrorHandler.handleException(e);
      return fallback;
    }
  }

  Future<RefreshResult> _refreshToken() async {
    if (_isRefreshing) {
      return _refreshCompleter!.future;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<RefreshResult>();

    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken == null) {
        await _forceLogout();
        _refreshCompleter!.complete(RefreshResult.sessionExpired);
        return RefreshResult.sessionExpired;
      }

      final response = await http
          .post(
            Uri.parse('https://stock-mate-qb40.onrender.com/api/auth/refresh'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'refreshToken': refreshToken}),
          )
          .timeout(const Duration(seconds: 30));

      if (_isSuccess(response.statusCode)) {
        final Map<String, dynamic> jsonBody = jsonDecode(response.body);

        if (jsonBody['success'] != true || jsonBody['data'] is! Map) {
          await _forceLogout();
          _refreshCompleter!.complete(RefreshResult.sessionExpired);
          return RefreshResult.sessionExpired;
        }

        final Map<String, dynamic> data = jsonBody['data'];
        final String? newAccessToken = data['accessToken'] as String?;
        final String? newRefreshToken = data['refreshToken'] as String?;

        if (newAccessToken == null || newRefreshToken == null) {
          await _forceLogout();
          _refreshCompleter!.complete(RefreshResult.sessionExpired);
          return RefreshResult.sessionExpired;
        }

        await TokenStorage.saveAccessToken(newAccessToken);
        await TokenStorage.saveRefreshToken(newRefreshToken);

        _refreshCompleter!.complete(RefreshResult.success);
        return RefreshResult.success;
      }

      await _forceLogout();
      _refreshCompleter!.complete(RefreshResult.sessionExpired);
      return RefreshResult.sessionExpired;
    } on TimeoutException {
      _refreshCompleter!.complete(RefreshResult.connectionError);
      return RefreshResult.connectionError;
    } catch (e) {
      _refreshCompleter!.complete(RefreshResult.connectionError);
      return RefreshResult.connectionError;
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _forceLogout() async {
    await TokenStorage.clearTokens();
    customSnackBar(
      title: 'انتهت الجلسة',
      message: 'الرجاء تسجيل الدخول مرة أخرى',
      color: constRed,
      messageColor: constLightRed,
    );
    Get.offAllNamed(AppRoutes.LoginPage);
  }
}
