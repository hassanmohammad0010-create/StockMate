// lib/Service/Supplier_Service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Supplier_Model.dart';

class SupplierService {
  static const String _baseUrl =
      'https://stock-mate-qb40.onrender.com/api/suppliers';

  /// جلب كل الموردين
  /// [page] و [limit] اختياريين لو بدك تدعم الـ pagination
  static Future<List<SupplierModel>> getSuppliers({
    int page = 1,
    int limit = 20,
  }) async {
    return await Dispatcher().send<List<SupplierModel>>(
      request: (token) {
        final uri = Uri.parse(_baseUrl).replace(
          queryParameters: {'page': page.toString(), 'limit': limit.toString()},
        );
        return http.get(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );
      },
      onSuccess: (body) {
        final Map<String, dynamic> jsonBody = jsonDecode(body);
        final Map<String, dynamic> data =
            jsonBody['data'] as Map<String, dynamic>;
        final List<dynamic> items = data['items'] as List<dynamic>? ?? [];

        return items
            .map((e) => SupplierModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      fallback: <SupplierModel>[],
    );
  }
}
