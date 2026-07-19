import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Service/App/openrouter_service.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:uuid/uuid.dart';
import 'package:stock_mate_project/Service/App/chat_storage_service.dart';
import 'package:stock_mate_project/core/models/chat_message.dart';
import 'package:stock_mate_project/core/models/chat_session.dart';

class ChatController extends GetxController {
  // final GeminiService _gemini = Get.find<GeminiService>();
  // تغيير GeminiService إلى OpenRouterService
  // final OpenRouterService _ai = Get.find<OpenRouterService>();
  final OpenRouterService _ai = Get.put(OpenRouterService());

  final ChatStorageService _storage = ChatStorageService();

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxList<ChatSession> sessions = <ChatSession>[].obs;
  
  final RxBool isTyping = false.obs;
  final RxBool showScrollButton = false.obs;
  final RxBool isLoadingHistory = false.obs;
  
  // معرف المحادثة الحالية
  String _currentSessionId = const Uuid().v4();
  DateTime _currentSessionCreatedAt = DateTime.now();

  StreamSubscription? _streamSubscription;
  String _lastUserMessage = "";
  
  Timer? _saveDebounceTimer;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    _loadSessions();
  }

  /// تحميل قائمة المحادثات المحفوظة
  Future<void> _loadSessions() async {
    isLoadingHistory.value = true;
    final loadedSessions = await _storage.loadAllSessions();
    sessions.assignAll(loadedSessions);
    isLoadingHistory.value = false;
  }

  void _scrollListener() {
    if (!scrollController.hasClients) return;
    
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    
    if (maxScroll - currentScroll > 150) {
      if (!showScrollButton.value) showScrollButton.value = true;
    } else {
      if (showScrollButton.value) showScrollButton.value = false;
    }
  }

  /// حفظ المحادثة الحالية بشكل تلقائي
  void _autoSaveSession() {
    if (messages.isEmpty) return;
    
    // Debounce: انتظر 2 ثانية قبل الحفظ لتجنب الحفظ المتكرر
    _saveDebounceTimer?.cancel();
    _saveDebounceTimer = Timer(const Duration(seconds: 2), () async {
      final session = ChatSession.fromMessages(
        id: _currentSessionId,
        messages: messages.toList(),
        createdAt: _currentSessionCreatedAt,
      );
      
      await _storage.saveSession(session);
      await _loadSessions(); // تحديث القائمة
    });
  }

  /// حفظ فوري (مهم عند الخروج أو بدء محادثة جديدة)
  Future<void> saveSessionImmediately() async {
    _saveDebounceTimer?.cancel();
    if (messages.isEmpty) return;
    
    final session = ChatSession.fromMessages(
      id: _currentSessionId,
      messages: messages.toList(),
      createdAt: _currentSessionCreatedAt,
    );
    
    await _storage.saveSession(session);
    await _loadSessions();
  }

  /// تحميل محادثة قديمة
  Future<void> loadSession(ChatSession session) async {
    // حفظ المحادثة الحالية أولاً
    await saveSessionImmediately();
    
    _streamSubscription?.cancel();
    _streamSubscription = null;
    
    _currentSessionId = session.id;
    _currentSessionCreatedAt = session.createdAt;
    
    messages.assignAll(session.messages);
    
    _lastUserMessage = "";
    for (final m in session.messages.reversed) {
      if (m.role == MessageRole.user) {
        _lastUserMessage = m.message;
        break;
      }
    }
    
    isTyping.value = false;
    
    Get.back(); // إغلاق الـ Drawer
    
    _scrollToBottom();
    HapticFeedback.lightImpact();
  }

  /// حذف محادثة
  Future<void> deleteSession(String sessionId) async {
    await _storage.deleteSession(sessionId);
    await _loadSessions();
    
    // إذا كانت المحادثة المحذوفة هي الحالية، ابدأ محادثة جديدة
    if (sessionId == _currentSessionId) {
      newChat();
    }
    
    HapticFeedback.mediumImpact();
  }

  /// حذف كل المحادثات
  Future<void> deleteAllSessions() async {
    await _storage.clearAll();
    sessions.clear();
    newChat();
    HapticFeedback.heavyImpact();
  }

    Future<void> sendMessage({String? customText}) async {
    final text = (customText ?? messageController.text).trim();
    if (text.isEmpty) return;

    // فحص الاتصال بالإنترنت
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      customSnackBar(
        title: "📶 لا يوجد اتصال",
        message: "يرجى التحقق من اتصالك بالإنترنت",
        color: constOrange,
        messageColor: Colors.white,
      );
      return;
    }

    messageController.clear();
    HapticFeedback.lightImpact();

    _lastUserMessage = text;
    messages.add(ChatMessage.user(text));
    _scrollToBottom();

    final assistantMessage = ChatMessage.assistant("", isStreaming: true);
    messages.add(assistantMessage);
    _scrollToBottom();

    isTyping.value = true;
    String fullResponse = "";

    try {
      final stream = _ai.sendMessageStream(text);

      _streamSubscription = stream.listen(
        (chunk) {
          fullResponse += chunk;

          if (messages.isNotEmpty) {
            final index = messages.length - 1;
            messages[index] = messages[index].copyWith(message: fullResponse);
            _scrollToBottom();
          }
        },
        onError: (e) {
          print('❌ خطأ في البث: $e');

          if (messages.isNotEmpty) {
            final index = messages.length - 1;
            messages[index] = messages[index].copyWith(
              message: _formatErrorForUser(e.toString()),
              isStreaming: false,
              isError: true,
            );
          }

          isTyping.value = false;
          HapticFeedback.heavyImpact();
          _scrollToBottom();
          _autoSaveSession();
        },
        onDone: () {
          if (messages.isNotEmpty) {
            final index = messages.length - 1;

            final finalMessage = fullResponse.isEmpty
                ? "😕 لم أتمكن من فهم سؤالك.\n\nيرجى إعادة صياغته والمحاولة مرة أخرى."
                : fullResponse;

            messages[index] = messages[index].copyWith(
              message: finalMessage,
              isStreaming: false,
              isError: fullResponse.isEmpty,
            );
          }

          isTyping.value = false;
          HapticFeedback.mediumImpact();
          _scrollToBottom();
          _autoSaveSession();
        },
        cancelOnError: false,
      );
    } catch (e) {
      print('❌ استثناء: $e');

      if (messages.isNotEmpty) {
        final index = messages.length - 1;
        messages[index] = messages[index].copyWith(
          message: _formatErrorForUser(e.toString()),
          isStreaming: false,
          isError: true,
        );
      }

      isTyping.value = false;
      HapticFeedback.heavyImpact();
      _scrollToBottom();
    }
  }

  /// تنسيق رسالة الخطأ للمستخدم (نسخة مبسطة)
  String _formatErrorForUser(String error) {
    final lower = error.toLowerCase();

    if (lower.contains('internet') || lower.contains('network') || lower.contains('socket')) {
      return "📶 **لا يوجد اتصال بالإنترنت**\n\n"
          "يرجى التحقق من اتصالك والمحاولة مرة أخرى.";
    }

    if (lower.contains('timeout')) {
      return "⏱️ **انتهت مهلة الاتصال**\n\n"
          "الخادم يستغرق وقتاً طويلاً. حاول مرة أخرى.";
    }

    if (lower.contains('rate') || lower.contains('429') || lower.contains('limit')) {
      return "⏳ **أرسلت رسائل كثيرة بسرعة**\n\n"
          "انتظر 30 ثانية ثم حاول مجدداً.";
    }

    // إذا كانت الرسالة منقحة بالفعل من Service (تحتوي emoji)
    if (error.contains('🔑') || error.contains('⏳') || 
        error.contains('🤖') || error.contains('📶') ||
        error.contains('⏱️') || error.contains('🔧') ||
        error.contains('🚫') || error.contains('📝') ||
        error.contains('😕') || error.contains('💳')) {
      return error;
    }

    // خطأ عام
    return "😕 **حدث خطأ غير متوقع**\n\n"
        "يرجى المحاولة مرة أخرى بعد قليل.";
  }

  void stopGeneration() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    
    if (messages.isNotEmpty && messages.last.isStreaming) {
      final index = messages.length - 1;
      messages[index] = messages[index].copyWith(
        isStreaming: false,
        message: messages[index].message.isEmpty 
            ? "تم الإيقاف." 
            : "${messages[index].message}\n\n_[تم إيقاف التوليد]_",
      );
    }
    
    isTyping.value = false;
    HapticFeedback.mediumImpact();
    _autoSaveSession();
  }

  Future<void> regenerateLastResponse() async {
    if (_lastUserMessage.isEmpty) return;
    if (messages.isEmpty) return;
    
    if (messages.last.role == MessageRole.assistant) {
      messages.removeLast();
    }
    
    HapticFeedback.lightImpact();
    await sendMessage(customText: _lastUserMessage);
  }

  void sendSuggestedMessage(String message) {
    sendMessage(customText: message);
  }

  void newChat() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    
    // إذا كانت هناك رسائل، احفظها كمحادثة مستقلة
    if (messages.isNotEmpty) {
      saveSessionImmediately();
    }
    
    messages.clear();
    _lastUserMessage = "";
    isTyping.value = false;
    
    // إنشاء معرف جديد للمحادثة الجديدة
    _currentSessionId = const Uuid().v4();
    _currentSessionCreatedAt = DateTime.now();
    
    _ai.startNewChat();
    HapticFeedback.selectionClick();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void scrollToBottomManually() {
    if (!scrollController.hasClients) return;
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    _streamSubscription?.cancel();
    _saveDebounceTimer?.cancel();
    saveSessionImmediately(); // حفظ عند إغلاق الـ Controller
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}