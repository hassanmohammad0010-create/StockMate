// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:stock_mate_project/Constant/Const.dart';
// import 'package:stock_mate_project/Service/Api_Error_Handler.dart';
// import 'package:stock_mate_project/Service/Token_Storage.dart';
// import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
// import 'package:stock_mate_project/core/router/app_routes.dart';

// enum RefreshResult { success, sessionExpired, connectionError }

// class Dispatcher {
//   Dispatcher._internal();
//   static final Dispatcher _instance = Dispatcher._internal();
//   factory Dispatcher() => _instance;

//   bool _isRefreshing = false;
//   Completer<RefreshResult>? _refreshCompleter;

//   /// [request] هي الدالة التي تنفذ الطلب الفعلي، وتستقبل الـ token الحالي
//   /// [onSuccess] تحوّل الـ body الناجح إلى النوع المطلوب T
//   /// [fallback] القيمة التي تُرجع عند الفشل (مثلاً [] أو false)
//   Future<T> send<T>({
//     required Future<http.Response> Function(String token) request,
//     required T Function(String body) onSuccess,
//     required T fallback,
//     Duration timeout = const Duration(seconds: 15),
//   }) async {
//     try {
//       final token = await TokenStorage.getAccessToken();
//       if (token == null) {
//         ApiErrorHandler.handleException('لا يوجد جلسة. الرجاء تسجيل الدخول');
//         return fallback;
//       }

//       var response = await request(token).timeout(timeout);

//       if (response.statusCode == 200) {
//         return onSuccess(response.body);
//       }
//       if (response.statusCode == 401) {
//         final result = await _refreshToken();

//         if (result == RefreshResult.success) {
//           final newToken = await TokenStorage.getAccessToken();
//           response = await request(newToken!).timeout(timeout);
//           if (response.statusCode == 200) {
//             return onSuccess(response.body);
//           }
//           ApiErrorHandler.handleStatusCode(response.statusCode);
//           return fallback;
//         }

//         if (result == RefreshResult.connectionError) {
//           ApiErrorHandler.handleException(
//             const SocketException('No connection'),
//           );
//           return fallback;
//         }

//         // result == RefreshResult.sessionExpired -> الرسالة والتوجيه صارو جوا _forceLogout مسبقاً
//         return fallback;
//       }

//       ApiErrorHandler.handleStatusCode(response.statusCode);
//       return fallback;
//     } catch (e) {
//       ApiErrorHandler.handleException(e);
//       return fallback;
//     }
//   }

//   Future<RefreshResult> _refreshToken() async {
//     if (_isRefreshing) {
//       return _refreshCompleter!.future;
//     }

//     _isRefreshing = true;
//     _refreshCompleter = Completer<RefreshResult>();

//     try {
//       final refreshToken = await TokenStorage.getRefreshToken();
//       if (refreshToken == null) {
//         await _forceLogout();
//         _refreshCompleter!.complete(RefreshResult.sessionExpired);
//         return RefreshResult.sessionExpired;
//       }

//       final response = await http
//           .post(
//             Uri.parse('https://stock-mate-qb40.onrender.com/api/auth/refresh'),
//             headers: {
//               'Content-Type': 'application/json',
//               'Accept': 'application/json',
//             },
//             body: jsonEncode({'refreshToken': refreshToken}),
//           )
//           .timeout(const Duration(seconds: 30));

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> jsonBody = jsonDecode(response.body);

//         if (jsonBody['success'] != true || jsonBody['data'] is! Map) {
//           await _forceLogout();
//           _refreshCompleter!.complete(RefreshResult.sessionExpired);
//           return RefreshResult.sessionExpired;
//         }

//         final Map<String, dynamic> data = jsonBody['data'];
//         final String? newAccessToken = data['accessToken'] as String?;
//         final String? newRefreshToken = data['refreshToken'] as String?;

//         if (newAccessToken == null || newRefreshToken == null) {
//           await _forceLogout();
//           _refreshCompleter!.complete(RefreshResult.sessionExpired);
//           return RefreshResult.sessionExpired;
//         }

//         await TokenStorage.saveAccessToken(newAccessToken);
//         await TokenStorage.saveRefreshToken(newRefreshToken);

//         _refreshCompleter!.complete(RefreshResult.success);
//         return RefreshResult.success;
//       }

//       // السيرفر رد فعلياً برفض التوكين
//       await _forceLogout();
//       _refreshCompleter!.complete(RefreshResult.sessionExpired);
//       return RefreshResult.sessionExpired;
//     } on TimeoutException {
//       _refreshCompleter!.complete(RefreshResult.connectionError);
//       return RefreshResult.connectionError;
//     } catch (e) {
//       _refreshCompleter!.complete(RefreshResult.connectionError);
//       return RefreshResult.connectionError;
//     } finally {
//       _isRefreshing = false;
//     }
//   }

//   Future<void> _forceLogout() async {
//     await TokenStorage.clearTokens();
//     customSnackBar(
//       title: 'انتهت الجلسة',
//       message: 'الرجاء تسجيل الدخول مرة أخرى',
//       color: constRed,
//       messageColor: constLightRed,
//     );
//     Get.offAllNamed(AppRoutes.LoginPage);
//   }
// }

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

  /// ✅ helper: هل الـ status ناجح؟
  bool _isSuccess(int statusCode) => statusCode >= 200 && statusCode < 300;

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
      print('BODY: ${response.body}'); // ⬅️

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
        // ✅ هنا أيضاً
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
