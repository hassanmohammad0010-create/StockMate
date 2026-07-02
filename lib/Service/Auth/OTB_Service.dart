import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/main.dart';

class OtbService {
  Future<String> setOTBService({
    required String email,
    required int otb,
  }) async {
    http.Response response = await http.post(
      Uri.parse('https://grud-2y91.onrender.com/api/verify-otp'),
      body: {'otp': '$otb', 'email': email},
      headers: {'Accept': 'application/json'},
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      tokenSharedPreferences!.setString('Token', data['verification_token']);
      print(data['verification_token']);
      return success;
    } else {
      return fail;
    }
  }
}
