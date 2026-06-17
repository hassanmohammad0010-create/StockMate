import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

enum NotificationStatus { rejected, inProgress, completed }

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
      case NotificationStatus.completed:
        return constGreen;
      case NotificationStatus.rejected:
        return constRed;
      case NotificationStatus.inProgress:
        return constBlue;
    }
  }
}
