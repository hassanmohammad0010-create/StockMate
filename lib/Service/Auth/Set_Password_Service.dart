import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';

class SetPasswordService {
  Future<String> setPasswordService({
    required String verificationToken,
    required String password,
    required String passwordConfirmation,
  }) async {
    http.Response response = await http.post(
      Uri.parse('https://grud-2y91.onrender.com/api/set-password'),
      body: {
        'verification_token': verificationToken,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      customSnackBar(
        color: constColor,
        messageColor: constLightBlue,
        title: 'تمت بنجاح',
        message: 'تم تعيين كلمة المرور الرجاء تسجيل الدخول',
      );
      return success;
    } else {
      return fail;
    }
  }
}
