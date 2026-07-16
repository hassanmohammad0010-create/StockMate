// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/chat_controller.dart';
import 'package:stock_mate_project/View/Widget/ChatWidgets/chat_app_bar.dart';
import 'package:stock_mate_project/View/Widget/ChatWidgets/message_input.dart';
import 'package:stock_mate_project/View/Widget/ChatWidgets/message_list.dart';
import 'package:stock_mate_project/View/Widget/ChatWidgets/chat_history_drawer.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  final ChatController controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return GestureDetector(
      onTap: () => FocusScope.of(
        context,
      ).unfocus(), // لإخفاء لوحة المفاتيح عند النقر خارجها
      child: Scaffold(
        appBar: const ChatAppBar(),
        drawer: const ChatHistoryDrawer(),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(child: MessageList()),
                  MessageInput(),
                ],
              ),

              // زر النزول للأسفل العائم
              Obx(() {
                if (!controller.showScrollButton.value) {
                  return const SizedBox.shrink();
                }
                return Positioned(
                  bottom: 80,
                  right: 16,
                  child: GestureDetector(
                    onTap: controller.scrollToBottomManually,
                    child: Container(
                      width: w * 0.12,
                      height: h * 0.06,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: constBlue,
                        size: 28,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
