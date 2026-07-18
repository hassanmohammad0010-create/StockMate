// import 'dart:async';
// import 'package:http/http.dart' as http;
// import 'package:stock_mate_project/Service/Api_Error_Handler.dart';
// import 'package:stock_mate_project/Service/Token_Storage.dart'; // مكان تخزين التوكنات عندك

// class Dispatcher {
//   Dispatcher._internal();
//   static final Dispatcher _instance = Dispatcher._internal();
//   factory Dispatcher() => _instance;

//   bool _isRefreshing = false;
//   Completer<bool>? _refreshCompleter;

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
//         ApiErrorHandler.handleException('لا يوجد توكن، الرجاء تسجيل الدخول');
//         return fallback;
//       }

//       var response = await request(token).timeout(timeout);

//       if (response.statusCode == 200) {
//         return onSuccess(response.body);
//       }

//       if (response.statusCode == 401) {
//         final refreshed = await _refreshToken();
//         if (refreshed) {
//           final newToken = await TokenStorage.getAccessToken();
//           response = await request(newToken!).timeout(timeout);
//           if (response.statusCode == 200) {
//             return onSuccess(response.body);
//           }
//         }
//         ApiErrorHandler.handleStatusCode(response.statusCode);
//         return fallback;
//       }

//       ApiErrorHandler.handleStatusCode(response.statusCode);
//       return fallback;
//     } catch (e) {
//       ApiErrorHandler.handleException(e);
//       return fallback;
//     }
//   }

//   /// يمنع تعدد نداءات refresh في نفس اللحظة (مثلاً لو عدة requests فشلت بنفس الوقت)
//   Future<bool> _refreshToken() async {
//     if (_isRefreshing) {
//       return _refreshCompleter!.future;
//     }

//     _isRefreshing = true;
//     _refreshCompleter = Completer<bool>();

//     try {
//       final refreshToken = await TokenStorage.getRefreshToken();
//       if (refreshToken == null) {
//         _refreshCompleter!.complete(false);
//         return false;
//       }

//       final response = await http.post(
//         Uri.parse('https://grud-2y91.onrender.com/api/auth/refresh'),
//         headers: {'Accept': 'application/json'},
//         body: {'refresh_token': refreshToken},
//       ).timeout(const Duration(seconds: 15));

//       if (response.statusCode == 200) {
//         // فك التشفير وتخزين التوكن الجديد بحسب شكل استجابة الـ API عندك
//         final newAccessToken = /* jsonDecode(response.body)['access_token'] */ '';
//         await TokenStorage.saveAccessToken(newAccessToken);
//         _refreshCompleter!.complete(true);
//         return true;
//       }

//       _refreshCompleter!.complete(false);
//       return false;
//     } catch (e) {
//       ApiErrorHandler.handleException(e);
//       _refreshCompleter!.complete(false);
//       return false;
//     } finally {
//       _isRefreshing = false;
//     }
//   }
// }
