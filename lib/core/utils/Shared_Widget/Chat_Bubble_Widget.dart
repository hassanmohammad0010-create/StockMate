import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/models/Chat_Message_Model.dart';

class ChatBubbleWidget extends StatelessWidget {
  final ChatMessageModel message;
  final VoidCallback? onRetry;

  const ChatBubbleWidget({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final bool isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(isUser: false),
          if (!isUser) const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: context.screenWidth * 0.75,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isUser
                        ? constBlue
                        : (message.isError ? constLightRed : Colors.white),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      fontFamily: cairo,
                      fontSize: 14.5,
                      height: 1.5,
                      color: isUser
                          ? Colors.white
                          : (message.isError ? constRed : constColor),
                    ),
                  ),
                ),
                if (message.isError) ...[
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: onRetry,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.refresh, size: 14, color: constRed),
                          const SizedBox(width: 4),
                          Text(
                            'إعادة المحاولة',
                            style: TextStyle(
                              fontFamily: cairo,
                              fontSize: 12,
                              color: constRed,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isUser) const SizedBox(width: 8),
          if (isUser) _buildAvatar(isUser: true),
        ],
      ),
    );
  }

  Widget _buildAvatar({required bool isUser}) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: isUser ? constLightBlue : constBlue,
      child: Icon(
        isUser ? Icons.person_outline : Icons.support_agent_rounded,
        size: 18,
        color: isUser ? constBlue : Colors.white,
      ),
    );
  }
}
