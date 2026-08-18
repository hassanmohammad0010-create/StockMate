// lib/Service/Boss/Manager_Approve_Purchase_Request_Service.dart
// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Approve_Purchase_Item_Input.dart';

/// سيرفس موافقة المدير على طلب شراء (مع تحديد الكمية المعتمدة لكل صنف)
/// POST /purchasing/requests/{purchaseRequestId}/approve
class ManagerApprovePurchaseRequestService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<bool> approveRequest({
    required String purchaseRequestId,
    required List<ApprovePurchaseItemInput> items,
  }) async {
    return _dispatcher.send<bool>(
      request: (token) {
        final uri = Uri.parse(
          '$baseUrl/purchasing/requests/$purchaseRequestId/approve',
        );

        return http.post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'items': items.map((e) => e.toJson()).toList()}),
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
