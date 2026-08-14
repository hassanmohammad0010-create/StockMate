// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Patient_Details_Info.dart';

/// سيرفس جلب السجل الطبي للمريض
/// GET /medical-visits/patient/{id}/history
class GetPatientHistoryService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<PatientDetailsResponse?> getPatientHistory({
    required String patientId,
  }) async {
    return _dispatcher.send<PatientDetailsResponse?>(
      request: (token) {
        final uri = Uri.parse(
          '$baseUrl/medical-visits/patient/$patientId/history',
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

      onSuccess: (body) {
        final jsonData = jsonDecode(body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          return PatientDetailsResponse.fromJson(
            jsonData['data'] as Map<String, dynamic>,
          );
        }

        print('❌ Patient History | success = false: ${jsonData['message']}');
        return null;
      },

      fallback: null,
    );
  }
}