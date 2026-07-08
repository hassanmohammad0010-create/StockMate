import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Api_Error_Handler.dart';
import 'package:stock_mate_project/core/models/Supplier_Model.dart';

class GetSuppliersService {
  Future<List<SupplierModel>> getSuppliersService() async {
    final Uri url = Uri.parse(
      'https://grud-2y91.onrender.com/api/get-all-Suppliers',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 15));
      print(response.statusCode);
      if (response.statusCode == 200) {
        return _parseResponse(response.body);
      }

      ApiErrorHandler.handleStatusCode(response.statusCode);
      return [];
    } catch (e) {
      print('DEBUG ERROR TYPE: ${e.runtimeType}');
      print('DEBUG ERROR: $e');
      ApiErrorHandler.handleException(e);
      return [];
    }
  }

  List<SupplierModel> _parseResponse(String body) {
    final dynamic jsonBody = jsonDecode(body);

    if (jsonBody is! Map<String, dynamic> || jsonBody['data'] is! List) {
      return [];
    }

    final List<dynamic> data = jsonBody['data'];
    final List<SupplierModel> suppliers = [];

    for (final item in data) {
      try {
        if (item is Map<String, dynamic>) {
          suppliers.add(SupplierModel.fromJson(item));
        }
      } catch (_) {
        continue; // تجاهل العنصر التالف بدل ما توقف كل القائمة
      }
    }

    return suppliers;
  }
}
