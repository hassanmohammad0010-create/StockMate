// // ignore_for_file: file_names

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:stock_mate_project/Constant/Const.dart';
// import 'package:stock_mate_project/Controller/Logic/DepartmentHeadsMainTabController.dart';
// import 'package:stock_mate_project/Controller/Logic/NotificationController.dart';
// import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Request_Details_Page.dart';
// import 'package:stock_mate_project/View/Screens/App/Boss/Disposal_Sale_Details_Page.dart';
// import 'package:stock_mate_project/View/Screens/App/Boss/Order_Details_Page.dart';
// import 'package:stock_mate_project/core/models/Notification_Model.dart';
// import 'package:stock_mate_project/core/router/app_routes.dart';
// import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
// import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';
// import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';
// import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Notification_Card.dart';

// class NotificationPage extends StatelessWidget {
//   const NotificationPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final h = context.screenHeight;
//     final w = context.screenWidth;

//     final NotificationController controller = Get.put(NotificationController());

//     return Scaffold(
//       backgroundColor: constBackgroundColor,
//       body: Column(
//         children: [
//           CustomBackContainer(),
//           SizedBox(height: h * 0.01),
//           CustomHeadContainer(title: 'الاشعارات'),

//           Obx(() {
//             final hasUnread = controller.notifications.any((n) => !n.isRead);
//             if (!hasUnread) return const SizedBox.shrink();

//             return Padding(
//               padding: EdgeInsets.symmetric(horizontal: w * 0.03),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: TextButton.icon(
//                   onPressed: controller.markAllAsRead,
//                   icon: Icon(Icons.done_all, size: 18, color: constBlue),
//                   label: Text(
//                     'تعليم الكل كمقروء',
//                     style: TextStyle(color: constBlue, fontSize: 13),
//                   ),
//                 ),
//               ),
//             );
//           }),

//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return const Center(child: CustomLoadingIndicator());
//               }

//               if (controller.notifications.isEmpty) {
//                 return Center(
//                   child: Text(
//                     'لا توجد إشعارات حالياً',
//                     style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
//                   ),
//                 );
//               }

//               return RefreshIndicator(
//                 onRefresh: controller.refreshNotifications,
//                 child: SingleChildScrollView(
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: w * 0.02),
//                     child: Column(
//                       children: [
//                         SizedBox(height: h * 0.01),
//                         ...controller.notifications.map((notification) {
//                           return CustomNotificationCard(
//                             title: notification.title,
//                             subtitle: notification.subtitle,
//                             statusColor: notification.statusColor,
//                             onTap: () => _handleNotificationTap(
//                               controller,
//                               notification,
//                             ),
//                           );
//                         }),
//                         SizedBox(height: h * 0.02),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }

//   /// يعلّم الإشعار كمقروء أولاً، ثم ينقل المستخدم للصفحة المرتبطة بنوعه
//   /// اعتمدنا على `type` وليس `category` وحده، لأن أكثر من type
//   /// قد يشترك بنفس الـ category لكن يحتاج وجهة مختلفة تماماً
//   void _handleNotificationTap(
//     NotificationController controller,
//     NotificationModel notification,
//   ) {
//     controller.markAsRead(notification);

//     // نؤجل التنقل خطوة زمنية بسيطة جداً بدل addPostFrameCallback،
//     // لأن الأخير ينتظر "الإطار القادم الذي سيُرسم فعلياً" — ولو الشاشة
//     // مستقرة بصرياً (بدون رسم وشيك)، هذا الـ callback قد لا يُستدعى أبداً.
//     // Future.delayed بفارق زمني صغير جداً يضمن التنفيذ في كل الحالات،
//     // مع إعطاء وقت كافٍ لإنهاء أي عملية بناء جارية.
//     Future.delayed(const Duration(milliseconds: 50), () {
//       switch (notification.type) {
//         case 'refill_request_status_changed':
//           final id = notification.refillRequestId;
//           if (id == null) return;
//           Get.to(
//             () => RequestDetailsPage(requestId: id),
//             transition: Transition.rightToLeft,
//           );
//           break;

//         case 'batch_expiration_alert' ||
//             'stock_below_minimum' ||
//             'stock_above_maximum':
//           final deptId = notification.departmentId;
//           if (deptId == null) return;
//           // لا يوجد حالياً endpoint لجلب دفعة واحدة بمعرفها،
//           // لذا نوجّه المستخدم لتبويب "المخزون" في الصفحة الرئيسية
//           // كحل مؤقت (بدل فتحها كصفحة مستقلة بدون AppBar/التبويبات).
//           _goToInventoryTab();
//           break;

//         case 'disposal_sale_request_status_changed':
//           Get.to(
//             DisposalSaleDetailsPage(
//               disposalSaleRequestId: notification.disposalSaleRequestId ?? '',
//             ),
//           );
//           break;
//         case 'periodic_refill_pending_approval' || 'periodic_refill_generated':
//           Get.to(
//             DisOrderDetailsPage(requestId: notification.refillRequestId ?? ''),
//           );
//           break;

//         case 'queue_wait_exceeded':
//           Get.toNamed(AppRoutes.PatientsPage);

//           break;
//         default:
//           // نوع غير معروف: نكتفي بتعليمه كمقروء بدون تنقل
//           break;
//       }
//     });
//   }

//   /// يرجع لصفحة DepartmentHeadsMainPage (إن كانت موجودة في المكدس) ويفعّل تبويب "المخزون".
//   /// نستخدم Get.until بدل Get.to لأن DepartmentHeadsMainPage تحمل TabController
//   /// دائم (permanent) واحد فقط — فتح نسخة ثانية منها يسبب تضارب حالة.
//   void _goToInventoryTab() {
//     if (!Get.isRegistered<DepartmentHeadsMainTabController>()) {
//       // المستخدم دخل لصفحة الإشعارات مباشرة بدون المرور بالصفحة الرئيسية أصلاً
//       // (نادر الحدوث في هذا التطبيق) — لا يوجد تبويب لنفعّله حالياً.
//       return;
//     }

//     // ✅ الترتيب مهم هنا: أولاً نرجع لصفحة DepartmentHeadsMainPage فعلياً
//     // (Get.until بدل Navigator.of(Get.context!) لأنه أكثر اتساقاً مع GetX
//     // ولا يعتمد على أي context قد يكون تابعاً لصفحة انقُضي عمرها بالفعل).
//     Get.until((route) => route.isFirst);

//     // ثم، بعد اكتمال الرجوع فعلياً واستقرار الصفحة على الشاشة، نفعّل التبويب.
//     // Future.delayed هنا (بدل addPostFrameCallback) يضمن التنفيذ الفعلي
//     // بغض النظر عن جدولة الإطارات، وبفارق زمني بسيط جداً لا يُلاحَظ.
//     Future.delayed(const Duration(milliseconds: 50), () {
//       final tabCtrl = Get.find<DepartmentHeadsMainTabController>();
//       tabCtrl.tabController.animateTo(
//         DepartmentHeadsMainTabController.inventoryTabIndex,
//       );
//     });
//   }
// }
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/DepartmentHeadsMainTabController.dart';
import 'package:stock_mate_project/Controller/Logic/NotificationController.dart';
import 'package:stock_mate_project/Controller/Service/Get_User_Profile_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Request_Details_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Disposal_Sale_Details_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Order_Details_Page.dart';
import 'package:stock_mate_project/core/models/Notification_Model.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Notification_Card.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    final NotificationController controller = Get.put(NotificationController());

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          CustomBackContainer(),
          SizedBox(height: h * 0.01),
          CustomHeadContainer(title: 'الاشعارات'),

          Obx(() {
            final hasUnread = controller.notifications.any((n) => !n.isRead);
            if (!hasUnread) return const SizedBox.shrink();

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.03),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: controller.markAllAsRead,
                  icon: Icon(Icons.done_all, size: 18, color: constBlue),
                  label: Text(
                    'تعليم الكل كمقروء',
                    style: TextStyle(color: constBlue, fontSize: 13),
                  ),
                ),
              ),
            );
          }),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CustomLoadingIndicator());
              }

              if (controller.notifications.isEmpty) {
                return Center(
                  child: Text(
                    'لا توجد إشعارات حالياً',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshNotifications,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                    child: Column(
                      children: [
                        SizedBox(height: h * 0.01),
                        ...controller.notifications.map((notification) {
                          return CustomNotificationCard(
                            title: notification.title,
                            subtitle: notification.subtitle,
                            statusColor: notification.statusColor,
                            onTap: () => _handleNotificationTap(
                              controller,
                              notification,
                            ),
                          );
                        }),
                        SizedBox(height: h * 0.02),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// يعلّم الإشعار كمقروء أولاً، ثم ينقل المستخدم للصفحة المرتبطة بنوعه
  /// اعتمدنا على `type` وليس `category` وحده، لأن أكثر من type
  /// قد يشترك بنفس الـ category لكن يحتاج وجهة مختلفة تماماً
  void _handleNotificationTap(
    NotificationController controller,
    NotificationModel notification,
  ) {
    controller.markAsRead(notification);

    // ✅ نجيب بيانات دور المستخدم الحالي (بوس/رئيس قسم/طبيب/صيدلي...)
    // عشان نحدد الصفحة الصح لكل دور لنفس نوع الإشعار
    final UserProfileController userCtrl = Get.find<UserProfileController>();

    // نؤجل التنقل خطوة زمنية بسيطة جداً بدل addPostFrameCallback،
    // لأن الأخير ينتظر "الإطار القادم الذي سيُرسم فعلياً" — ولو الشاشة
    // مستقرة بصرياً (بدون رسم وشيك)، هذا الـ callback قد لا يُستدعى أبداً.
    // Future.delayed بفارق زمني صغير جداً يضمن التنفيذ في كل الحالات،
    // مع إعطاء وقت كافٍ لإنهاء أي عملية بناء جارية.
    Future.delayed(const Duration(milliseconds: 50), () {
      switch (notification.type) {
        case 'refill_request_status_changed':
          final id = notification.refillRequestId;
          if (id == null) return;

          if (userCtrl.isDepartmentManager) {
            // TODO: ضع هون صفحة تفاصيل الطلب الخاصة برئيس القسم
          } else if (userCtrl.isDoctor) {
            // TODO: ضع هون صفحة تفاصيل الطلب الخاصة بالطبيب
          } else if (userCtrl.isPharmacist) {
            // TODO: ضع هون صفحة تفاصيل الطلب الخاصة بالصيدلي
          } else {
            // TODO: ضع هون صفحة تفاصيل الطلب الخاصة بالمدير (Boss)
          }

          // ← السلوك الحالي (مؤقتاً) لحد ما تحدد الصفحات فوق
          Get.to(
            () => RequestDetailsPage(requestId: id),
            transition: Transition.rightToLeft,
          );
          break;

        case 'batch_expiration_alert' ||
            'stock_below_minimum' ||
            'stock_above_maximum':
          final deptId = notification.departmentId;
          if (deptId == null) return;
          // لا يوجد حالياً endpoint لجلب دفعة واحدة بمعرفها،
          // لذا نوجّه المستخدم لتبويب "المخزون" في الصفحة الرئيسية
          // كحل مؤقت (بدل فتحها كصفحة مستقلة بدون AppBar/التبويبات).
          _goToInventoryTab();
          break;

        case 'disposal_sale_request_status_changed':
          final disposalId = notification.disposalSaleRequestId ?? '';

          if (userCtrl.isDepartmentManager) {
            // TODO: ضع هون صفحة تفاصيل طلب الإتلاف الخاصة برئيس القسم
          } else {
            // TODO: ضع هون صفحة تفاصيل طلب الإتلاف الخاصة بالمدير (Boss)
          }

          // ← السلوك الحالي (مؤقتاً) لحد ما تحدد الصفحات فوق
          Get.to(DisposalSaleDetailsPage(disposalSaleRequestId: disposalId));
          break;

        case 'periodic_refill_pending_approval' || 'periodic_refill_generated':
          final refillId = notification.refillRequestId ?? '';

          if (userCtrl.isDepartmentManager) {
            // TODO: ضع هون الصفحة الخاصة برئيس القسم لهذا النوع
          } else {
            // TODO: ضع هون الصفحة الخاصة بالمدير (Boss) لهذا النوع
          }

          // ← السلوك الحالي (مؤقتاً) لحد ما تحدد الصفحات فوق
          Get.to(DisOrderDetailsPage(requestId: refillId));
          break;

        case 'queue_wait_exceeded':
          Get.toNamed(AppRoutes.PatientsPage);

          break;
        default:
          // نوع غير معروف: نكتفي بتعليمه كمقروء بدون تنقل
          break;
      }
    });
  }

  /// يرجع لصفحة DepartmentHeadsMainPage (إن كانت موجودة في المكدس) ويفعّل تبويب "المخزون".
  /// نستخدم Get.until بدل Get.to لأن DepartmentHeadsMainPage تحمل TabController
  /// دائم (permanent) واحد فقط — فتح نسخة ثانية منها يسبب تضارب حالة.
  void _goToInventoryTab() {
    if (!Get.isRegistered<DepartmentHeadsMainTabController>()) {
      // المستخدم دخل لصفحة الإشعارات مباشرة بدون المرور بالصفحة الرئيسية أصلاً
      // (نادر الحدوث في هذا التطبيق) — لا يوجد تبويب لنفعّله حالياً.
      return;
    }

    // ✅ الترتيب مهم هنا: أولاً نرجع لصفحة DepartmentHeadsMainPage فعلياً
    // (Get.until بدل Navigator.of(Get.context!) لأنه أكثر اتساقاً مع GetX
    // ولا يعتمد على أي context قد يكون تابعاً لصفحة انقُضي عمرها بالفعل).
    Get.until((route) => route.isFirst);

    // ثم، بعد اكتمال الرجوع فعلياً واستقرار الصفحة على الشاشة، نفعّل التبويب.
    // Future.delayed هنا (بدل addPostFrameCallback) يضمن التنفيذ الفعلي
    // بغض النظر عن جدولة الإطارات، وبفارق زمني بسيط جداً لا يُلاحَظ.
    Future.delayed(const Duration(milliseconds: 50), () {
      final tabCtrl = Get.find<DepartmentHeadsMainTabController>();
      tabCtrl.tabController.animateTo(
        DepartmentHeadsMainTabController.inventoryTabIndex,
      );
    });
  }
}
