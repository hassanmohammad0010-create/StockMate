// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Token_Storage.dart';
import 'package:stock_mate_project/View/Screens/App/Main_Page.dart';
import 'package:stock_mate_project/View/Screens/OnBording/On_Bording_App_View.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/main.dart';

class SplashViewController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    Future.delayed(const Duration(seconds: 3), () async {
      await TokenStorage.getAccessToken() == null
          ? {
              onBordingSharedPreferences!.getBool('onBording') == null
                  ? Get.off(() => OnBordingAppViewPage())
                  : Get.offNamed(AppRoutes.LoginPage),
            }
          : Get.offAll(() => MainPage());
    });
  }
}
