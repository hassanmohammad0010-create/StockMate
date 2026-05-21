// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Status_Badge.dart';

class CustomDetailsCard extends StatelessWidget {
  final Order order;

  const CustomDetailsCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
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
          // _buildDivider(),
          // _buildDetailRow(
          //   icon: Icons.grid_view_outlined,
          //   label: 'النوع',
          //   value: order.type,
          // ),
          // _buildDivider(),
          // _buildDetailRow(
          //   icon: Icons.bolt_outlined,
          //   label: 'الاولوية',
          //   valueWidget: PriorityBadge(priority: order.priority),
          // ),
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 24, color: constGray),

              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 22,
                  color: constGray,
                  fontFamily: lateef,
                ),
              ),
            ],
          ),
          // ignore: sized_box_for_whitespace
          Container(
            width: 120,
            child: Center(
              child:
                  valueWidget ??
                  Text(
                    value ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A2A4A),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: Color(0xFFF3F4F6));
  }
}
