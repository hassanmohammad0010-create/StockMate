import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Service/Chat_Bot_Controller.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Chat_Bubble_Widget.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Chat_Input_Field_Widget.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Typing_Indicator_Widget.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  late final ChatBotController controller;

  @override
  void initState() {
    super.initState();
    // ✅ ينشأ الكونترولر عند دخول الصفحة (بدون Binding)
    controller = Get.put(ChatBotController());
  }

  @override
  void dispose() {
    // ✅ يُحذف الكونترولر عند الخروج من الصفحة
    Get.delete<ChatBotController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constBackgroundColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                final messages = controller.messages;
                final showTyping = controller.isSending.value;

                return ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  itemCount: messages.length + (showTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == messages.length) {
                      return const TypingIndicatorWidget();
                    }
                    final message = messages[index];
                    return ChatBubbleWidget(
                      message: message,
                      onRetry: message.isError
                          ? () => controller.retryMessage(message)
                          : null,
                    );
                  },
                );
              }),
            ),
            Obx(
              () => ChatInputFieldWidget(
                controller: controller.textController,
                isSending: controller.isSending.value,
                onSend: controller.sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      titleSpacing: 0,
      iconTheme: IconThemeData(color: constColor),
      title: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: constLightBlue,
            child: Icon(Icons.support_agent_rounded, color: constBlue),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'المساعد الذكي',
                style: TextStyle(
                  fontFamily: cairo,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: constColor,
                ),
              ),
              Text(
                'متصل الآن',
                style: TextStyle(
                  fontFamily: cairo,
                  fontSize: 11.5,
                  color: constGreen,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'محادثة جديدة',
          icon: Icon(Icons.refresh_rounded, color: constGray),
          onPressed: () => _confirmClearChat(context),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  void _confirmClearChat(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'بدء محادثة جديدة',
          style: TextStyle(fontFamily: cairo, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'سيتم مسح المحادثة الحالية، هل أنت متأكد؟',
          style: TextStyle(fontFamily: cairo, fontSize: 13.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'إلغاء',
              style: TextStyle(fontFamily: cairo, color: constGray),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.clearChat();
              Get.back();
            },
            child: Text(
              'تأكيد',
              style: TextStyle(
                fontFamily: cairo,
                color: constRed,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
