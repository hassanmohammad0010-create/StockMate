import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/chat_controller.dart';

class MessageInput extends StatelessWidget {
  MessageInput({super.key});

  final ChatController controller = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: controller.messageController,
                minLines: 1,
                maxLines: 6,
                textInputAction: TextInputAction.send,
                enabled: !controller.isTyping.value,
                onSubmitted: (_) {
                  if (!controller.isTyping.value) {
                    controller.sendMessage();
                  }
                },
                decoration: InputDecoration(
                  hintText: controller.isTyping.value
                      ? "جاري التفكير..."
                      : "اسأل StockMate Assistant...",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: w * 0.04,
                    vertical: h * 0.012,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(width: w * 0.02),
            Obx(() {
              // زر الإيقاف عند الكتابة
              if (controller.isTyping.value) {
                return FloatingActionButton(
                  heroTag: "stop_message",
                  mini: true,
                  elevation: 0,
                  backgroundColor: constRed,
                  onPressed: controller.stopGeneration,
                  child: const Icon(Icons.stop, color: Colors.white, size: 28),
                );
              }

              // زر الإرسال
              return SizedBox(
                height: h * 0.05,
                width: w * 0.12,
                child: FloatingActionButton(
                  heroTag: "send_message",
                  mini: true,
                  elevation: 0,
                  backgroundColor: constBlue,
                  onPressed: controller.sendMessage,
                  child: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              );
            }),
            SizedBox(width: w * 0.02),
          ],
        ),
      ),
    );
  }
}
