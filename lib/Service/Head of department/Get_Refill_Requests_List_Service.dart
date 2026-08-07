// // // ignore_for_file: file_names

// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import 'package:stock_mate_project/Service/Dispatcher.dart';
// // import 'package:stock_mate_project/Test/Order_Item.dart';

// // /// سيرفس جلب قائمة الطلبات — List Refill Requests
// // /// GET /department-refills/requests
// // class GetRefillRequestsListService {
// //   static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

// //   final Dispatcher _dispatcher = Dispatcher();

// //   Future<RefillRequestsPageData?> getRequests({
// //     required String departmentId,
// //     int page = 1,
// //     int limit = 20,
// //   }) async {
// //     return _dispatcher.send<RefillRequestsPageData?>(
// //       // ─── الطلب الفعلي: Dispatcher بيمرر التوكن جاهز، إحنا بس نبني الطلب ───
// //       request: (token) {
// //         final uri = Uri.parse(
// //           '$baseUrl/department-refills/requests'
// //           '?page=$page'
// //           '&limit=$limit'
// //           '&departmentId=$departmentId',
// //         );

// //         return http.get(
// //           uri,
// //           headers: {
// //             'Content-Type': 'application/json',
// //             'Accept': 'application/json',
// //             'Authorization': 'Bearer $token',
// //           },
// //         );
// //       },

// //       // ─── عند نجاح الطلب (status 200): نحوّل الـ body لـ RefillRequestsPageData ───
// //       onSuccess: (body) {
// //         final jsonData = jsonDecode(body);

// //         // نتحقق من الـ success flag قبل التحويل
// //         if (jsonData['success'] == true && jsonData['data'] != null) {
// //           return RefillRequestsPageData.fromJson(
// //             jsonData['data'] as Map<String, dynamic>,
// //           );
// //         }

// //         print('❌ List Requests | success = false: ${jsonData['message']}');
// //         return null;
// //       },

// //       // ─── القيمة المرتجعة عند أي فشل (null بدل رمي Exception) ───
// //       fallback: null,
// //     );
// //   }
// // }

// // ignore_for_file: file_names

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:stock_mate_project/Service/Dispatcher.dart';
// import 'package:stock_mate_project/core/models/Order_Item.dart';

// /// سيرفس جلب قائمة الطلبات — List Refill Requests
// /// GET /department-refills/requests
// class GetRefillRequestsListService {
//   static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

//   final Dispatcher _dispatcher = Dispatcher();

//   Future<RefillRequestsPageData?> getRequests({
//     required String departmentId,
//     int page = 1,
//     int limit = 20,
//   }) async {
//     return _dispatcher.send<RefillRequestsPageData?>(
//       request: (token) {
//         final uri = Uri.parse(
//           '$baseUrl/department-refills/requests'
//           '?page=$page'
//           '&limit=$limit'
//           '&departmentId=$departmentId',
//         );

//         return http.get(
//           uri,
//           headers: {
//             'Content-Type': 'application/json',
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         );
//       },

//       onSuccess: (body) {
//         final jsonData = jsonDecode(body);

//         if (jsonData['success'] == true && jsonData['data'] != null) {
//           return RefillRequestsPageData.fromJson(
//             jsonData['data'] as Map<String, dynamic>,
//           );
//         }

//         print('❌ List Requests | success = false: ${jsonData['message']}');
//         return null;
//       },

//       fallback: null,
//     );
//   }
// }
// lib/Service/Get_Refill_Requests_List_Service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Order_Item.dart';

/// سيرفس جلب قائمة الطلبات — List Refill Requests
/// GET /department-refills/requests
class GetRefillRequestsListService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  /// ✅ لجلب طلبات قسم معيّن (تُستخدم في صفحة القسم / رئيس القسم)
  Future<RefillRequestsPageData?> getRequests({
    required String departmentId,
    int page = 1,
    int limit = 20,
  }) async {
    return _dispatcher.send<RefillRequestsPageData?>(
      request: (token) {
        final uri = Uri.parse(
          '$baseUrl/department-refills/requests'
          '?page=$page'
          '&limit=$limit'
          '&departmentId=$departmentId',
        );

        return http.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      },
      onSuccess: (body) => _parseResponse(body, 'getRequests'),
      fallback: null,
    );
  }

  /// ✅ لجلب كل الطلبات بدون تحديد قسم (تُستخدم في صفحة المستودع/البوس)
  Future<RefillRequestsPageData?> getAllRequests({
    int page = 1,
    int limit = 20,
  }) async {
    return _dispatcher.send<RefillRequestsPageData?>(
      request: (token) {
        final uri = Uri.parse(
          '$baseUrl/department-refills/requests'
          '?page=$page'
          '&limit=$limit',
        );

        return http.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      },
      onSuccess: (body) => _parseResponse(body, 'getAllRequests'),
      fallback: null,
    );
  }

  RefillRequestsPageData? _parseResponse(String body, String from) {
    final jsonData = jsonDecode(body);

    if (jsonData['success'] == true && jsonData['data'] != null) {
      return RefillRequestsPageData.fromJson(
        jsonData['data'] as Map<String, dynamic>,
      );
    }

    print('❌ $from | success = false: ${jsonData['message']}');
    return null;
  }
}
