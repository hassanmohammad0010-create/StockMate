// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';

/// سيرفس حجز المريض (اختياره للمعاينة)
/// POST /medical-visits/select
class SelectPatientForConsultationService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<bool> selectPatient({required String queueEntryId}) async {
    return _dispatcher.send<bool>(
      request: (token) {
        return http.post(
          Uri.parse('$baseUrl/medical-visits/select'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'queueEntryId': queueEntryId}),
        );
      },

      onSuccess: (body) {
        final jsonData = jsonDecode(body);

        if (jsonData['success'] == true) {
          print('✅ تم حجز المريض | queueEntry: $queueEntryId');
          return true;
        }

        print('❌ Select Patient | ${jsonData['message']}');
        return false;
      },

      fallback: false,
    );
  }
}