import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Service/App/Chat_Bot_Service.dart';
import 'package:stock_mate_project/core/models/Chat_Message_Model.dart';

class ChatBotController extends GetxController {
  final ChatBotService _service = ChatBotService();

  /// سجل الرسائل المعروضة بالشاشة (يشمل رسائل المستخدم والمساعد)
  final RxList<ChatMessageModel> messages = <ChatMessageModel>[].obs;

  /// true أثناء انتظار رد المساعد
  final RxBool isSending = false.obs;

  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    // رسالة ترحيب مبدئية (اختياري - احذفها لو ما بدك ترحيب تلقائي)
    messages.add(
      ChatMessageModel.assistant('مرحبًا! كيف يمكنني مساعدتك اليوم؟'),
    );
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  /// يرسل رسالة المستخدم الحالية للمساعد
  Future<void> sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty || isSending.value) return;

    // history لازم تُبنى قبل إضافة رسالة المستخدم الجديدة،
    // لأنها تمثل "المحادثة السابقة" بالنسبة للرسالة الحالية
    final history = messages
        .where((m) => !m.isSending && !m.isError)
        .toList(growable: false);

    final userMessage = ChatMessageModel.user(text);
    messages.add(userMessage);
    textController.clear();

    isSending.value = true;
    _scrollToBottom();

    final response = await _service.sendMessage(
      message: text,
      history: history,
      platform: 'mobile', // أو 'web' حسب المنصة
    );

    isSending.value = false;

    if (response != null && response.success && response.reply.isNotEmpty) {
      messages.add(ChatMessageModel.assistant(response.reply));
    } else {
      // فشل الطلب — ApiErrorHandler عرض الـ Snackbar المناسب تلقائيًا
      // هون بس بنعلّم آخر رسالة إنها فشلت عشان نعرض للمستخدم خيار إعادة المحاولة
      final lastIndex = messages.indexOf(userMessage);
      if (lastIndex != -1) {
        messages[lastIndex] = userMessage.copyWith(isError: true);
      }
    }

    _scrollToBottom();
  }

  /// إعادة محاولة إرسال رسالة فشلت
  Future<void> retryMessage(ChatMessageModel failedMessage) async {
    final index = messages.indexOf(failedMessage);
    if (index == -1) return;

    messages.removeAt(index);
    textController.text = failedMessage.content;
    await sendMessage();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// يفرّغ المحادثة الحالية (بداية جلسة جديدة محليًا)
  void clearChat() {
    messages.clear();
    messages.add(
      ChatMessageModel.assistant('مرحبًا! كيف يمكنني مساعدتك اليوم؟'),
    );
  }
}
