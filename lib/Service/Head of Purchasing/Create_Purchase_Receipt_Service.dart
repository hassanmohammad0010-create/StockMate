// lib/Service/Purchasing/Create_Purchase_Receipt_Service.dart
// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Create_Purchase_Receipt_Item_Input.dart';

/// سيرفس إنشاء إيصال استلام لطلب شراء (multipart، مع صور)
/// POST /purchasing/receipts
class CreatePurchaseReceiptService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<bool> createReceipt({
    required String purchaseRequestId,
    required String supplierId,
    required DateTime receivingDate,
    String? notes,
    required List<CreatePurchaseReceiptItemInput> items,
    List<File> receiptImages = const [],
  }) async {
    return _dispatcher.sendMultipart<bool>(
      request: (token) async {
        final uri = Uri.parse('$baseUrl/purchasing/receipts');
        final request = http.MultipartRequest('POST', uri);

        request.headers['Authorization'] = 'Bearer $token';
        request.headers['Accept'] = 'application/json';

        request.fields['purchaseRequestId'] = purchaseRequestId;
        request.fields['supplierId'] = supplierId;
        request.fields['receivingDate'] = _fmtDate(receivingDate);
        request.fields['type'] = 'final_batch';
        if (notes != null && notes.isNotEmpty) {
          request.fields['notes'] = notes;
        }
        request.fields['items'] = jsonEncode(
          items.map((e) => e.toJson()).toList(),
        );

        for (final image in receiptImages) {
          request.files.add(
            await http.MultipartFile.fromPath('receiptImages', image.path),
          );
        }

        return request;
      },

      onSuccess: (body) {
        final jsonData = jsonDecode(body);
        return jsonData['success'] == true;
      },

      fallback: false,
    );
  }

  static String _fmtDate(DateTime d) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }
}
