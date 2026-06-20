// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Priority_Badge.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Recurring_Badge.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Status_Badge.dart';

class CustomDetailsCard extends StatelessWidget {
  const CustomDetailsCard({super.key, required this.order});

  final Order order;
  


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 8,
            offset: Offset(0, 0),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildDetailRow(
            icon: Icons.edit_outlined,
            label: 'المادة المطلوبة',
            value: order.medicineName,
          ),
          _buildDivider(),
          _buildDetailRow(
            icon: Icons.inventory_2_outlined,
            label: 'الكمية',
            value: '${order.quantity} وحدة',
          ),
          _buildDivider(),
          _buildDetailRow(
            icon: Icons.grid_view_outlined,
            label: 'النوع',
            value: order.type,
          ),
          _buildDivider(),
          // التكرار بدلاً من الأولوية
          _buildDetailRow(
            icon: Icons.bolt_outlined,
            label: order.recurringInterval != null ? 'التكرار' : 'الأولوية',
            valueWidget: order.recurringInterval != null
                ? RecurringBadge(
                    interval: order.recurringInterval!,
                  ) // عرض نص التكرار داخل بادج
                : PriorityBadge(priority: order.priority),
          ),
          _buildDivider(),
          _buildDetailRow(
            icon: Icons.badge_outlined,
            label: 'الوكيل / الماركة',
            value: order.vendor,
          ),
          _buildDivider(),
          _buildDetailRow(
            icon: Icons.calendar_month_outlined,
            label: 'التاريخ',
            value: order.date,
          ),
          _buildDivider(),
          _buildDetailRow(
            icon: Icons.list_alt_outlined,
            label: 'الحالة',
            valueWidget: StatusBadge(status: order.status),
          ),
        ],
      ),
    );
  }

  // ==================== صف تفصيلة ====================
   Widget _buildDetailRow({
    required IconData icon,
    required String label,
    String? value,
    Widget? valueWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: constGray),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: constGray,
                  fontFamily: cairo,
                ),
              ),
            ],
          ),
          // ignore: sized_box_for_whitespace
          Container(
            width: 130, // ضبط عرض الحاوية بناءً على عرض الشاشة
            child: Center(
              child:
                  valueWidget ??
                  Text(
                    value ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: cairo,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(indent: 8, endIndent: 8, thickness: 0.5);
  }
}
