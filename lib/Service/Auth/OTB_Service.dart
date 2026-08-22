// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:stock_mate_project/Constant/Const.dart';
// import 'package:stock_mate_project/Service/Api_Error_Handler.dart';
// import 'package:stock_mate_project/Service/Token_Storage.dart';
// import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';

// class OtpService {
//   /// يتحقق من رمز الـ OTP ويسجل الدخول
//   static Future<bool> verifyOtp({
//     required String email,
//     required String code,
//     String platform = 'mobile',
//   }) async {
//     try {
//       final response = await http
//           .post(
//             Uri.parse(
//               'https://stock-mate-qb40.onrender.com/api/auth/otp/verify',
//             ),
//             headers: {
//               'Content-Type': 'application/json',
//               'Accept': 'application/json',
//             },
//             body: jsonEncode({
//               'email': email,
//               'code': code,
//               'platform': platform,
//             }),
//           )
//           .timeout(const Duration(seconds: 30));
//       final Map<String, dynamic> jsonBody = jsonDecode(response.body);
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = jsonBody['data'];
//         final String? accessToken = data['accessToken'] as String?;
//         final String? refreshToken = data['refreshToken'] as String?;

//         if (accessToken == null || refreshToken == null) {
//           customSnackBar(
//             title: 'خطأ في البيانات',
//             message: 'تعذّر إتمام تسجيل الدخول، الرجاء المحاولة لاحقاً',
//             color: constRed,
//             messageColor: constLightRed,
//           );
//           return false;
//         }

//         await TokenStorage.saveTokens(
//           accessToken: accessToken,
//           refreshToken: refreshToken,
//         );

//         // استخراج وتخزين الرول واسم المستخدم
//         final Map<String, dynamic>? user = data['user'] is Map
//             ? data['user'] as Map<String, dynamic>
//             : null;

//         // ✅ department موجود جوا user، مو جوا data مباشرة
//         final Map<String, dynamic>? department = user?['department'] is Map
//             ? user!['department'] as Map<String, dynamic>
//             : null;

//         final String? departmentId = department?['id'] as String?;
//         final String? departmentName = department?['name'] as String?;

//         final String? fullName = user?['fullName'] as String?;

//         final Map<String, dynamic>? role = user?['role'] is Map
//             ? user!['role'] as Map<String, dynamic>
//             : null;
//         final String? roleName = role?['name'] as String?;

//         if (roleName != null) {
//           await TokenStorage.saveUserRole(roleName);
//         }

//         if (fullName != null) {
//           await TokenStorage.saveUserName(fullName);
//         }
//         if (departmentId != null) {
//           await TokenStorage.saveDepartmentID(departmentId);
//         }

//         if (departmentName != null) {
//           await TokenStorage.saveDepartmentName(departmentName);
//         }

//         customSnackBar(
//           title: 'تم تسجيل الدخول',
//           message: 'مرحباً بك، تم تسجيل الدخول بنجاح',
//           color: constBlue,
//           messageColor: constLightBlue,
//         );

//         return true;
//       }
//       if (jsonBody['success'] != true || jsonBody['data'] is! Map) {
//         customSnackBar(
//           title: 'رمز غير صحيح',
//           message: 'الرمز الذي أدخلته غير صحيح أو منتهي الصلاحية',
//           color: constRed,
//           messageColor: constLightRed,
//         );
//         return false;
//       }
//       ApiErrorHandler.handleStatusCode(response.statusCode);
//       return false;
//     } on SocketException {
//       ApiErrorHandler.handleException(const SocketException('No connection'));
//       return false;
//     } on TimeoutException {
//       ApiErrorHandler.handleException(TimeoutException('Request timeout'));
//       return false;
//     } catch (e) {
//       ApiErrorHandler.handleException(e);
//       return false;
//     }
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Service/Api_Error_Handler.dart';
import 'package:stock_mate_project/Service/App/FCM_Service.dart';
import 'package:stock_mate_project/Service/Token_Storage.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';

class OtpService {
  /// يتحقق من رمز الـ OTP ويسجل الدخول
  static Future<bool> verifyOtp({
    required String email,
    required String code,
    String platform = 'mobile',
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(
              'https://stock-mate-qb40.onrender.com/api/auth/otp/verify',
            ),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'email': email,
              'code': code,
              'platform': platform,
            }),
          )
          .timeout(const Duration(seconds: 30));
      final Map<String, dynamic> jsonBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonBody['data'];
        final String? accessToken = data['accessToken'] as String?;
        final String? refreshToken = data['refreshToken'] as String?;

        if (accessToken == null || refreshToken == null) {
          customSnackBar(
            title: 'خطأ في البيانات',
            message: 'تعذّر إتمام تسجيل الدخول، الرجاء المحاولة لاحقاً',
            color: constRed,
            messageColor: constLightRed,
          );
          return false;
        }

        await TokenStorage.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );

        // استخراج وتخزين الرول واسم المستخدم
        final Map<String, dynamic>? user = data['user'] is Map
            ? data['user'] as Map<String, dynamic>
            : null;

        // ✅ department موجود جوا user، مو جوا data مباشرة
        final Map<String, dynamic>? department = user?['department'] is Map
            ? user!['department'] as Map<String, dynamic>
            : null;

        final String? departmentId = department?['id'] as String?;
        final String? departmentName = department?['name'] as String?;

        final String? fullName = user?['fullName'] as String?;

        final Map<String, dynamic>? role = user?['role'] is Map
            ? user!['role'] as Map<String, dynamic>
            : null;
        final String? roleName = role?['name'] as String?;

        if (roleName != null) {
          await TokenStorage.saveUserRole(roleName);
        }

        if (fullName != null) {
          await TokenStorage.saveUserName(fullName);
        }
        if (departmentId != null) {
          await TokenStorage.saveDepartmentID(departmentId);
        }

        if (departmentName != null) {
          await TokenStorage.saveDepartmentName(departmentName);
        }

        // ✅ تسجيل هذا الجهاز لاستقبال الإشعارات بعد نجاح تسجيل الدخول
        // لا داعي لـ await هنا: لا نريد تأخير ظهور رسالة النجاح
        // أو الانتقال للصفحة التالية بسبب مشكلة في الإشعارات
        FCMService.instance.initAfterLogin();

        customSnackBar(
          title: 'تم تسجيل الدخول',
          message: 'مرحباً بك، تم تسجيل الدخول بنجاح',
          color: constBlue,
          messageColor: constLightBlue,
        );

        return true;
      }
      if (jsonBody['success'] != true || jsonBody['data'] is! Map) {
        customSnackBar(
          title: 'رمز غير صحيح',
          message: 'الرمز الذي أدخلته غير صحيح أو منتهي الصلاحية',
          color: constRed,
          messageColor: constLightRed,
        );
        return false;
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