import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';

void showDialogWithTextFailed({
  required Function(String reason) onConfirm,
  VoidCallback? onReject,
}) {
  final TextEditingController reasonController = TextEditingController();

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ===== Header =====
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 28,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'هل انت متأكد',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // ===== Subtitle =====
              // const Text(
              //   'انت على وشك رفض الطلب',
              //   style: TextStyle(fontSize: 14, color: constGray),
              //   textAlign: TextAlign.center,
              // ),
              // const SizedBox(height: 16),

              // ===== Text Field =====
              TextField(
                controller: reasonController,
                maxLines: 4,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  hintText: 'ادخل سبب الرفض ان وجد......',
                  hintTextDirection: TextDirection.rtl,
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: constColor),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ===== Buttons =====
              Row(
                children: [
                  // Confirm Button (تأكيد)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        onConfirm(reasonController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: constRed,
                        foregroundColor: constLightRed,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'تأكيد',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Back Button (تراجع)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                        onReject?.call();
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: constlightGreen,
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'تراجع',
                        style: TextStyle(fontSize: 16, color: constGreen),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
