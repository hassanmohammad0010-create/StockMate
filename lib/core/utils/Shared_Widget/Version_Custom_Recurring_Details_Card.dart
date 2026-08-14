// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/models/Order_Item_Details.dart';

class VersionCustomRecurringDetailsCard extends StatelessWidget {
  const VersionCustomRecurringDetailsCard({
    super.key,
    required this.requestItemModel,
  });

  final DetailRequestItem requestItemModel;

  @override
  Widget build(BuildContext context) {
    final variant = requestItemModel.variant;
    final product = variant?.product;
    final unit = variant?.unit;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            value: product?.name ?? variant?.variantName ?? '---',
          ),
          _buildDivider(),
          _buildDetailRow(
            icon: Icons.inventory_2_outlined,
            label: 'الكمية المطلوبة',
            value:
                '${requestItemModel.requestedQuantity} ${unit?.abbreviation ?? ''}',
          ),
          _buildDivider(),
          _buildDetailRow(
            icon: Icons.badge_outlined,
            label: 'الفئة',
            value: product?.category?.name ?? '---',
          ),
          _buildDivider(),
          _buildDetailRow(
            icon: Icons.badge_outlined,
            label: 'الكمية الموافق عليها',
            value: requestItemModel.approvedQuantity?.toString() ?? '---',
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
            width: 120,
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
    return const Divider(indent: 16, endIndent: 16, thickness: 0.5);
  }
}
