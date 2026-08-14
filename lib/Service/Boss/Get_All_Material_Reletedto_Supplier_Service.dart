// lib/Service/Supplier_Material_Service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Supplier_Material_Model.dart';

class SupplierMaterialService {
  static const String _baseUrl =
      'https://stock-mate-qb40.onrender.com/api/suppliers';

  /// جلب مواد مورد معين حسب [supplierId]
  static Future<List<SupplierMaterialModel>> getSupplierMaterials({
    required String supplierId,
    int page = 1,
    int limit = 20,
  }) async {
    return await Dispatcher().send<List<SupplierMaterialModel>>(
      request: (token) {
        final uri = Uri.parse('$_baseUrl/$supplierId/variants').replace(
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
            .map(
              (e) => SupplierMaterialModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      },
      fallback: <SupplierMaterialModel>[],
    );
  }
}
