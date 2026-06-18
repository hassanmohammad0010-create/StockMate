import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/main.dart';

class LoginService {
  Future<String?> loginService({
    required String email,
    required String password,
  }) async {
    http.Response response = await http.post(
      Uri.parse('https://grud-2y91.onrender.com/api/login'),
      body: {'email': email, 'password': password},
      headers: {'Accept': 'application/json'},
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      customSnackBar(
        title: 'Welcome back',
        message: 'We are happy you are back',
      );
      print(data['token']);
      // tokenSharedPreferences!.setString('Token', data['token']);
      return data['user']['name'];
    } else {
      customSnackBar(title: 'Warning', message: data['message']);
      return null;
    }
  }
}
