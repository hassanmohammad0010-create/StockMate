// lib/Service/Get_Purchase_Receipt_Images_Service.dart
// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Purchase_Receipt_Image_Url.dart';

/// سيرفس جلب روابط صور إيصال الاستلام (Signed URLs)
/// GET /purchasing/receipts/{id}/images
class GetPurchaseReceiptImagesService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<List<PurchaseReceiptImageUrl>?> getImages({
    required String receiptId,
  }) async {
    return _dispatcher.send<List<PurchaseReceiptImageUrl>?>(
      request: (token) {
        final uri = Uri.parse('$baseUrl/purchasing/receipts/$receiptId/images');

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
          final List<dynamic> data = jsonData['data'] as List<dynamic>;
          return data
              .map(
                (e) =>
                    PurchaseReceiptImageUrl.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        }

        return null;
      },

      fallback: null,
    );
  }
}
