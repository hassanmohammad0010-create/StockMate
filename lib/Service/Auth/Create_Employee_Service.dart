import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';

class CreateEmployeeService {
  createEmployeeService({
    required String email,
    String? department,
    required String name,
    required String role,
  }) async {
    http.Response response = await http.post(
      Uri.parse('https://grud-2y91.onrender.com/api/create-employee'),
      body: {
        'email': 'asd@head.com',
        'department': 'داخلية',
        'name': 'ahmad',
        'role': 'department_head',
      },
      headers: {
        'Accept': 'application/json',
        'Authorization':
            'Bearer 17|ByhLvoqPYDwjmdvyJjxfI0ClhIfiCZAIXUXeUng5727c42c1',
      },
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      customSnackBar(
        title: 'تمت العملية بنجاح',
        message: data['message'],
        color: constColor,
        messageColor: constLightBlue,
      );
    } else {
      customSnackBar(
        title: 'Wrong',
        message: data['message'],
        color: constRed,
        messageColor: constLightRed,
      );
    }
  }
}
