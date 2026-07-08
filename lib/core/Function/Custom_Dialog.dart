import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/Function/Custom_Dialog_With_Textfailed.dart';

void showConfirmDialog({
  required VoidCallback onConfirm,
  VoidCallback? onReject,
  required String tital,
  required String sub,
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
                    // 'هل انت متأكد',
                    tital,
                    style: TextStyle(fontSize: 18, fontFamily: cairo),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ===== Subtitle =====
              Text(
                sub,
                // 'انت على وشك تأكيد الطلب',
                style: TextStyle(
                  fontSize: 24,
                  color: constGray,
                  fontFamily: lateef,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Divider(endIndent: 16, indent: 16, color: constLightGray),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: constBlue,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // لون الظل
                            blurRadius: 8, // ضبابية الظل
                            spreadRadius: 1, // انتشار الظل
                            offset: Offset(0, 0), // اتجاه الظل (x, y)
                          ),
                        ],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                          onReject?.call();
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: constBlue,
                          side: BorderSide.none,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'تأكيد',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // لون الظل
                            blurRadius: 8, // ضبابية الظل
                            spreadRadius: 1, // انتشار الظل
                            offset: Offset(0, 0), // اتجاه الظل (x, y)
                          ),
                        ],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                          onReject?.call();
                          showDialogWithTextFailed(onConfirm: (data) {});
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide.none, // ← هذا يزيل الحواف
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'رفض',
                          style: TextStyle(fontSize: 16, color: constGray),
                        ),
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
