// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/models/Order_Item.dart';

class StatusBadge extends StatelessWidget {
  final OrderStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    late String label;
    late Color bgColor;
    late Color textColor;

    switch (status) {
      // ── معلق (مسودة + بانتظار موافقة المشفى) ──
      case OrderStatus.draft:
      case OrderStatus.pending_hospital_approval:
        label = 'معلق';
        bgColor = constLightOrange;
        textColor = constOrange;
        break;

      // ── قيد التنفيذ (بانتظار المدير + قيد التجهيز) ──
      case OrderStatus.pending_manager_approval:
      case OrderStatus.preparing:
        label = 'قيد التنفيذ';
        bgColor = constLightBlue;
        textColor = constBlue;
        break;

      // ── مرفوض (مرفوض مشفى + مرفوض مدير + ملغي) ──
      case OrderStatus.hospital_rejected:
      case OrderStatus.manager_rejected:
      case OrderStatus.cancelled:
        label = 'مرفوض';
        bgColor = constLightRed;
        textColor = constRed;
        break;

      // ── منجز (مكتمل جزئياً) ──
      case OrderStatus.partially_complete:
        label = 'منجز';
        bgColor = constLightBlue;
        textColor = constBlue;
        break;

      // ── مستلم (مكتمل) ──
      case OrderStatus.complete:
        label = 'مستلم';
        bgColor = constLightGreen;
        textColor = constGreen;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: h * 0.002,
        horizontal: w * 0.01,
      ),
      width: w * 0.18,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontFamily: lateef,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}