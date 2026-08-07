import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userRoleKey = 'user_role';
  static const _userNameKey = 'user_name';
  static const _departmentIdKey = 'department_id';
  static const _departmentNameKey = 'department_name';

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  /// تخزين اسم الرول الخاص بالمستخدم
  static Future<void> saveUserRole(String role) async {
    await _storage.write(key: _userRoleKey, value: role);
  }

  /// جلب اسم الرول المخزّن
  static Future<String?> getUserRole() async {
    return await _storage.read(key: _userRoleKey);
  }

  static Future<void> saveDepartmentID(String id) async {
    await _storage.write(key: _departmentIdKey, value: id);
  }

  /// جلب اسم الرول المخزّن
  static Future<String?> getDepartmentID() async {
    return await _storage.read(key: _departmentIdKey);
  }

  /// تخزين اسم المستخدم
  static Future<void> saveUserName(String name) async {
    await _storage.write(key: _userNameKey, value: name);
  }


  static Future<void> saveDepartmentName(String name) async {
    await _storage.write(key: _departmentNameKey, value: name);
  }

  /// جلب اسم المستخدم المخزّن
  static Future<String?> getDepartmentName() async {
    return await _storage.read(key: _departmentNameKey);
  }

   static Future<String?> getUserName() async {
    return await _storage.read(key: _userNameKey);
  }

  static Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userRoleKey);
    await _storage.delete(key: _userNameKey);
  }
}
