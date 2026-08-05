// lib/Service/Role_Service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Role_Model.dart';

class RoleService {
  /// GET /rbac/roles
  /// يرجع لائحة الرولز (id + name فقط حسب RoleModel الحالي)
  /// عند أي فشل (شبكة/سيرفر/بيانات) يرجع [] تلقائيًا مع رسالة خطأ عبر ApiErrorHandler
  static Future<List<RoleModel>> getRoles() {
    return Dispatcher().send<List<RoleModel>>(
      request: (token) => http.get(
        Uri.parse('https://stock-mate-qb40.onrender.com/api/rbac/roles'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      onSuccess: (body) {
        final Map<String, dynamic> jsonBody = jsonDecode(body);

        if (jsonBody['success'] != true || jsonBody['data'] is! List) {
          return <RoleModel>[];
        }

        final List<dynamic> data = jsonBody['data'];
        return data
            .map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      fallback: <RoleModel>[],
    );
  }
}
