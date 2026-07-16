import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/chat_controller.dart';
import 'package:stock_mate_project/core/models/chat_session.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/Custom_Dialog.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/DialogType.dart';

class ChatHistoryDrawer extends StatelessWidget {
  const ChatHistoryDrawer({super.key});

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    int hour = date.hour;
    int minute = date.minute;
    String period = hour >= 12 ? 'م' : 'ص';
    hour = hour % 12;
    if (hour == 0) hour = 12;
    String minuteString = minute.toString().padLeft(2, '0');
    String time = '$hour:$minuteString $period';

    if (dateOnly == today) {
      return "اليوم - $time";
    } else if (dateOnly == yesterday) {
      return "أمس - $time";
    } else {
      return "${date.year}/${date.month}/${date.day} - $time";
    }
  }

  void _showDeleteConfirmation(
    BuildContext context,
    ChatController controller,
    ChatSession session,
  ) {
    CustomDialog.show(
      title: 'حذف المحادثة',
      message: "هل تريد حذف '${session.title}'؟",
      onConfirm: () {
        controller.deleteSession(session.id);
        Get.back();
      },
      confirmText: 'حذف',
      type: DialogType.danger,
    );
  }

  void _showDeleteAllConfirmation(
    BuildContext context,
    ChatController controller,
  ) {
    CustomDialog.show(
      title: 'حذف جميع المحادثات',
      message: "سيتم حذف جميع المحادثات نهائياً. هل أنت متأكد؟",
      onConfirm: () {
        controller.deleteAllSessions();
        Get.back();
      },
      confirmText: 'حذف الكل',
      type: DialogType.danger,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    final h = context.screenHeight;
    final w = context.screenWidth;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // العنوان
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.05,
                vertical: h * 0.01,
              ),
              child: Row(
                children: [
                  const Icon(Icons.history, color: constColor, size: 28),
                  SizedBox(width: w * 0.02),
                  const Expanded(
                    child: Text(
                      "سجل المحادثات",
                      style: TextStyle(
                        color: constColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Obx(() {
                    if (controller.sessions.isEmpty) return const SizedBox();
                    return IconButton(
                      icon: const Icon(Icons.delete_sweep, color: constColor),
                      onPressed: () =>
                          _showDeleteAllConfirmation(context, controller),
                      tooltip: "حذف الكل",
                    );
                  }),
                ],
              ),
            ),

            // زر محادثة جديدة
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.05,
                vertical: h * 0.01,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("محادثة جديدة"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: constColor,
                    padding: EdgeInsets.symmetric(vertical: h * 0.015),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    controller.newChat();
                    Get.back();
                  },
                ),
              ),
            ),

            const Divider(height: 1),

            // قائمة المحادثات
            Expanded(
              child: Obx(() {
                if (controller.isLoadingHistory.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.sessions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_comment_outlined,
                          size: 64,
                          color: constColor,
                        ),
                        SizedBox(height: h * 0.02),
                        Text(
                          "لا توجد محادثات سابقة",
                          style: TextStyle(color: constColor, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.02,
                    vertical: h * 0.01,
                  ),
                  itemCount: controller.sessions.length,
                  itemBuilder: (context, index) {
                    final session = controller.sessions[index];
                    return _SessionTile(
                          session: session,
                          onTap: () => controller.loadSession(session),
                          onDelete: () => _showDeleteConfirmation(
                            context,
                            controller,
                            session,
                          ),
                          formattedDate: _formatDate(session.updatedAt),
                        )
                        .animate()
                        .fadeIn(duration: 200.ms, delay: (50 * index).ms)
                        .slideX(begin: -0.1, end: 0);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  final ChatSession session;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final String formattedDate;

  const _SessionTile({
    required this.session,
    required this.onTap,
    required this.onDelete,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return Card(
      margin: EdgeInsets.only(bottom: h * 0.01),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: constLightBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.chat, color: constBlue, size: 20),
              ),
              SizedBox(width: w * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: h * 0.005),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.grey.shade600,
                        ),
                        SizedBox(width: w * 0.01),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(width: w * 0.02),
                        Icon(
                          Icons.message,
                          size: 12,
                          color: Colors.grey.shade600,
                        ),
                        SizedBox(width: w * 0.01),
                        Text(
                          "${session.messages.length}",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: constRed, size: 20),
                onPressed: onDelete,
                splashRadius: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
