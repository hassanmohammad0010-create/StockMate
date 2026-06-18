import 'package:get/get.dart';
import 'package:stock_mate_project/View/Screens/Auth/Login_Page.dart';
import 'package:stock_mate_project/main.dart';

class SplashViewController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 3), () {
      // Get.offNamed(LoginPage().pageName);
      Get.to(HasanServiceTester());
    });
  }
}
