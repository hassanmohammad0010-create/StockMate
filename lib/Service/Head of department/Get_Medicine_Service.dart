import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Medicine_Model.dart';

class MedicineService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<List<MedicineModel>> getMedicines({
    required String departmentId,
    int page = 1,
    int limit = 20,
    bool isActive = true,
  }) async {
    return _dispatcher.send<List<MedicineModel>>(
      // ─── الطلب الفعلي: Dispatcher بيمرر التوكن جاهز، إحنا بس نبني الطلب ───
      request: (token) {
        final uri = Uri.parse(
          '$baseUrl/stock-settings'
          '?page=$page'
          '&limit=$limit'
          '&departmentId=$departmentId'
          '&isActive=${isActive.toString()}',
        );

        return http.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      },

      // ─── عند نجاح الطلب (status 200): نحوّل الـ body لقائمة MedicineModel ───
      onSuccess: (body) {
        final jsonData = jsonDecode(body);
        final List itemsJson = jsonData['data']['items'];

        return itemsJson
            .map((item) => MedicineModel.fromJson(item))
            .toList();
      },

      // ─── القيمة المرتجعة عند أي فشل (بدل رمي Exception) ───
      fallback: <MedicineModel>[],
    );
  }
}