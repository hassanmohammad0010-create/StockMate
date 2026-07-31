import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Auth/Splash_View_Controller.dart';

class SplashViewBending extends Bindings {
  @override
  void dependencies() {
    // ignore: unused_local_variable
    final SplashViewController splashViewController = Get.put(
      SplashViewController(),
    );
  }
}
