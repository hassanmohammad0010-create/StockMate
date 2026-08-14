// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Dispense_Queue_Item.dart';

/// سيرفس جلب طابور صرف الصيدلية
/// GET /pharmacy/dispense-queue
class GetDispenseQueueService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<DispenseQueuePageData?> getDispenseQueue({
    int page = 1,
    int limit = 20,
    String status = 'ready', // ready | partially_delivered | delivered | missed | cancelled
  }) async {
    return _dispatcher.send<DispenseQueuePageData?>(
      request: (token) {
        final uri = Uri.parse(
          '$baseUrl/pharmacy/dispense-queue'
          '?page=$page'
          '&limit=$limit'
          '&status=$status',
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
          return DispenseQueuePageData.fromJson(
            jsonData['data'] as Map<String, dynamic>,
          );
        }

        print('❌ Dispense Queue | ${jsonData['message']}');
        return null;
      },

      fallback: null,
    );
  }
}