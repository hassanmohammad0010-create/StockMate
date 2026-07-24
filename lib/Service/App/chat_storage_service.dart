import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stock_mate_project/core/models/chat_session.dart';

class ChatStorageService {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static const String _sessionsKey = 'chat_sessions_v1';

  /// جلب كل المحادثات المحفوظة
  Future<List<ChatSession>> loadAllSessions() async {
    try {
      final jsonString = await _secureStorage.read(key: _sessionsKey);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => ChatSession.fromJson(json))
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } catch (e) {
      print('خطأ في تحميل المحادثات: $e');
      return [];
    }
  }

  /// حفظ محادثة (إضافة أو تحديث)
  Future<void> saveSession(ChatSession session) async {
    try {
      final sessions = await loadAllSessions();

      sessions.removeWhere((s) => s.id == session.id);
      sessions.insert(0, session);

      final limitedSessions = sessions.take(50).toList();

      final jsonString =
          json.encode(limitedSessions.map((s) => s.toJson()).toList());
      await _secureStorage.write(key: _sessionsKey, value: jsonString);
    } catch (e) {
      print('خطأ في حفظ المحادثة: $e');
    }
  }

  /// حذف محادثة معينة
  Future<void> deleteSession(String sessionId) async {
    try {
      final sessions = await loadAllSessions();
      sessions.removeWhere((s) => s.id == sessionId);

      final jsonString =
          json.encode(sessions.map((s) => s.toJson()).toList());
      await _secureStorage.write(key: _sessionsKey, value: jsonString);
    } catch (e) {
      print('خطأ في حذف المحادثة: $e');
    }
  }

  /// حذف جميع المحادثات
  Future<void> clearAll() async {
    try {
      await _secureStorage.delete(key: _sessionsKey);
    } catch (e) {
      print('خطأ في حذف كل المحادثات: $e');
    }
  }
}