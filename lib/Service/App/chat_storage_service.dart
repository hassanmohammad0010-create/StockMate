import 'dart:convert';
import 'package:stock_mate_project/core/models/chat_session.dart';
import 'package:stock_mate_project/main.dart';

class ChatStorageService {
  static const String _sessionsKey = 'chat_sessions_v1';
  
  /// جلب كل المحادثات المحفوظة
  Future<List<ChatSession>> loadAllSessions() async {
    try {
      final jsonString = shareprefs!.getString(_sessionsKey);
      
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => ChatSession.fromJson(json))
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt)); // الأحدث أولاً
    } catch (e) {
      print('خطأ في تحميل المحادثات: $e');
      return [];
    }
  }

  /// حفظ محادثة (إضافة أو تحديث)
  Future<void> saveSession(ChatSession session) async {
    try {
      final sessions = await loadAllSessions();
      
      // حذف المحادثة القديمة إذا كانت موجودة
      sessions.removeWhere((s) => s.id == session.id);
      
      // إضافة المحادثة الجديدة/المحدثة
      sessions.insert(0, session);
      
      // حفظ (يمكنك تحديد حد أقصى مثل 50 محادثة)
      final limitedSessions = sessions.take(50).toList();
      
      final jsonString = json.encode(limitedSessions.map((s) => s.toJson()).toList());
      await shareprefs!.setString(_sessionsKey, jsonString);
    } catch (e) {
      print('خطأ في حفظ المحادثة: $e');
    }
  }

  /// حذف محادثة معينة
  Future<void> deleteSession(String sessionId) async {
    try {
      final sessions = await loadAllSessions();
      sessions.removeWhere((s) => s.id == sessionId);
      
      final jsonString = json.encode(sessions.map((s) => s.toJson()).toList());
      await shareprefs!.setString(_sessionsKey, jsonString);
    } catch (e) {
      print('خطأ في حذف المحادثة: $e');
    }
  }

  /// حذف جميع المحادثات
  Future<void> clearAll() async {
    try {
      await shareprefs!.remove(_sessionsKey);
    } catch (e) {
      print('خطأ في حذف كل المحادثات: $e');
    }
  }
}