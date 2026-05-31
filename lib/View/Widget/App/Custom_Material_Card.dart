import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';

class MaterialCard extends StatelessWidget {
  final MaterialItem materialItem;

  final VoidCallback onTap;
  const MaterialCard({
    super.key,
    required this.materialItem,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double progress =
        materialItem.totalQuantity / materialItem.maxQuantity;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1: Medicine name + Status badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      materialItem.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: cairo,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: constLightBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        materialItem.categoryLabel,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: cairo,
                          color: constBlue,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Row 2: Expiry date + Quantity
                Row(
                  children: [
                    _InfoChip(
                      label: materialItem.batches[0].expiryDate
                          .toString()
                          .substring(0, 10),
                      icon: Icons.calendar_today_outlined,
                    ),
                    const SizedBox(width: 12),
                    _InfoChip(
                      label: '${materialItem.totalQuantity}',
                      icon: Icons.inventory_2_outlined,
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Progress bar label
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الكمية المتوفرة',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: cairo,
                        color: constGray,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${materialItem.totalQuantity}\\${materialItem.maxQuantity}',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: cairo,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress < 0.20
                          ? constRed // أحمر إذا أقل من 20%
                          : constBlue, // أزرق إذا 20% أو أكثر
                    ),
                  ),
                ),

                const SizedBox(height: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _InfoChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF3B82F6)),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF1E40AF),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
