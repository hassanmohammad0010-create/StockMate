import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Api_Error_Handler.dart';
import 'package:stock_mate_project/core/models/Request_Model.dart';

class RequestService {
  Future<List<RequestModel>> getAllDepartmentRequests() async {
    final Uri url = Uri.parse(
      'https://grud-2y91.onrender.com/api/get/department-requests',
    );

    try {
      final response = await http
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
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
    final dynamic jsonData = jsonDecode(body);

    if (jsonData is! Map<String, dynamic> || jsonData['data'] is! List) {
      return [];
    }

    final List<dynamic> data = jsonData['data'];
    final List<RequestModel> requests = [];

    for (final item in data) {
      try {
        if (item is Map<String, dynamic>) {
          requests.add(RequestModel.fromJson(item));
        }
      } catch (_) {
        continue; // تجاهل العنصر التالف بدل ما توقف كل القائمة
      }
    }

    return requests;
  }
}
