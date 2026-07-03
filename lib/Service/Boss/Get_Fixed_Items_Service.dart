import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Api_Error_Handler.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';

class GetFixedItemsService {
  Future<List<MaterialItem>> getFixedItemsService() async {
    final Uri url = Uri.parse(
      'https://grud-2y91.onrender.com/api/warehouse/products/fixed',
    );
    //TODO
    try {
      final response = await http
          .get(
            url,
            headers: {
              'Accept': 'application/json',
              'Authorization':
                  'Bearer 1|SfcbNRti68N8PRTHP9VhxoTuFN5KgebevoCTRUVj28a9a130',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return _parseResponse(response.body);
      }

      ApiErrorHandler.handleStatusCode(response.statusCode);
      return [];
    } catch (e) {
      ApiErrorHandler.handleException(e);
      return [];
    }
  }

  List<MaterialItem> _parseResponse(String body) {
    final dynamic jsonBody = jsonDecode(body);

    if (jsonBody is! Map<String, dynamic> || jsonBody['data'] is! List) {
      return [];
    }

    final List<dynamic> data = jsonBody['data'];
    final List<MaterialItem> items = [];

    for (final item in data) {
      try {
        if (item is Map<String, dynamic>) {
          items.add(MaterialItem.fromJson(item));
        }
      } catch (_) {
        continue;
      }
    }

    return items;
  }
}
