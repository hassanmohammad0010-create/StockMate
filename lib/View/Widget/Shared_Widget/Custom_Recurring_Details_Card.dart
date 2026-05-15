// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';
import 'package:stock_mate_project/View/Widget/Shared_Widget/Custom_Status_Badge.dart';

class CustomRecurringDetailsCard extends StatelessWidget {
  const CustomRecurringDetailsCard({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    // نص التكرار
    final intervalText = order.recurringInterval != null
        ? recurringIntervalLabel(order.recurringInterval!)
        : '---';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
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
            value: order.type, // "دوري"
          ),
          _buildDivider(),
          // التكرار بدلاً من الأولوية
          _buildDetailRow(
            icon: Icons.bolt_outlined,
            label: 'التكرار',
            value: intervalText,
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
  }){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF9CA3AF)),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
          // ignore: sized_box_for_whitespace
          Container(
            width: 120,
            child: Center(
              child: valueWidget ??
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
