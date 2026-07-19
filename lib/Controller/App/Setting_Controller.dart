// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/Service/App/lock_service.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';

class SettingController extends GetxController {
  final RxBool isLockEnabled = false.obs;
  final RxBool isLoadingLockState = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadLockState();
  }

  Future<void> loadLockState() async {
    isLoadingLockState.value = true;
    final enabled = await LockService.instance.isLockEnabled();
    isLockEnabled.value = enabled;
    isLoadingLockState.value = false;
  }

  /// يُستدعى عند الضغط على عنصر "قفل التطبيق"
  Future<void> handleLockTap() async {
    if (isLockEnabled.value) {
      // القفل مفعّل حالياً → اطلب تأكيد الهوية قبل الإلغاء
      final confirmed = await Get.toNamed(AppRoutes.ConfirmDisableLockScreen);
      if (confirmed == true) {
        isLockEnabled.value = false;
      }
    } else {
      // القفل غير مفعّل → افتح شاشة الإعداد (PIN ثم بصمة)
      await Get.toNamed(AppRoutes.LockSetupScreen);
      // بعد الرجوع من شاشة الإعداد، أعد فحص الحالة الفعلية
      // (لأن المستخدم ممكن يلغي الإعداد بمنتصف الطريق ولا يكمله)
      await loadLockState();
    }
  }
}