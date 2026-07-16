import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/chat_controller.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    final h = context.screenHeight;
    final w = context.screenWidth;

    return AppBar(
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => Scaffold.of(context).openDrawer(),
        tooltip: "سجل المحادثات",
      ),
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.05),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "StockMate Assistant",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "Powered by AI",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(width: w * 0.05),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.015,
                vertical: h * 0.005,
              ),
              decoration: BoxDecoration(
                color: constLightBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy, color: constBlue, size: 22),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => controller.newChat(),
          icon: const Icon(Icons.add_comment_outlined),
          tooltip: "محادثة جديدة",
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
