// lib/Service/Department_Service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';

class DepartmentService {
  static const String _baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  /// POST /departments
  /// [name] اسم القسم (مطلوب)
  /// [type] نوع القسم مثل "standard" (مطلوب)
  /// [hasQueue] هل يملك القسم قائمة انتظار (مطلوب)
  /// يرجع true عند النجاح (201) و false عند أي فشل
  /// جميع الأخطاء تُعالج تلقائياً عبر Dispatcher + ApiErrorHandler
  static Future<bool> createDepartment({
    required String name,
    required String type,
    required bool hasQueue,
  }) {
    return Dispatcher().send<bool>(
      request: (token) => http.post(
        Uri.parse('$_baseUrl/departments'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'name': name, 'type': type, 'hasQueue': hasQueue}),
      ),
      onSuccess: (body) {
        final Map<String, dynamic> jsonBody = jsonDecode(body);
        final bool isSuccess = jsonBody['success'] == true;

        if (isSuccess) {
          customSnackBar(
            title: 'تم بنجاح',
            message: 'تم إنشاء القسم بنجاح',
            color: constBlue,
            messageColor: constLightBlue,
          );
        }
        return isSuccess;
      },
      fallback: false,
    );
  }
}
