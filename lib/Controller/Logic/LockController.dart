// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Service/App/lock_service.dart';

/// يدير حالة شاشة القفل: إدخال PIN، محاولة البصمة، الأخطاء
///
/// يُستخدم في حالتين:
/// 1) فتح التطبيق (appLaunch) → عند النجاح يوجّه للصفحة الرئيسية
/// 2) تأكيد الهوية قبل إلغاء القفل (confirmDisable) → عند النجاح ينفّذ [onSuccess] المُمرَّرة من الخارج
enum LockControllerMode { appLaunch, confirmDisable }

class LockController extends GetxController {
  LockController({
    this.mode = LockControllerMode.appLaunch,
    this.onSuccess,
  });

  final LockControllerMode mode;

  /// يُستدعى عند نجاح التحقق. مطلوبة فقط في وضع confirmDisable.
  /// في وضع appLaunch، لو تُركت فارغة سيُستخدم التوجيه الافتراضي للصفحة الرئيسية.
  final VoidCallback? onSuccess;

  final LockService _lockService = LockService.instance;

  final RxString enteredPin = ''.obs;
  final RxBool isError = false.obs;
  final RxBool isBiometricAvailable = false.obs;
  final RxBool isCheckingBiometric = false.obs;

  static const int pinLength = 4; // غيّرها إلى 6 لو تفضل PIN من 6 أرقام

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    final biometricEnabled = await _lockService.isBiometricEnabled();
    final deviceSupportsBiometric =
        await _lockService.isDeviceBiometricSupported();
    isBiometricAvailable.value = biometricEnabled && deviceSupportsBiometric;

    // لو البصمة مفعّلة، جرّبها تلقائياً أول ما تفتح الشاشة (تجربة استخدام أسرع)
    if (isBiometricAvailable.value) {
      await tryBiometric();
    }
  }

  /// يُستدعى من لوحة الأرقام (Numpad) في الواجهة
  void addDigit(String digit) {
    if (enteredPin.value.length >= pinLength) return;
    isError.value = false;
    enteredPin.value += digit;

    if (enteredPin.value.length == pinLength) {
      _verifyPin();
    }
  }

  void removeDigit() {
    if (enteredPin.value.isEmpty) return;
    isError.value = false;
    enteredPin.value =
        enteredPin.value.substring(0, enteredPin.value.length - 1);
  }

  Future<void> _verifyPin() async {
    final isCorrect = await _lockService.verifyPin(enteredPin.value);
    if (isCorrect) {
      _onUnlockSuccess();
    } else {
      isError.value = true;
      enteredPin.value = '';
    }
  }

  Future<void> tryBiometric() async {
    if (isCheckingBiometric.value) return;
    isCheckingBiometric.value = true;
    final success = await _lockService.authenticateWithBiometrics();
    isCheckingBiometric.value = false;

    if (success) {
      _onUnlockSuccess();
    }
    // لو فشلت أو ألغاها المستخدم، تبقى شاشة PIN ظاهرة كخيار بديل (لا داعي لإظهار خطأ مزعج)
  }

  void _onUnlockSuccess() {
    if (mode == LockControllerMode.confirmDisable) {
      // في وضع تأكيد الإلغاء: لا نوجّه لأي مكان، فقط ننفّذ ما طلبته الشاشة المستدعية
      onSuccess?.call();
      return;
    }

    // وضع appLaunch: التوجيه الافتراضي للصفحة الرئيسية
    if (onSuccess != null) {
      onSuccess!.call();
    } else {
      // غيّر هذا المسار إلى الصفحة الرئيسية الفعلية لمشروعك
      Get.offAllNamed('/DepartmentHeadsMainPage');
    }
  }
}
