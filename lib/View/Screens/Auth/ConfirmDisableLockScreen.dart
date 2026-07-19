// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/LockController.dart';
import 'package:stock_mate_project/Service/App/lock_service.dart';

/// تُفتح من شاشة الإعدادات عندما يحاول المستخدم تعطيل القفل.
/// تطلب PIN أو بصمة للتأكد إنه فعلاً صاحب الصلاحية قبل الإلغاء.
///
/// طريقة الاستخدام من شاشة الإعدادات:
/// ```dart
/// final disabled = await Get.to(() => const ConfirmDisableLockScreen());
/// if (disabled == true) {
///   // حدّث الـ UI عندك (مثلاً Switch يرجع false)
/// }
/// ```
class ConfirmDisableLockScreen extends StatelessWidget {
  const ConfirmDisableLockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    final LockController controller = Get.put(
      LockController(
        mode: LockControllerMode.confirmDisable,
        onSuccess: () async {
          await LockService.instance.setLockEnabled(false);
          Get.back(result: true); // نرجع للإعدادات مع إشارة "تم الإلغاء بنجاح"
        },
      ),
    );

    return Scaffold(
      backgroundColor: constBackgroundColor,
      appBar: AppBar(title: const Text('تأكيد الهوية'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.06),
          child: Column(
            children: [
              const Spacer(flex: 2),
              const Icon(Icons.lock_reset, size: 56, color: Colors.black87),
              SizedBox(height: h * 0.02),
              const Text(
                'أدخل رمز القفل لإلغاء الحماية',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: h * 0.03),

              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(LockController.pinLength, (index) {
                    final filled = index < controller.enteredPin.value.length;
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: w * 0.02),
                      width: w * 0.04,
                      height: h * 0.02,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: controller.isError.value
                            ? constRed
                            : (filled ? constColor : Colors.grey.shade300),
                      ),
                    );
                  }),
                );
              }),

              SizedBox(height: h * 0.015),
              Obx(() {
                if (!controller.isError.value) {
                  return const SizedBox(height: 20);
                }
                return const Text(
                  'رمز غير صحيح، حاول مرة أخرى',
                  style: TextStyle(color: constRed, fontSize: 13),
                );
              }),

              const Spacer(flex: 2),
              _NumPad(controller: controller),
              const Spacer(flex: 1),

              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('إلغاء'),
              ),
              SizedBox(height: h * 0.01),
            ],
          ),
        ),
      ),
    );
  }
}

class _NumPad extends StatelessWidget {
  final LockController controller;
  const _NumPad({required this.controller});

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    final rows = [
      ['3', '2', '1'],
      ['6', '5', '4'],
      ['9', '8', '7'],
    ];
    return Column(
      children: [
        for (final row in rows)
          Padding(
            padding: EdgeInsets.symmetric(vertical: h * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.map((digit) => _digitButton(digit)).toList(),
            ),
          ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: h * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: w * 0.16,
                height: h * 0.08,
                child: IconButton(
                  icon: const Icon(Icons.backspace_outlined, size: 24),
                  onPressed: controller.removeDigit,
                ),
              ),
              _digitButton('0'),
              Obx(() {
                if (!controller.isBiometricAvailable.value) {
                  return SizedBox(width: w * 0.16, height: h * 0.08);
                }
                return SizedBox(
                  width: w * 0.16,
                  height: h * 0.08,
                  child: IconButton(
                    icon: const Icon(Icons.fingerprint, size: 30),
                    onPressed: controller.tryBiometric,
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _digitButton(String digit) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Material(
        color: Colors.grey.shade100,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => controller.addDigit(digit),
          child: Center(
            child: Text(
              digit,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
