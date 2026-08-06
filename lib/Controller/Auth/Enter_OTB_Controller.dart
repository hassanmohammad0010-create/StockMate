import 'dart:async';
import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Auth/Login_Service.dart';

class EnterOTBController extends GetxController {
  final String email;
  EnterOTBController({required this.email});

  final RxInt secondsRemaining = 30.obs;
  final RxBool isLoading = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    secondsRemaining.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> resendCode() async {
    if (secondsRemaining.value > 0 || isLoading.value) return;

    isLoading.value = true;

    await LoginService.loginService(email: email);
    isLoading.value = false; // يتنفذ بعد ما تخلص كل الاستدعاءات
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
