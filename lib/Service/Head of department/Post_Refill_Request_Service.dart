// // ignore_for_file: file_names

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:stock_mate_project/Service/Dispatcher.dart';
// import 'package:stock_mate_project/core/models/Request_Item_Input.dart';

// class RefillRequestService {
//   static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';
//   final Dispatcher _dispatcher = Dispatcher();

//   /// الخطوة 1: إنشاء الطلب → يصبح draft (201 Created)
//   Future<RefillRequest?> createRequest(CreateRefillRequestModel request) async {
//     return _dispatcher.send<RefillRequest?>(
//       request: (token) => http.post(
//         Uri.parse('$baseUrl/department-refills/requests'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode(request.toJson()),
//       ),
//       onSuccess: (body) {
//         final jsonData = jsonDecode(body);
//         return RefillRequest.fromJson(jsonData['data']);
//       },
//       fallback: null,
//     );
//   }

//   /// ✅ الخطوة 2: تأكيد الإرسال → يصبح pending_hospital_approval
//   /// لا body! فقط الـ id في الـ URL
//   Future<RefillRequest?> submitRequest(String requestId) async {
//     return _dispatcher.send<RefillRequest?>(
//       request: (token) => http.post(
//         Uri.parse('$baseUrl/department-refills/requests/$requestId/submit'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         // ⚠️ مهم جداً: لا body هنا!
//       ),
//       onSuccess: (body) {
//         final jsonData = jsonDecode(body);
//         return RefillRequest.fromJson(jsonData['data']);
//       },
//       fallback: null,
//     );
//   }
// }

// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Request_Item_Input.dart';

class RefillRequestService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';
  final Dispatcher _dispatcher = Dispatcher();

  /// الخطوة 1: إنشاء الطلب → يصبح draft (201 Created)
  Future<RefillRequest?> createRequest(
      CreateRefillRequestModel request) async {
    return _dispatcher.send<RefillRequest?>(
      request: (token) => http.post(
        Uri.parse('$baseUrl/department-refills/requests'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      ),
      onSuccess: (body) {
        final jsonData = jsonDecode(body);
        return RefillRequest.fromJson(jsonData['data']);
      },
      fallback: null,
    );
  }

  /// ✅ تعديل مسودة موجودة (draft فقط) → PATCH
  /// يُستخدم عندما يرجع المستخدم لصفحة الإرسال ويعدّل بيانات مسودة
  /// تم إنشاؤها مسبقاً، بدل إنشاء طلب جديد بـ id مختلف.
  Future<RefillRequest?> updateRequest(
    String requestId,
    CreateRefillRequestModel request,
  ) async {
    return _dispatcher.send<RefillRequest?>(
      request: (token) => http.patch(
        Uri.parse('$baseUrl/department-refills/requests/$requestId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toUpdateJson()),
      ),
      onSuccess: (body) {
        final jsonData = jsonDecode(body);
        return RefillRequest.fromJson(jsonData['data']);
      },
      fallback: null,
    );
  }

  /// ✅ الخطوة 2: تأكيد الإرسال → يصبح pending_hospital_approval
  /// لا body! فقط الـ id في الـ URL
  Future<RefillRequest?> submitRequest(String requestId) async {
    return _dispatcher.send<RefillRequest?>(
      request: (token) => http.post(
        Uri.parse('$baseUrl/department-refills/requests/$requestId/submit'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // ⚠️ مهم جداً: لا body هنا!
      ),
      onSuccess: (body) {
        final jsonData = jsonDecode(body);
        return RefillRequest.fromJson(jsonData['data']);
      },
      fallback: null,
    );
  }
}