import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Service/Auth/Resent_OTB_Service.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';

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
    try {
      final service = ResentOtbService();
      final result = await service.resentOTBService(email: email);
      if (result == success) {
        customSnackBar(
          color: constColor,
          messageColor: constLightBlue,
          title: 'نجاح',
          message: 'تم إعادة إرسال رمز التحقق بنجاح',
        );
        startTimer();
      } else {
        customSnackBar(
          color: constRed,
          messageColor: constLightRed,
          title: 'خطأ',
          message: 'فشل إعادة إرسال رمز التحقق. الرجاء المحاولة مرة أخرى',
        );
      }
    } catch (e) {
      customSnackBar(
        color: constRed,
        messageColor: constLightRed,
        title: 'خطأ',
        message: 'حدث خطأ ما. الرجاء المحاولة لاحقاً',
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
