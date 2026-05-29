import 'package:flutter/material.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';

class FilterModel {
  final String label; // اسم الفلتر
  final Widget? page; // الصفحة المرتبطة (اختياري)
  final IconData? icon; // أيقونة (اختياري)
  final OrderStatus? status; // الحالة للفلترة (اختياري)
  final bool isRecurring; // هل هو فلتر الطلبات الدورية

  const FilterModel({
    required this.label,
    this.page,
    this.icon,
    this.status,
    this.isRecurring = false,
  });
}
