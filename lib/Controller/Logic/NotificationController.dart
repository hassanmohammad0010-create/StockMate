import 'package:get/get.dart';
import 'package:stock_mate_project/core/models/Notification_Model.dart';

class NotificationController extends GetxController {
  final List<NotificationModel> notifications = [
    NotificationModel(
      title: 'تم قبول الطلب',
      subtitle: 'شاش طبي mg 250 - قسم الجراحة',
      status: NotificationStatus.inProgress,
    ),
    NotificationModel(
      title: 'تم رفض الطلب',
      subtitle: 'شاش طبي mg 250 - قسم الجراحة',
      status: NotificationStatus.rejected,
    ),
    NotificationModel(
      title: 'تم تنفيذ الطلب',
      subtitle: 'شاش طبي mg 250 - مدير المستودع',
      status: NotificationStatus.completed,
    ),
  ];
}
