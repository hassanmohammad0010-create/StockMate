// ignore_for_file: file_names

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Service/Unread_Notification_Controller.dart';
import 'package:stock_mate_project/Service/App/Notification_List_Result.dart';

/// هذا الـ handler يجب أن يكون top-level function (خارج أي كلاس)
/// لأن Firebase يستدعيه في background isolate منفصل عن التطبيق
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // لا تحاول تحديث الـ UI هنا، فقط عمليات بسيطة (تسجيل، حفظ محلي، إلخ)
  print('📩 إشعار وصل والتطبيق في الخلفية: ${message.messageId}');
}

class FCMService {
  FCMService._internal();
  static final FCMService instance = FCMService._internal();
  factory FCMService() => instance;

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final NotificationService _notificationService = NotificationService();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// قناة الإشعارات المطلوبة على Android 8+ (Oreo فما فوق)
  static const AndroidNotificationChannel
  _androidChannel = AndroidNotificationChannel(
    'high_importance_channel', // نفس المعرّف يُستخدم بالأسفل، لا تغيّره بدون تحديث الاثنين معاً
    'إشعارات مهمة',
    description: 'يُستخدم لعرض إشعارات StockMate الفورية',
    importance: Importance.high,
  );

  /// يُستدعى مرة واحدة بعد نجاح تسجيل الدخول
  /// يطلب صلاحية الإشعارات، يجلب التوكن، ويرسله للباك اند
  Future<void> initAfterLogin() async {
    // 0. تهيئة flutter_local_notifications (مرة واحدة تكفي، آمن الاستدعاء المتكرر)
    await _initLocalNotifications();

    // 1. طلب صلاحية الإشعارات (مهم بشكل خاص لـ Android 13+ و iOS)
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('⚠️ المستخدم رفض صلاحية الإشعارات');
      return;
    }

    // 2. جلب التوكن الحالي وإرساله للباك اند
    final String? token = await _fcm.getToken();
    print('🔑 FCM TOKEN: $token');
    if (token != null) {
      await _sendTokenToBackend(token);
    }

    // 3. الاستماع لأي تحديث مستقبلي للتوكن (نادر، لكن يحدث)
    _fcm.onTokenRefresh.listen((newToken) {
      _sendTokenToBackend(newToken);
    });

    // 4. تسجيل معالج الإشعارات في الخلفية
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 5. الاستماع للإشعارات أثناء فتح التطبيق (foreground)
    // نعرض بانر يدوياً هنا لأن نظام Android لا يعرضه تلقائياً عند فتح التطبيق
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 إشعار وصل والتطبيق مفتوح: ${message.notification?.title}');
      _showLocalNotification(message);
      _refreshUnreadCountIfRegistered();
    });

    // 6. الاستماع لضغط المستخدم على الإشعار (والتطبيق كان في الخلفية)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('👆 المستخدم ضغط على الإشعار: ${message.data}');
      // TODO: نفّذ التنقل المناسب عبر Get.toNamed(...) حسب بيانات الإشعار
    });
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(settings: initSettings);

    // إنشاء القناة على الجهاز (Android 8+ يتطلب هذا قبل عرض أي إشعار)
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);
  }

  /// يعرض بانر إشعار حقيقي فوق التطبيق حتى وهو مفتوح
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  /// يحدّث عدد الإشعارات غير المقروءة فوراً عند وصول إشعار جديد
  /// نتحقق أولاً هل الـ Controller مسجّل، لأنه ممكن يوصل إشعار
  /// قبل ما المستخدم يفتح الصفحة الرئيسية أصلاً (نادر لكن ممكن)
  void _refreshUnreadCountIfRegistered() {
    if (Get.isRegistered<UnreadNotificationController>()) {
      Get.find<UnreadNotificationController>().refresh();
    }
  }

  Future<void> _sendTokenToBackend(String token) async {
    final success = await _notificationService.registerDeviceToken(
      fcmToken: token,
      platform: 'mobile',
    );
    if (success) {
      print('✅ تم تسجيل FCM Token في الباك اند بنجاح');
    } else {
      print('❌ فشل تسجيل FCM Token في الباك اند');
    }
  }
}
