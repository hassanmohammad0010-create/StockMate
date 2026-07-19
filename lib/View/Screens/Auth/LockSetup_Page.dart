// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/LockSetupController.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';

/// شاشة إعداد قفل التطبيق: إنشاء PIN ثم عرض خيار إضافة بصمة (إصبع/وجه)
/// بعد الانتهاء، أضف زر أو Switch في شاشة الإعدادات الخاصة بك يفتح هذه الشاشة
class LockSetupScreen extends StatelessWidget {
  const LockSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LockSetupController controller = Get.put(LockSetupController());

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.title)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          switch (controller.step.value) {
            case LockSetupStep.createPin:
            case LockSetupStep.confirmPin:
              return _PinEntryView(controller: controller);
            case LockSetupStep.biometricOffer:
              return _BiometricOfferView(controller: controller);
            case LockSetupStep.done:
              return _DoneView();
          }
        }),
      ),
    );
  }
}

// ===========================================================================
// مرحلة 1 و 2: إدخال / تأكيد الـ PIN
// ===========================================================================

class _PinEntryView extends StatelessWidget {
  final LockSetupController controller;
  const _PinEntryView({required this.controller});

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.1),
      child: Column(
        children: [
          const Spacer(flex: 2),
          const Icon(Icons.lock_outline, size: 56, color: constColor),
          const SizedBox(height: 24),

          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(LockSetupController.pinLength, (i) {
                final filled = i < controller.currentInput.value.length;
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

          const SizedBox(height: 12),
          Obx(() {
            if (!controller.isError.value) return const SizedBox(height: 20);
            return const Text(
              'الرمزان غير متطابقين، حاول مرة أخرى',
              style: TextStyle(color: constRed, fontSize: 13),
            );
          }),

          const Spacer(flex: 2),
          _NumPad(controller: controller),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}

class _NumPad extends StatelessWidget {
  final LockSetupController controller;
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
              children: row.map(_digitButton).toList(),
            ),
          ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: h * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: w * 0.16, height: h * 0.08),
              _digitButton('0'),
              SizedBox(
                width: w * 0.16,
                height: h * 0.08,
                child: IconButton(
                  icon: const Icon(Icons.backspace_outlined, size: 24),
                  onPressed: controller.removeDigit,
                ),
              ),
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

// ===========================================================================
// مرحلة 3: عرض إضافة بصمة (إصبع أو وجه، حسب دعم الجهاز)
// ===========================================================================

class _BiometricOfferView extends StatelessWidget {
  final LockSetupController controller;
  const _BiometricOfferView({required this.controller});

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.1),
      child: Column(
        children: [
          const Spacer(flex: 2),
          const Icon(Icons.check_circle, size: 56, color: constGreen),
          const SizedBox(height: 16),
          const Text(
            'تم حفظ رمز القفل بنجاح',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            'هل تريد إضافة بصمة كطريقة دخول سريعة؟',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: constColor),
          ),
          const Spacer(flex: 2),

          // خيار بصمة الإصبع (يظهر فقط لو الجهاز يدعمها)
          Obx(() {
            if (!controller.deviceSupportsFingerprint.value) {
              return const SizedBox.shrink();
            }
            return _OptionCard(
              icon: Icons.fingerprint,
              title: 'بصمة الإصبع',
              subtitle: 'استخدم بصمتك لفتح التطبيق بسرعة',
              onTap: () => _handleEnable(context),
            );
          }),

          const SizedBox(height: 12),

          // خيار بصمة الوجه (يظهر فقط لو الجهاز يدعمها)
          Obx(() {
            if (!controller.deviceSupportsFace.value) {
              return const SizedBox.shrink();
            }
            return _OptionCard(
              icon: Icons.face,
              title: 'بصمة الوجه',
              subtitle: 'استخدم وجهك لفتح التطبيق بسرعة',
              onTap: () => _handleEnable(context),
            );
          }),

          const Spacer(flex: 1),

          TextButton(
            onPressed: controller.skipBiometric,
            child: const Text('تخطي، الاكتفاء برمز PIN فقط'),
          ),
          SizedBox(height: h * 0.02),
        ],
      ),
    );
  }

  Future<void> _handleEnable(BuildContext context) async {
    final success = await controller.enableBiometric();
    if (!success) {
      customSnackBar(
        title: 'تعذر التفعيل',
        message:
            'لم نتمكن من التحقق من البصمة، حاول مرة أخرى أو تخطَّ هذه الخطوة',
        color: constRed,
        messageColor: Colors.white,
      );
    }
  }
}

class _OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return Material(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.06,
            vertical: h * 0.02,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Icon(icon, size: 32, color: constColor),
              SizedBox(width: w * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: constColor),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: constColor),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// مرحلة 4: انتهاء الإعداد
// ===========================================================================

class _DoneView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.1),
      child: Column(
        children: [
          const Spacer(flex: 2),
          const Icon(Icons.verified_user, size: 64, color: constGreen),
          SizedBox(height: h * 0.02),
          const Text(
            'تم إعداد القفل بنجاح',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const Spacer(flex: 2),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.back(), // ارجع لشاشة الإعدادات
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: h * 0.02),
              ),
              child: const Text('العودة للإعدادات'),
            ),
          ),
          SizedBox(height: h * 0.03),
        ],
      ),
    );
  }
}
