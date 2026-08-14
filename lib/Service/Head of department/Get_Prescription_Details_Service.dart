// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/Test/PrescriptionDetailsModel.dart';

/// سيرفس جلب تفاصيل الوصفة
/// GET /prescriptions/{id}
class GetPrescriptionDetailsService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<PrescriptionDetails?> getPrescriptionDetails({
    required String prescriptionId,
  }) async {
    return _dispatcher.send<PrescriptionDetails?>(
      request: (token) {
        final uri = Uri.parse('$baseUrl/prescriptions/$prescriptionId');

        return http.get(
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

        if (jsonData['success'] == true && jsonData['data'] != null) {
          return PrescriptionDetails.fromJson(
            jsonData['data'] as Map<String, dynamic>,
          );
        }

        print('❌ Prescription Details | ${jsonData['message']}');
        return null;
      },

      fallback: null,
    );
  }
}