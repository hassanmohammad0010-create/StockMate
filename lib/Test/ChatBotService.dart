import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/Test/ChatMessageModel.dart';

/// سيرفس الشات بوت / المساعد الذكي
///
/// Endpoint: POST {{baseUrl}}/assistant/message
/// Body:
/// {
///   "message": "...",
///   "history": [ { "role": "user"/"assistant", "content": "..." }, ... ]
/// }
class ChatBotService {
  ChatBotService._internal();
  static final ChatBotService _instance = ChatBotService._internal();
  factory ChatBotService() => _instance;

  final Dispatcher _dispatcher = Dispatcher();

  /// عدّل الرابط هنا إذا كان الـ baseUrl عندك مخزّن بمكان مركزي (Const.dart مثلاً)
  static const String _baseUrl = 'https://stock-mate-qb40.onrender.com/api';
  static const String _endpoint = '$_baseUrl/assistant/message';

  /// يرسل رسالة جديدة للمساعد الذكي مع سجل المحادثة السابق (history)
  ///
  /// يرجع null في حال فشل الطلب (الأخطاء بتتعالج تلقائيًا جوا Dispatcher
  /// عن طريق ApiErrorHandler، فما في داعي تعالج الخطأ يدويًا هون).
  Future<ChatBotResponseModel?> sendMessage({
    required String message,
    required List<ChatMessageModel> history,
  }) async {
    return _dispatcher.send<ChatBotResponseModel?>(
      request: (token) {
        final body = jsonEncode({
          'message': message,
          'history': history.map((e) => e.toHistoryJson()).toList(),
        });

        return http.post(
          Uri.parse(_endpoint),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body,
        );
      },
      onSuccess: (responseBody) {
        final Map<String, dynamic> jsonBody = jsonDecode(responseBody);
        return ChatBotResponseModel.fromJson(jsonBody);
      },
      fallback: null,
      timeout: const Duration(seconds: 30),
    );
  }
}
