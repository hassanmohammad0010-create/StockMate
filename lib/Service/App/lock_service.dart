import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

/// خدمة إدارة قفل التطبيق (PIN + Biometric)
/// - PIN يُخزَّن بشكل آمن عبر flutter_secure_storage (مش SharedPreferences)
/// - البصمة/الوجه تُدار عبر local_auth ويعتمد على النظام (Android/iOS) نفسه
class LockService {
  LockService._();
  static final LockService instance = LockService._();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final LocalAuthentication _localAuth = LocalAuthentication();

  static const _kPinKey = 'app_lock_pin';
  static const _kLockEnabledKey = 'app_lock_enabled';
  static const _kBiometricEnabledKey = 'app_lock_biometric_enabled';

  // ---------------------------------------------------------------------
  // إعدادات عامة: هل القفل مفعّل؟
  // ---------------------------------------------------------------------

  Future<bool> isLockEnabled() async {
    final value = await _secureStorage.read(key: _kLockEnabledKey);
    return value == 'true';
  }

  Future<void> setLockEnabled(bool enabled) async {
    await _secureStorage.write(
      key: _kLockEnabledKey,
      value: enabled.toString(),
    );
    // لو ألغى القفل بالكامل، امسح الـ PIN وتعطيل البصمة أيضاً لتنظيف الحالة
    if (!enabled) {
      await _secureStorage.delete(key: _kPinKey);
      await _secureStorage.write(
        key: _kBiometricEnabledKey,
        value: 'false',
      );
    }
  }

  // ---------------------------------------------------------------------
  // إدارة PIN
  // ---------------------------------------------------------------------

  Future<bool> hasPin() async {
    final pin = await _secureStorage.read(key: _kPinKey);
    return pin != null && pin.isNotEmpty;
  }

  /// إنشاء أو تغيير الـ PIN. يُفضّل التحقق من الطول (مثلاً 4 أو 6 أرقام) في الواجهة قبل الاستدعاء.
  Future<void> setPin(String pin) async {
    await _secureStorage.write(key: _kPinKey, value: pin);
  }

  Future<bool> verifyPin(String enteredPin) async {
    final savedPin = await _secureStorage.read(key: _kPinKey);
    return savedPin != null && savedPin == enteredPin;
  }

  Future<void> removePin() async {
    await _secureStorage.delete(key: _kPinKey);
  }

  // ---------------------------------------------------------------------
  // إدارة البصمة / الوجه (Biometric)
  // ---------------------------------------------------------------------

  /// هل الجهاز يدعم أصلاً بصمة/وجه (سواء مفعّلة بالتطبيق أو لا)؟
  Future<bool> isDeviceBiometricSupported() async {
    try {
      final bool canCheck = await _localAuth.canCheckBiometrics;
      final bool isSupported = await _localAuth.isDeviceSupported();
      return canCheck && isSupported;
    } catch (_) {
      return false;
    }
  }

  /// نوع البصمة المتاحة على الجهاز (بصمة إصبع / وجه / كلاهما)
  Future<List<BiometricType>> availableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (_) {
      return [];
    }
  }

  Future<bool> isBiometricEnabled() async {
    final value = await _secureStorage.read(key: _kBiometricEnabledKey);
    return value == 'true';
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _secureStorage.write(
      key: _kBiometricEnabledKey,
      value: enabled.toString(),
    );
  }

  /// يفتح نافذة النظام الأصلية لطلب البصمة/الوجه
  /// يرجع true لو نجحت المصادقة
  Future<bool> authenticateWithBiometrics() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'الرجاء تأكيد هويتك لفتح التطبيق',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}