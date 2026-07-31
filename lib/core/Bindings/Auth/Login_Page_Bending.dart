// lib/View/Screens/Auth/Binding/Login_Binding.dart
import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Loading%20Indecator%20Controller/Loading_Indicator_Controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoadingIndicatorController>(() => LoadingIndicatorController());
  }
}
