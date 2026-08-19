// lib/Service/Get_Purchase_Receipts_List_Service.dart
// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Purchase_Receipts_Page_Data_Model.dart';

/// سيرفس جلب قائمة إيصالات استلام المشتريات
/// GET /purchasing/receipts
class GetPurchaseReceiptsListService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<PurchaseReceiptsPageData?> getReceipts({
    int page = 1,
    int limit = 20,
    String? purchaseRequestId,
  }) async {
    return _dispatcher.send<PurchaseReceiptsPageData?>(
      request: (token) {
        final queryParams = <String, String>{
          'page': page.toString(),
          'limit': limit.toString(),
        };

        if (purchaseRequestId != null) {
          queryParams['purchaseRequestId'] = purchaseRequestId;
        }

        final uri = Uri.parse(
          '$baseUrl/purchasing/receipts',
        ).replace(queryParameters: queryParams);

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
          return PurchaseReceiptsPageData.fromJson(
            jsonData['data'] as Map<String, dynamic>,
          );
        }

        return null;
      },

      fallback: null,
    );
  }
}
