import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Api_Error_Handler.dart';
import 'package:stock_mate_project/core/models/Request_Model.dart';

class GetUrgentDepartmentRequestsService {
  Future<List<RequestModel>> getUrgentDepartmentRequestsService() async {
    try {
      final http.Response response = await http
          .get(
            Uri.parse(
              'https://grud-2y91.onrender.com/api/request-orders/pending/urgent',
            ), //TODO TOken
            headers: {
              'Accept': 'application/json',
              'Authorization':
                  'Bearer 23|RkmrnP7Yu8yUd9iDbJ2uboTmRU4ZoOj28XHRWGKI8dd678c7',
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

  List<RequestModel> _parseResponse(String body) {
    final dynamic jsonBody = jsonDecode(body);

    if (jsonBody is! Map<String, dynamic> || jsonBody['data'] is! List) {
      return [];
    }

    final List<dynamic> data = jsonBody['data'];
    final List<RequestModel> requests = [];

    for (final item in data) {
      try {
        if (item is Map<String, dynamic>) {
          requests.add(RequestModel.fromJson(item));
        }
      } catch (_) {
        // تجاهل العنصر التالف بدل ما توقف كل القائمة
        continue;
      }
    }

    return requests;
  }
}
