import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/Function/Custom_Dialog_With_Textfailed.dart';

void showConfirmDialog({
  required VoidCallback onConfirm,
  VoidCallback? onReject,
}) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 38,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'هل انت متأكد',
                    style: TextStyle(fontSize: 18, fontFamily: cairo),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ===== Subtitle =====
              Text(
                'انت على وشك تأكيد الطلب',
                style: TextStyle(
                  fontSize: 24,
                  color: constGray,
                  fontFamily: lateef,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                        onReject?.call();
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: constGreen,
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'تأكيد',
                        style: TextStyle(fontSize: 16, color: constlightGreen),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                        onReject?.call();
                        showDialogWithTextFailed(onConfirm: (data) {});
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: constRed,
                        side: BorderSide.none, // ← هذا يزيل الحواف
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'رفض',
                        style: TextStyle(fontSize: 16, color: constLightRed),
                      ),
                    ),
                  ),

                  // Confirm Button
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
