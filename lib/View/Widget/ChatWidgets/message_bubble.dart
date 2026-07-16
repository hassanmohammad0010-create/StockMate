// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/models/chat_message.dart';
import 'package:stock_mate_project/Controller/App/chat_controller.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isLastMessage;

  const MessageBubble({
    super.key,
    required this.message,
    this.isLastMessage = false,
  });

  /// دالة مخصصة لتنسيق الوقت
  String _formatTime(DateTime dateTime) {
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String period = hour >= 12 ? 'م' : 'ص';
    hour = hour % 12;
    if (hour == 0) hour = 12;
    String minuteString = minute.toString().padLeft(2, '0');
    return '$hour:$minuteString $period';
  }

  /// دالة نسخ الرسالة مع إشعار
  void _copyMessage(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text("تم نسخ الرسالة بنجاح"),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: constGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    final controller = Get.find<ChatController>();
    final timeString = _formatTime(message.time);

    final h = context.screenHeight;
    final w = context.screenWidth;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: h * 0.005),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ═══════════════════════════════════════
            // 🔹 الفقاعة الرئيسية
            // ═══════════════════════════════════════
            // ═══════════════════════════════════════
            // 🔹 الفقاعة الرئيسية
            // ═══════════════════════════════════════
            GestureDetector(
              onLongPress: () => _copyMessage(context, message.message),
              child: Container(
                margin: EdgeInsets.only(bottom: h * 0.005),
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.03,
                  vertical: h * 0.015,
                ),
                constraints: BoxConstraints(maxWidth: w * .80),
                decoration: BoxDecoration(
                  color: message.isError
                      ? Colors.orange.shade50
                      : isUser
                      ? constBlue
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isUser ? 16 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 16),
                  ),
                  border: message.isError
                      ? Border.all(color: Colors.orange.shade200, width: 1)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // شريط خطأ علوي
                    if (message.isError)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: constOrange,
                            ),
                            SizedBox(width: w * 0.01),
                            Text(
                              "تنبيه",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: constOrange,
                              ),
                            ),
                          ],
                        ),
                      ),

                    MarkdownBody(
                      selectable: true,
                      data: message.message,
                      onTapLink: (text, href, title) {},
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          color: message.isError
                              ? constOrange
                              : isUser
                              ? Colors.white
                              : constColor,
                          fontSize: 15,
                          height: 1.5,
                        ),
                        strong: TextStyle(
                          color: message.isError
                              ? constOrange
                              : isUser
                              ? Colors.white
                              : constColor,
                          fontWeight: FontWeight.bold,
                        ),
                        code: TextStyle(
                          fontFamily: "monospace",
                          backgroundColor: isUser
                              ? Colors.white.withOpacity(0.2)
                              : Colors.grey.shade200,
                          color: isUser ? Colors.white : constColor,
                        ),
                        codeblockDecoration: BoxDecoration(
                          color: isUser
                              ? Colors.black.withOpacity(0.3)
                              : Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        h1: TextStyle(
                          color: isUser ? Colors.white : constColor,
                          fontWeight: FontWeight.bold,
                        ),
                        h2: TextStyle(
                          color: isUser ? Colors.white : constColor,
                          fontWeight: FontWeight.bold,
                        ),
                        listBullet: TextStyle(
                          color: isUser ? Colors.white : constColor,
                        ),
                      ),
                    ),

                    // مؤشر البث اللحظي
                    if (message.isStreaming)
                      Padding(
                        padding: EdgeInsets.only(top: h * 0.01),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: w * 0.05,
                              height: h * 0.015,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: isUser ? Colors.white : constBlue,
                              ),
                            ),
                            SizedBox(width: w * 0.01),
                            Text(
                              "جاري الكتابة...",
                              style: TextStyle(
                                fontSize: 11,
                                color: isUser
                                    ? Colors.white70
                                    : Colors.grey.shade600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // زر إعادة المحاولة داخل فقاعة الخطأ
                    if (message.isError && !message.isStreaming)
                      Padding(
                        padding: EdgeInsets.only(top: h * 0.015),
                        child: InkWell(
                          onTap: () {
                            final controller = Get.find<ChatController>();
                            controller.regenerateLastResponse();
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: constOrange),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.refresh,
                                  size: 14,
                                  color: constOrange,
                                ),
                                SizedBox(width: w * 0.01),
                                Text(
                                  "إعادة المحاولة",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: constOrange,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ═══════════════════════════════════════
            // 🔹 التاريخ والأزرار (خارج الفقاعة)
            // ═══════════════════════════════════════
            if (!message.isStreaming)
              Padding(
                padding: EdgeInsets.only(
                  left: isUser ? 0 : 8,
                  right: isUser ? 8 : 0,
                  top: 2,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // الوقت
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: Colors.grey.shade500,
                    ),
                    SizedBox(width: w * 0.01),
                    Text(
                      timeString,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    // زر النسخ
                    SizedBox(width: w * 0.02),
                    InkWell(
                      onTap: () => _copyMessage(context, message.message),
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.copy_rounded,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),

                    // زر إعادة التوليد (للمساعد فقط وآخر رسالة)
                    if (!isUser && isLastMessage && !message.isError) ...[
                      SizedBox(width: w * 0.01),
                      InkWell(
                        onTap: controller.regenerateLastResponse,
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.refresh_rounded,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
