/// دور المُرسِل داخل المحادثة — مطابق تمامًا للقيم اللي يتوقعها السيرفر
/// في حقل history: "user" أو "assistant"
class ChatRole {
  static const String user = 'user';
  static const String assistant = 'assistant';
}

/// موديل الرسالة الواحدة داخل الشات
///
/// يُستخدم لغرضين:
/// 1) عرض الرسالة في الـ UI (فقاعة شات)
/// 2) تحويلها إلى الشكل اللي يتوقعه الباك اند داخل history:
///    { "role": "user" | "assistant", "content": "..." }
class ChatMessageModel {
  final String role;
  final String content;
  final DateTime timestamp;

  /// true لو الرسالة لسا عم تُرسل / بانتظار الرد (اختياري - لعرض مؤشر تحميل محلي)
  final bool isSending;

  /// true لو صار خطأ بإرسال هالرسالة (اختياري - لعرض زر "إعادة المحاولة")
  final bool isError;

  ChatMessageModel({
    required this.role,
    required this.content,
    DateTime? timestamp,
    this.isSending = false,
    this.isError = false,
  }) : timestamp = timestamp ?? DateTime.now();

  bool get isUser => role == ChatRole.user;
  bool get isAssistant => role == ChatRole.assistant;

  /// الشكل المطلوب إرساله داخل حقل history بالـ request
  Map<String, dynamic> toHistoryJson() {
    return {'role': role, 'content': content};
  }

  ChatMessageModel copyWith({
    String? role,
    String? content,
    DateTime? timestamp,
    bool? isSending,
    bool? isError,
  }) {
    return ChatMessageModel(
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isSending: isSending ?? this.isSending,
      isError: isError ?? this.isError,
    );
  }

  factory ChatMessageModel.user(String content) {
    return ChatMessageModel(role: ChatRole.user, content: content);
  }

  factory ChatMessageModel.assistant(String content) {
    return ChatMessageModel(role: ChatRole.assistant, content: content);
  }
}

/// موديل استجابة السيرفر لرسالة الشات بوت
///
/// الشكل الافتراضي المتوقع (بناءً على نمط باقي الـ API عندك):
/// {
///   "success": true,
///   "data": { "reply": "..." }
/// }
///
/// إذا كان شكل الريسبونس الفعلي مختلف (مثلاً حقل "message" بدل "reply"،
/// أو "response" بدل "data")، عدّل فقط داخل factory fromJson بالأسفل —
/// باقي الكود (Service, Controller) ما بيحتاج أي تعديل.
class ChatBotResponseModel {
  final bool success;
  final String reply;

  ChatBotResponseModel({required this.success, required this.reply});

  // ─── هذا هو الجزء اللي تغير فقط داخل ChatBotResponseModel.fromJson ───

  factory ChatBotResponseModel.fromJson(Map<String, dynamic> json) {
    final bool success = json['success'] == true;

    // نحاول نقرأ الرد من أكثر من مكان محتمل، تحسبًا لاختلاف بسيط بشكل الـ response
    String reply = '';
    final dynamic data = json['data'];

    if (data is Map<String, dynamic>) {
      reply =
          (data['answer'] ??
                  data['reply'] ??
                  data['message'] ??
                  data['response'] ??
                  '')
              .toString();
    } else if (data is String) {
      reply = data;
    } else {
      reply = (json['reply'] ?? json['message'] ?? '').toString();
    }

    return ChatBotResponseModel(success: success, reply: reply);
  }
}
