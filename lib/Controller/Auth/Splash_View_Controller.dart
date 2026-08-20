// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Token_Storage.dart';
import 'package:stock_mate_project/View/Screens/App/Doctor/Doctor_Home_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Main_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20Purchasing%20committee/Main_Page_Heap_of_Purchasing.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Department-Heads_Main_Page.dart';
import 'package:stock_mate_project/View/Screens/OnBording/On_Bording_App_View.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/main.dart';

class SplashViewController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    Future.delayed(const Duration(seconds: 3), () async {
      final token = await TokenStorage.getAccessToken();

      if (token == null) {
        onBordingSharedPreferences!.getBool('onBording') == null
            ? Get.off(() => OnBordingAppViewPage())
            : Get.offNamed(AppRoutes.LoginPage);
        return;
      }

      // ✅ فيه توكن → نحدد الصفحة بناءً على الرول
      final String? role = await TokenStorage.getUserRole();

      if (role != null) {
        role == 'department_manager' || role == 'pharmacy_staff'
            ? Get.offAll(() => DepartmentHeadsMainPage())
            : role == 'purchasing_manager'
            ? Get.offAll(() => MainPageHeadOfPurchasingPage())
            : role == 'hospital_manager'
            ? Get.offAll(() => MainPage())
            : role == 'doctor'
            ? Get.offAll(() => DoctorHomePage())
            : Get.offAll(() => MainPage());
      } else {
        // ✅ توكن موجود بس ما قدرنا نجيب الرول → أفضل نرجعه لتسجيل الدخول
        Get.offNamed(AppRoutes.LoginPage);
      }
    });
  }
}
