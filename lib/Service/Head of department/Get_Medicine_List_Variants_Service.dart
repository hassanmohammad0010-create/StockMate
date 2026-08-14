// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Medicine_List_Variant.dart';

/// سيرفس جلب قائمة الأدوية (Variants) للوصفات الطبية
/// GET /catalog/variants?page=1&limit=20&isActive=true&search=
class GetMedicineVariantsService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  /// ✅ جلب الأدوية — يرجع قائمة مباشرة (نفس نمط MedicineService)
  Future<List<MedicineVariant>> getVariants({
    int page = 1,
    int limit = 20,
    bool isActive = true,
    String search = '', // ✅ جاهز للبحث باسم الدواء لاحقاً
  }) async {
    return _dispatcher.send<List<MedicineVariant>>(
      // ─── الطلب الفعلي: Dispatcher بيمرر التوكن جاهز ───
      request: (token) {
        final uri = Uri.parse(
          '$baseUrl/catalog/variants'
          '?page=$page'
          '&limit=$limit'
          '&isActive=${isActive.toString()}'
          '&search=${Uri.encodeQueryComponent(search)}',
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

      // ─── عند نجاح الطلب: نحوّل الـ body لقائمة MedicineVariant ───
      onSuccess: (body) {
        final jsonData = jsonDecode(body);
        final List itemsJson = jsonData['data']['items'];

        return itemsJson
            .map((item) => MedicineVariant.fromJson(item))
            .toList();
      },

      // ─── القيمة المرتجعة عند أي فشل (قائمة فارغة) ───
      fallback: <MedicineVariant>[],
    );
  }
}