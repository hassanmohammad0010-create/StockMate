import 'package:get/get.dart';
import 'package:stock_mate_project/Service/App/NotificationListResult.dart';

/// Controller مسؤول فقط عن عدد الإشعارات غير المقروءة (لعرضه كـ badge)
/// مسجّل بشكل دائم (permanent) عشان يبقى حياً طوال فترة تسجيل الدخول
/// ويُحدَّث من أكثر من مكان (بعد فتح صفحة الإشعارات، بعد استقبال إشعار جديد، إلخ)
class UnreadNotificationController extends GetxController {
  final NotificationService _notificationService = NotificationService();

  final RxInt unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUnreadCount();
  }

  Future<void> fetchUnreadCount() async {
    final count = await _notificationService.getUnreadCount();
    // -1 تعني فشل الطلب (مثلاً لا يوجد اتصال)، لا نغيّر الرقم المعروض حالياً في هذه الحالة
    if (count >= 0) {
      unreadCount.value = count;
    }
  }

  /// استدعها بعد ما المستخدم يفتح صفحة الإشعارات ويشوفها
  /// (أو بعد استدعاء endpoint "mark as read" لاحقاً)
  void refresh() => fetchUnreadCount();
}