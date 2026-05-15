// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';
import 'package:stock_mate_project/View/Widget/Shared_Widget/Custom_Reject_Container.dart';
import 'package:stock_mate_project/View/Widget/Shared_Widget/Custom_Status_Container.dart';

class CustomStatusBanner extends StatelessWidget {
  final Order order;

  const CustomStatusBanner({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    switch (order.status) {
      case OrderStatus.completed:
        return StatusBanner(
          color: const Color(0xFF16A34A),
          icon: Icons.check_circle_outline,
          text: 'تم انجاز الطلب',
        );

      case OrderStatus.rejected:
        return RejectionBanner(reason: order.rejectionReason);

      case OrderStatus.inProgress:
        return StatusBanner(
          color: const Color(0xFF1A73E8),
          icon: Icons.sync_outlined,
          text: 'الطلب قيد التنفيذ',
        );

      case OrderStatus.suspended:
        return StatusBanner(
          color: const Color(0xFFD97706),
          icon: Icons.pause_circle_outline,
          text: 'الطلب بانتظار المراجعة',
        );
    }
  }
}
