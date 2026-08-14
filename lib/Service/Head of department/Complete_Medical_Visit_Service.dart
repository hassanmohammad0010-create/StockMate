// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Prescription_Model.dart';

/// سيرفس إنهاء المعاينة — Complete Medical Visit
/// POST /medical-visits/complete
class CompleteMedicalVisitService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<bool> completeVisit({
    required String queueEntryId,
    required String clinicalNotes,
    required String diagnosis,
    String externalMedications = '',
    List<Prescription> prescriptions = const [],
  }) async {
    return _dispatcher.send<bool>(
      request: (token) {
        final body = {
          'queueEntryId': queueEntryId,
          'clinicalNotes': clinicalNotes,
          'diagnosis': diagnosis,
          'externalMedications': externalMedications,
          'prescriptions': prescriptions.map((e) => e.toJson()).toList(),
        };

        print('📤 Body: ${jsonEncode(body)}');

        return http.post(
          Uri.parse('$baseUrl/medical-visits/complete'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body),
        );
      },

      onSuccess: (body) {
        final jsonData = jsonDecode(body);

        if (jsonData['success'] == true) {
          print('✅ تم إنهاء المعاينة | queueEntry: $queueEntryId');
          return true;
        }

        print('❌ Complete Visit | ${jsonData['message']}');
        return false;
      },

      fallback: false,
    );
  }
}