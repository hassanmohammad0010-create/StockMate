// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Service/Unread_Notification_Controller.dart';
import 'package:stock_mate_project/Service/App/NotificationListResult.dart';
import 'package:stock_mate_project/core/models/Notification_Model.dart';

class NotificationController extends GetxController {
  final NotificationService _notificationService = NotificationService();

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications({int page = 1, bool? isRead}) async {
    isLoading.value = true;
    hasError.value = false;

    final result = await _notificationService.listMyNotifications(
      page: page,
      limit: 20,
      isRead: isRead,
    );

    if (result.items.isEmpty && result.total == 0) {
      // ممكن يكون فعلاً ما فيه إشعارات، أو صار خطأ (Dispatcher يعرض SnackBar بنفسه عند الخطأ)
      notifications.clear();
    } else {
      notifications.assignAll(result.items);
    }

    isLoading.value = false;
  }

  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }

  /// يُستدعى عند ضغط المستخدم على كارد الإشعار
  /// يحدّث الحالة محلياً فوراً (تجربة مستخدم سريعة)، ثم يرسل الطلب للباك اند
  Future<void> markAsRead(NotificationModel notification) async {
    // إشعار مقروء بالفعل، لا داعي لأي طلب إضافي
    if (notification.isRead) return;

    final index = notifications.indexWhere((n) => n.id == notification.id);
    if (index == -1) return;

    // تحديث تفاؤلي (optimistic update): نغيّر الشكل فوراً قبل رد السيرفر
    notifications[index] = notification.copyWith(
      isRead: true,
      readAt: DateTime.now(),
    );

    final success = await _notificationService.markAsRead(notification.id);

    if (!success) {
      // فشل الطلب: نرجّع الحالة القديمة (غير مقروء) كما كانت
      notifications[index] = notification;
      return;
    }

    // نجح: نحدّث عدد الإشعارات غير المقروءة في الصفحة الرئيسية أيضاً
    if (Get.isRegistered<UnreadNotificationController>()) {
      Get.find<UnreadNotificationController>().refresh();
    }
  }

  /// يُستدعى عند ضغط زر "تعليم الكل كمقروء"
  Future<void> markAllAsRead() async {
    // لا يوجد شيء غير مقروء أصلاً
    if (notifications.every((n) => n.isRead)) return;

    // نحتفظ بنسخة من الحالة القديمة كاملة، تحسباً لفشل الطلب
    final previousState = List<NotificationModel>.from(notifications);

    // تحديث تفاؤلي: كل الكاردات تتحول رمادي فوراً
    notifications.assignAll(
      notifications
          .map((n) => n.copyWith(isRead: true, readAt: DateTime.now()))
          .toList(),
    );

    final success = await _notificationService.markAllAsRead();

    if (!success) {
      // فشل الطلب: نرجّع كل شيء كما كان
      notifications.assignAll(previousState);
      return;
    }

    if (Get.isRegistered<UnreadNotificationController>()) {
      Get.find<UnreadNotificationController>().refresh();
    }
  }
}
