import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Auth/Splash_View_Controller.dart';

class SplashViewBending extends Bindings {
  @override
  void dependencies() {
    final SplashViewController splashViewController = Get.put(
      SplashViewController(),
    );
  }
}
