import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class MedicineCard extends StatelessWidget {
  final String medicineName;
  final String status;
  final String expiryDate;

  final String unit;
  final int currentQuantity;
  final int totalQuantity;

  const MedicineCard({
    super.key,
    required this.medicineName,
    required this.status,
    required this.expiryDate,

    required this.unit,
    required this.currentQuantity,
    required this.totalQuantity,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = currentQuantity / totalQuantity;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
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
                    medicineName,
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
                      status,
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
                    label: expiryDate,
                    icon: Icons.calendar_today_outlined,
                  ),
                  const SizedBox(width: 12),
                  _InfoChip(
                    label: '$currentQuantity $unit',
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
                    '$currentQuantity\\$totalQuantity',
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
