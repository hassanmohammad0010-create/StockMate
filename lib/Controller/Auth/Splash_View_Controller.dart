// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';

class SplashViewController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed(AppRoutes.LoginPage);
    //  Get.to(HasanServiceTester());
    });
  }
}
