// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:stock_mate_project/Service/App/lock_service.dart';

enum LockSetupStep {
  createPin, // إدخال PIN لأول مرة
  confirmPin, // إعادة إدخال نفس PIN للتأكيد
  biometricOffer, // هل يريد إضافة بصمة كخيار سريع؟
  done,
}

class LockSetupController extends GetxController {
  final LockService _lockService = LockService.instance;

  static const int pinLength = 4; // نفس القيمة المستخدمة في LockController

  final Rx<LockSetupStep> step = LockSetupStep.createPin.obs;

  final RxString firstPin = ''.obs;
  final RxString currentInput = ''.obs;
  final RxBool isError = false.obs;

  // نوع البصمة المتاحة فعلياً على الجهاز
  final RxBool deviceSupportsFingerprint = false.obs;
  final RxBool deviceSupportsFace = false.obs;
  final RxBool isCheckingDevice = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkDeviceBiometrics();
  }

  Future<void> _checkDeviceBiometrics() async {
    isCheckingDevice.value = true;
    final supported = await _lockService.isDeviceBiometricSupported();
    // ignore: avoid_print
    print('DEBUG: isDeviceBiometricSupported = $supported');
    if (supported) {
      final types = await _lockService.availableBiometrics();
      // ignore: avoid_print
      print('DEBUG: availableBiometrics = $types');
      deviceSupportsFingerprint.value = types.contains(
        BiometricType.fingerprint,
      ) || types.contains(BiometricType.strong) || types.contains(BiometricType.weak);
      deviceSupportsFace.value = types.contains(BiometricType.face);
    }
    // ignore: avoid_print
    print('DEBUG: fingerprint=${deviceSupportsFingerprint.value}, face=${deviceSupportsFace.value}');
    isCheckingDevice.value = false;
  }

  // ---------------------------------------------------------------------
  // إدخال الأرقام (يُستخدم في مرحلتي createPin و confirmPin)
  // ---------------------------------------------------------------------

  void addDigit(String digit) {
    if (currentInput.value.length >= pinLength) return;
    isError.value = false;
    currentInput.value += digit;

    if (currentInput.value.length == pinLength) {
      _handlePinComplete();
    }
  }

  void removeDigit() {
    if (currentInput.value.isEmpty) return;
    isError.value = false;
    currentInput.value =
        currentInput.value.substring(0, currentInput.value.length - 1);
  }

  Future<void> _handlePinComplete() async {
    if (step.value == LockSetupStep.createPin) {
      // احفظ الرقم الأول مؤقتاً وانتقل لمرحلة التأكيد
      firstPin.value = currentInput.value;
      currentInput.value = '';
      step.value = LockSetupStep.confirmPin;
      return;
    }

    if (step.value == LockSetupStep.confirmPin) {
      if (currentInput.value == firstPin.value) {
        // تطابق الرقمان: احفظ الـ PIN فعلياً وفعّل القفل
        await _lockService.setPin(firstPin.value);
        await _lockService.setLockEnabled(true);
        currentInput.value = '';

        // لو الجهاز لا يدعم أي بصمة، تخطَّ خطوة العرض مباشرة
        if (!deviceSupportsFingerprint.value && !deviceSupportsFace.value) {
          step.value = LockSetupStep.done;
        } else {
          step.value = LockSetupStep.biometricOffer;
        }
      } else {
        // لم يتطابق: أظهر خطأ وأعد المستخدم لمرحلة إنشاء PIN من جديد
        isError.value = true;
        currentInput.value = '';
        Future.delayed(const Duration(milliseconds: 800), () {
          isError.value = false;
          firstPin.value = '';
          step.value = LockSetupStep.createPin;
        });
      }
    }
  }

  // ---------------------------------------------------------------------
  // مرحلة عرض البصمة
  // ---------------------------------------------------------------------

  /// المستخدم اختار "نعم، أضف بصمة" لنوع معيّن (إصبع أو وجه)
  /// نطلب مصادقة فعلية أولاً للتأكد إن البصمة تعمل، ثم نفعّلها
  Future<bool> enableBiometric() async {
    final success = await _lockService.authenticateWithBiometrics();
    if (success) {
      await _lockService.setBiometricEnabled(true);
      step.value = LockSetupStep.done;
      return true;
    }
    return false;
  }

  void skipBiometric() {
    step.value = LockSetupStep.done;
  }

  String get title {
    switch (step.value) {
      case LockSetupStep.createPin:
        return 'أنشئ رمز القفل';
      case LockSetupStep.confirmPin:
        return 'أعد إدخال الرمز للتأكيد';
      case LockSetupStep.biometricOffer:
        return 'إضافة بصمة';
      case LockSetupStep.done:
        return 'تم الإعداد';
    }
  }
}