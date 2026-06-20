import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/core/models/Material_Model.dart';

class GetConsumableItemsService {
  Future<List<MaterialItem>> getConsumableItemsService() async {
    http.Response response = await http.get(
      Uri.parse(
        'https://grud-2y91.onrender.com/api/warehouse/products/consumable',
      ),
      headers: {
        'Accept': 'application/json',
        'Authorization': '13|MQbA7ZwgTfKbxWxQ9MyR2B4UjNiIMSanRDzLBak362697e89',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = jsonDecode(response.body);
      final List<dynamic> data = jsonBody['data'];

      return data
          .map((item) => MaterialItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('فشل تحميل البيانات: ${response.statusCode}');
    }
  }
}
