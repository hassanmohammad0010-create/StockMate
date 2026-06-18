import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/core/models/Material_Model.dart';

class GetMedicineItemsService {
  Future<List<MaterialItem>> getMedicineItemsService() async {
    http.Response response = await http.get(
      Uri.parse(
        'https://grud-2y91.onrender.com/api/warehouse/products/medicine',
      ),
      headers: {
        'Accept': 'application/json',
        'Authorization': '1|SfcbNRti68N8PRTHP9VhxoTuFN5KgebevoCTRUVj28a9a130',
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
