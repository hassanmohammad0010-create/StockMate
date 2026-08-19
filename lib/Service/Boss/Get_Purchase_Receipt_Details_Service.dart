// lib/Service/Get_Purchase_Receipt_Details_Service.dart
// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Purchase_Receipt_Details_Model.dart';

/// سيرفس جلب تفاصيل إيصال استلام واحد
/// GET /purchasing/receipts/{id}
class GetPurchaseReceiptDetailsService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<PurchaseReceiptDetails?> getReceiptDetails({
    required String receiptId,
  }) async {
    return _dispatcher.send<PurchaseReceiptDetails?>(
      request: (token) {
        final uri = Uri.parse('$baseUrl/purchasing/receipts/$receiptId');

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
          return PurchaseReceiptDetails.fromJson(
            jsonData['data'] as Map<String, dynamic>,
          );
        }

        return null;
      },

      fallback: null,
    );
  }
}
