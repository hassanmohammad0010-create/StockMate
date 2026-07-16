import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/core/Function/api_keys.dart';
import 'package:stock_mate_project/core/Function/prompt_manager.dart';

class OpenRouterService {
  static const String _baseUrl =
      "https://openrouter.ai/api/v1/chat/completions";

  // النماذج المجانية المتاحة:
  // - "google/gemini-2.5-flash" (موصى به)
  // - "google/gemini-2.0-flash-exp:free"
  // - "meta-llama/llama-3.3-70b-instruct:free"
  // - "deepseek/deepseek-chat-v3.1:free"
  // - "qwen/qwen-2.5-72b-instruct:free"
  String _model = "google/gemini-2.5-flash";

  // سجل المحادثة (للحفاظ على السياق)
  final List<Map<String, String>> _chatHistory = [];

  // عميل HTTP لإعادة الاستخدام
  final http.Client _client = http.Client();

  OpenRouterService() {
    _initializeSystemPrompt();
  }

  void _initializeSystemPrompt() {
    if (PromptManager.prompt.isNotEmpty) {
      _chatHistory.add({"role": "system", "content": PromptManager.prompt});
    }
  }

  /// بث الإجابات لحظياً (Streaming) - النسخة المُصححة
  Stream<String> sendMessageStream(String userMessage) async* {
    // إضافة رسالة المستخدم للسجل
    _chatHistory.add({"role": "user", "content": userMessage});

    try {
      // إنشاء طلب يدوي للتحكم في الـ streaming
      final request = http.Request('POST', Uri.parse(_baseUrl));

      request.headers.addAll({
        "Authorization": "Bearer ${ApiKeys.openRouterApiKey}",
        "Content-Type": "application/json",
        "HTTP-Referer": "https://stockmate.app",
        "X-Title": "StockMate Assistant",
      });

      request.body = json.encode({
        "model": _model,
        "messages": _chatHistory,
        "stream": true,
        "temperature": 0.7,
        "max_tokens": 4096,
      });

      // إرسال الطلب والحصول على StreamedResponse
      final response = await _client.send(request);

      if (response.statusCode != 200) {
        final errorBody = await response.stream.bytesToString();
        print('خطأ OpenRouter: $errorBody');

        // إزالة رسالة المستخدم الفاشلة
        _chatHistory.removeLast();

        yield _getFriendlyErrorMessage(errorBody, response.statusCode);
        return;
      }

      String fullResponse = "";
      String buffer = ""; // لتجميع البيانات المقطعة

      // قراءة البث تدريجياً
      await for (final chunk in response.stream.transform(utf8.decoder)) {
        buffer += chunk;

        // تقسيم البيانات إلى أسطر
        final lines = buffer.split('\n');

        // الاحتفاظ بالسطر الأخير غير المكتمل في الـ buffer
        buffer = lines.removeLast();

        for (final line in lines) {
          final trimmed = line.trim();

          if (trimmed.isEmpty || !trimmed.startsWith('data: ')) continue;

          final data = trimmed.substring(6); // حذف "data: "

          if (data == '[DONE]') {
            break;
          }

          try {
            final jsonChunk = json.decode(data);
            final content = jsonChunk['choices']?[0]?['delta']?['content'];

            if (content != null && content is String && content.isNotEmpty) {
              fullResponse += content;
              yield content;
            }
          } catch (e) {
            // تجاهل الأخطاء في تحليل JSON (قد يكون السطر غير مكتمل)
            continue;
          }
        }
      }

      // إضافة رد المساعد للسجل
      if (fullResponse.isNotEmpty) {
        _chatHistory.add({"role": "assistant", "content": fullResponse});
      } else {
        // إزالة رسالة المستخدم إذا لم يكن هناك رد
        _chatHistory.removeLast();
        yield "لم أتمكن من توليد رد. حاول مرة أخرى.";
      }
    } catch (e) {
      print('استثناء OpenRouter: $e');

      // إزالة رسالة المستخدم الفاشلة
      if (_chatHistory.isNotEmpty && _chatHistory.last['role'] == 'user') {
        _chatHistory.removeLast();
      }

      yield _getFriendlyErrorMessage(e.toString(), 0);
    }
  }

  /// طريقة غير streaming (للاختبار السريع)
  Future<String> sendMessage(String userMessage) async {
    _chatHistory.add({"role": "user", "content": userMessage});

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          "Authorization": "Bearer ${ApiKeys.openRouterApiKey}",
          "Content-Type": "application/json",
          "HTTP-Referer": "https://stockmate.app",
          "X-Title": "StockMate Assistant",
        },
        body: json.encode({
          "model": _model,
          "messages": _chatHistory,
          "stream": false,
          "temperature": 0.7,
          "max_tokens": 4096,
        }),
      );

      if (response.statusCode != 200) {
        _chatHistory.removeLast();
        throw Exception(
          _getFriendlyErrorMessage(response.body, response.statusCode),
        );
      }

      final jsonResponse = json.decode(response.body);
      final assistantMessage =
          jsonResponse['choices']?[0]?['message']?['content'] ?? "";

      if (assistantMessage.isNotEmpty) {
        _chatHistory.add({"role": "assistant", "content": assistantMessage});
        return assistantMessage;
      } else {
        _chatHistory.removeLast();
        return "لم يتم تلقي استجابة.";
      }
    } catch (e) {
      if (_chatHistory.isNotEmpty && _chatHistory.last['role'] == 'user') {
        _chatHistory.removeLast();
      }
      throw Exception(_getFriendlyErrorMessage(e.toString(), 0));
    }
  }

  /// بدء محادثة جديدة
  void startNewChat() {
    _chatHistory.clear();
    _initializeSystemPrompt();
  }

  /// تغيير النموذج ديناميكياً
  void changeModel(String newModel) {
    _model = newModel;
  }

  /// الحصول على النموذج الحالي
  String get currentModel => _model;

  /// قائمة النماذج المجانية
  static const List<Map<String, String>> freeModels = [
    {"name": "Gemini 2.5 Flash", "id": "google/gemini-2.5-flash"},
    {"name": "Gemini 2.0 Flash", "id": "google/gemini-2.0-flash-exp:free"},
    {"name": "Llama 3.3 70B", "id": "meta-llama/llama-3.3-70b-instruct:free"},
    {"name": "DeepSeek Chat", "id": "deepseek/deepseek-chat-v3.1:free"},
    {"name": "Qwen 2.5 72B", "id": "qwen/qwen-2.5-72b-instruct:free"},
  ];

  /// تحويل الأخطاء لرسائل ودية
  /// تحويل الأخطاء التقنية إلى رسائل واضحة وودية للمستخدم
  String _getFriendlyErrorMessage(Object error, int statusCode) {
    final errorString = error.toString().toLowerCase();

    // ═══════════════════════════════════════
    // 1. مفتاح API غير صالح (401)
    // ═══════════════════════════════════════
    if (statusCode == 401 || 
        errorString.contains('invalid api key') || 
        errorString.contains('unauthorized') ||
        errorString.contains('authentication')) {
      return "🔑 عذراً، هناك مشكلة في الاتصال بالخدمة.\n\n"
          "يرجى إعادة تشغيل التطبيق والمحاولة مرة أخرى.";
    }

    // ═══════════════════════════════════════
    // 2. تجاوز الحد المسموح (429)
    // ═══════════════════════════════════════
    if (statusCode == 429 || 
        errorString.contains('rate limit') || 
        errorString.contains('too many requests')) {
      return "⏳ أرسلت الكثير من الرسائل في وقت قصير.\n\n"
          "يرجى الانتظار **30 ثانية** ثم المحاولة مجدداً.";
    }

    // ═══════════════════════════════════════
    // 3. النموذج غير متاح (404)
    // ═══════════════════════════════════════
    if (statusCode == 404 || 
        errorString.contains('model not found') || 
        errorString.contains('not exist') ||
        errorString.contains('not found')) {
      return "🤖 المساعد غير متاح حالياً.\n\n"
          "يرجى بدء محادثة جديدة والمحاولة مرة أخرى.";
    }

    // ═══════════════════════════════════════
    // 4. مشكلة في الرصيد (402)
    // ═══════════════════════════════════════
    if (statusCode == 402 || 
        errorString.contains('credits') || 
        errorString.contains('insufficient') ||
        errorString.contains('billing')) {
      return "💳 الخدمة غير متاحة مؤقتاً.\n\n"
          "يرجى المحاولة لاحقاً.";
    }

    // ═══════════════════════════════════════
    // 5. لا يوجد اتصال بالإنترنت
    // ═══════════════════════════════════════
    if (errorString.contains('socketexception') || 
        errorString.contains('network') || 
        errorString.contains('failed host lookup') ||
        errorString.contains('no route to host') ||
        errorString.contains('connection refused')) {
      return "📶 لا يوجد اتصال بالإنترنت.\n\n"
          "يرجى التحقق من اتصال Wi-Fi أو بيانات الهاتف ثم المحاولة.";
    }

    // ═══════════════════════════════════════
    // 6. انتهاء المهلة (Timeout)
    // ═══════════════════════════════════════
    if (errorString.contains('timeout') || 
        errorString.contains('timed out')) {
      return "⏱️ استغرق الاتصال وقتاً أطول من المتوقع.\n\n"
          "يرجى التحقق من سرعة الإنترنت والمحاولة مرة أخرى.";
    }

    // ═══════════════════════════════════════
    // 7. خطأ في الخادم (500, 502, 503)
    // ═══════════════════════════════════════
    if (statusCode == 500 || 
        statusCode == 502 || 
        statusCode == 503 ||
        errorString.contains('internal server') ||
        errorString.contains('bad gateway') ||
        errorString.contains('service unavailable') ||
        errorString.contains('overloaded')) {
      return "🔧 المساعد مشغول حالياً بسبب ضغط الاستخدام.\n\n"
          "يرجى الانتظار **دقيقة** ثم المحاولة مجدداً.";
    }

    // ═══════════════════════════════════════
    // 8. حظر الأمان (Safety)
    // ═══════════════════════════════════════
    if (errorString.contains('safety') || 
        errorString.contains('blocked') ||
        errorString.contains('content policy') ||
        errorString.contains('harmful')) {
      return "🚫 لم أتمكن من الرد على هذا السؤال.\n\n"
          "يرجى إعادة صياغة سؤالك بطريقة مختلفة.";
    }

    // ═══════════════════════════════════════
    // 9. الطلب كبير جداً (413)
    // ═══════════════════════════════════════
    if (statusCode == 413 || 
        errorString.contains('too large') ||
        errorString.contains('token limit') ||
        errorString.contains('context length')) {
      return "📝 المحادثة طويلة جداً.\n\n"
          "يرجى بدء **محادثة جديدة** والمحاولة مرة أخرى.";
    }

    // ═══════════════════════════════════════
    // 10. خطأ عام (أي شيء آخر)
    // ═══════════════════════════════════════
    return "😕 حدث خطأ غير متوقع.\n\n"
        "يرجى المحاولة مرة أخرى بعد قليل.";
  }

  /// تنظيف الموارد
  void dispose() {
    _client.close();
  }
}
