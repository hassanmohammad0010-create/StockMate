import 'package:flutter/material.dart';

enum NotificationStatus { accepted, rejected, newRequest, completed }

class NotificationModel {
  final String title;
  final String subtitle;
  final NotificationStatus status;

  NotificationModel({
    required this.title,
    required this.subtitle,
    required this.status,
  });

  Color get statusColor {
    switch (status) {
      case NotificationStatus.accepted:
        return Colors.green;
      case NotificationStatus.rejected:
        return Colors.red;
      case NotificationStatus.newRequest:
        return Colors.blue;
      case NotificationStatus.completed:
        return Colors.green;
    }
  }
}