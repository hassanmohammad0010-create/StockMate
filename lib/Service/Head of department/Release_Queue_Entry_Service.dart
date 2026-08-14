// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';

/// سيرفس إلغاء حجز المريض (إعادته للانتظار)
/// PATCH /department-queue/{queueEntryId}/release
class ReleaseQueueEntryService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<bool> releaseQueueEntry({required String queueEntryId}) async {
    return _dispatcher.send<bool>(
      request: (token) {
        return http.patch(
          Uri.parse('$baseUrl/department-queue/$queueEntryId/release'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({}),
        );
      },

      onSuccess: (body) {
        final jsonData = jsonDecode(body);

        if (jsonData['success'] == true) {
          print('✅ تم إلغاء حجز الطابور | queueEntry: $queueEntryId');
          return true;
        }

        print('❌ Release Queue | ${jsonData['message']}');
        return false;
      },

      fallback: false,
    );
  }
}