// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Notification_Model.dart';

class NotificationListResult {
  final List<NotificationModel> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  NotificationListResult({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory NotificationListResult.empty() => NotificationListResult(
        items: [],
        total: 0,
        page: 1,
        limit: 20,
        totalPages: 0,
      );
}

class NotificationService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';
  final Dispatcher _dispatcher = Dispatcher();

  /// يرسل fcmToken الخاص بهذا الجهاز إلى الباك اند
  /// يُستدعى بعد تسجيل الدخول مباشرة، وأيضاً كلما تغيّر التوكن (onTokenRefresh)
  Future<bool> registerDeviceToken({
    required String fcmToken,
    String platform = 'mobile',
  }) async {
    final result = await _dispatcher.send<bool>(
      request: (token) => http.post(
        Uri.parse('$baseUrl/notifications/device-tokens'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'fcmToken': fcmToken,
          'platform': platform,
        }),
      ),
      onSuccess: (body) => true,
      fallback: false,
    );
    return result;
  }

  /// يجلب قائمة إشعارات المستخدم الحالي مع دعم Pagination والفلترة
  /// [isRead] مرّر null لجلب كل الإشعارات (مقروءة وغير مقروءة معاً)
  Future<NotificationListResult> listMyNotifications({
    int page = 1,
    int limit = 20,
    bool? isRead,
  }) async {
    final queryParams = <String, String>{
      'page': '$page',
      'limit': '$limit',
    };
    if (isRead != null) {
      queryParams['isRead'] = '$isRead';
    }

    final uri = Uri.parse('$baseUrl/notifications')
        .replace(queryParameters: queryParams);

    return _dispatcher.send<NotificationListResult>(
      request: (token) => http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      onSuccess: (body) {
        final jsonBody = jsonDecode(body);
        final data = jsonBody['data'] as Map<String, dynamic>;
        final items = (data['items'] as List)
            .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
            .toList();

        return NotificationListResult(
          items: items,
          total: data['total'] as int? ?? items.length,
          page: data['page'] as int? ?? page,
          limit: data['limit'] as int? ?? limit,
          totalPages: data['totalPages'] as int? ?? 1,
        );
      },
      fallback: NotificationListResult.empty(),
    );
  }

  /// يجلب عدد الإشعارات غير المقروءة لعرضه فوق أيقونة الإشعارات (badge)
  /// يرجّع -1 في حال فشل الطلب، عشان تقدر تفرّق بين "لا يوجد إشعارات" (0) و"فشل الجلب" (-1) إذا احتجت ذلك لاحقاً
  Future<int> getUnreadCount() async {
    return _dispatcher.send<int>(
      request: (token) => http.get(
        Uri.parse('$baseUrl/notifications/unread-count'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      onSuccess: (body) {
        final jsonBody = jsonDecode(body);
        final data = jsonBody['data'] as Map<String, dynamic>;
        return data['count'] as int? ?? 0;
      },
      fallback: -1,
    );
  }

  /// يعلّم إشعار واحد كمقروء عند ضغط المستخدم عليه
  Future<bool> markAsRead(String notificationId) async {
    return _dispatcher.send<bool>(
      request: (token) => http.patch(
        Uri.parse('$baseUrl/notifications/$notificationId/read'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      onSuccess: (body) => true,
      fallback: false,
    );
  }

  /// يعلّم كل إشعارات المستخدم كمقروءة دفعة واحدة
  Future<bool> markAllAsRead() async {
    return _dispatcher.send<bool>(
      request: (token) => http.patch(
        Uri.parse('$baseUrl/notifications/read-all'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      onSuccess: (body) => true,
      fallback: false,
    );
  }
}