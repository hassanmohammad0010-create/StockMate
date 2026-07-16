import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/chat_controller.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    final h = context.screenHeight;
    final w = context.screenWidth;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: w * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: constLightBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy_outlined,
                size: 48,
                color: constBlue,
              ),
            ),
            SizedBox(height: h * 0.02),
            const Text(
              "مرحباً بك في StockMate",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: h * 0.01),
            Text(
              "مساعدك الذكي ",
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
            SizedBox(height: h * 0.05),

            // اقتراحات سريعة
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "جرّب أن تسأل:",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            SizedBox(height: h * 0.015),
            _SuggestionChip(
              icon: Icons.assignment_outlined,
              text: "كيف أنشئ طلب مستلزمات طبية لقسمي؟",
              onTap: () => controller.sendSuggestedMessage(
                "كيف أنشئ طلب مستلزمات طبية لقسمي؟",
              ),
            ),
            _SuggestionChip(
              icon: Icons.medication_liquid_outlined,
              text: "ماذا أفعل إذا نفد دواء طارئ من القسم؟",
              onTap: () => controller.sendSuggestedMessage(
                "ماذا أفعل إذا نفد دواء طارئ من القسم؟",
              ),
            ),
            _SuggestionChip(
              icon: Icons.approval,
              text: "ما هي خطوات الموافقة على طلبات الشراء؟",
              onTap: () => controller.sendSuggestedMessage(
                "ما هي خطوات الموافقة على طلبات الشراء؟",
              ),
            ),
            _SuggestionChip(
              icon: Icons.health_and_safety_outlined,
              text: "ما هي الإسعافات الأولية للحروق؟",
              onTap: () => controller.sendSuggestedMessage(
                "ما هي الإسعافات الأولية للحروق؟",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _SuggestionChip({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return Padding(
      padding: EdgeInsets.only(bottom: h * 0.01),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.04,
              vertical: h * 0.016,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(icon, size: 22, color: constBlue),
                SizedBox(width: w * 0.03),
                Expanded(
                  child: Text(text, style: const TextStyle(fontSize: 14)),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
