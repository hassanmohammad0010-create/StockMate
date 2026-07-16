import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/chat_controller.dart';
import 'message_bubble.dart';
import 'welcome_screen.dart';

class MessageList extends StatelessWidget {
  MessageList({super.key});

  final controller = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return Obx(() {
      // شاشة الترحيب عند عدم وجود رسائل
      if (controller.messages.isEmpty) {
        return const WelcomeScreen();
      }

      return ListView.builder(
        controller: controller.scrollController,
        padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.02),
        itemCount: controller.messages.length,
        itemBuilder: (_, index) {
          final message = controller.messages[index];

          return MessageBubble(
                message: message,
                isLastMessage: index == controller.messages.length - 1,
              )
              .animate()
              .fadeIn(duration: 300.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic);
        },
      );
    });
  }
}
