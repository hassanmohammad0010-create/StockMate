// lib/Service/Get_Catalog_Variants_Service.dart
// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Catalog_Variants_Page_Data_Model.dart';

/// سيرفس جلب قائمة أصناف الكتالوج
/// GET /catalog/variants
class GetCatalogVariantsService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<CatalogVariantsPageData?> getVariants({
    int page = 1,
    int limit = 20,
  }) async {
    return _dispatcher.send<CatalogVariantsPageData?>(
      request: (token) {
        final uri = Uri.parse(
          '$baseUrl/catalog/variants?page=$page&limit=$limit',
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

      onSuccess: (body) {
        final jsonData = jsonDecode(body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          return CatalogVariantsPageData.fromJson(
            jsonData['data'] as Map<String, dynamic>,
          );
        }

        print('❌ Catalog Variants | success = false: ${jsonData['message']}');
        return null;
      },

      fallback: null,
    );
  }
}
