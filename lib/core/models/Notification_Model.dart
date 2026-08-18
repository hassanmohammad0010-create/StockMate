import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class NotificationModel {
  final String id;
  final String type;
  final String category;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.category,
    required this.title,
    required this.body,
    required this.data,
    required this.isRead,
    required this.readAt,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      type: json['type'] as String? ?? '',
      category: json['category'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      data: json['data'] is Map ? json['data'] as Map<String, dynamic> : null,
      isRead: json['isRead'] as bool? ?? false,
      readAt: json['readAt'] != null
          ? DateTime.tryParse(json['readAt'] as String)
          : null,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  /// لون الحالة يُشتق من isRead ونوع الإشعار
  /// غير مقروء = أزرق (يلفت الانتباه)، مقروء = رمادي فاتح
  /// تقدر تخصص ألوان حسب category/type لاحقاً إذا احتجت تمييز أدق
  Color get statusColor {
    if (!isRead) return constBlue;
    return Colors.grey.shade400;
  }

  /// نص فرعي جاهز للعرض في الكارد (يطابق شكل subtitle الحالي)
  String get subtitle => body;

  /// معرّف طلب التزويد (Refill Request) إن وُجد ضمن data
  String? get refillRequestId => data?['refillRequestId'] as String?;

  /// معرّف القسم (Department) إن وُجد ضمن data
  String? get departmentId => data?['departmentId'] as String?;

  /// معرّف الدفعة/التشغيلة (Batch) إن وُجد ضمن data
  String? get batchId => data?['batchId'] as String?;

  /// معرّف نقل الإتلاف (Disposal Transfer) إن وُجد ضمن data
  String? get disposalTransferId => data?['disposalTransferId'] as String?;

  /// يُستخدم لتحديث حالة isRead محلياً في القائمة فوراً بعد نجاح markAsRead
  /// بدون الحاجة لإعادة جلب كامل القائمة من السيرفر
  NotificationModel copyWith({bool? isRead, DateTime? readAt}) {
    return NotificationModel(
      id: id,
      type: type,
      category: category,
      title: title,
      body: body,
      data: data,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt,
    );
  }
}