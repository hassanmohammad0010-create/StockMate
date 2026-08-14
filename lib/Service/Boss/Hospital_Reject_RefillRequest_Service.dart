// lib/Service/Head of department/Hospital_Reject_Refill_Request_Service.dart
// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';

/// سيرفس رفض الطلب من طرف المستشفى
/// POST /department-refills/requests/{refillRequestId}/hospital-reject
class HospitalRejectRefillRequestService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<bool> rejectRequest({
    required String refillRequestId,
    required String rejectionReason,
  }) async {
    return _dispatcher.send<bool>(
      request: (token) {
        final uri = Uri.parse(
          '$baseUrl/department-refills/requests/$refillRequestId/hospital-reject',
        );

        return http.post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'reason': rejectionReason}), // ✅ اتصلحت
        );
      },

      onSuccess: (body) {
        final jsonData = jsonDecode(body);
        return jsonData['success'] == true;
      },

      fallback: false,
    );
  }
}
