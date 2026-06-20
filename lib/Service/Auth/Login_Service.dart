// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Constant/Const.dart';
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
    print('response reached');
    Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      customSnackBar(
        color: constColor,
        messageColor: constLightBlue,
        title: 'Welcome back',
        message: 'We are happy you are back',
      );
      print(data['token']);
      tokenSharedPreferences!.setString('Token', data['token']);
      return data['user']['name'];
    } else {
      customSnackBar(
        color: constRed,
        messageColor: constLightRed,
        title: 'Warning',
        message: data['message'],
      );
      return null;
    }
  }
}
