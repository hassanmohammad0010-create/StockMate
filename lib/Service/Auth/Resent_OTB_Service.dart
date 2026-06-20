import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Constant/Const.dart';

class ResentOtbService {
  Future<String> resentOTBService({required String email}) async {
    http.Response response = await http.post(
      Uri.parse('https://grud-2y91.onrender.com/api/resend-otp'),
      body: {'email': email},
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return success;
    } else {
      return fail;
    }
  }
}
