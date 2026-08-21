// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/models/Inventory_Adjustments_Model.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Build_Row.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/custom_Head_Card.dart';

class InventoryAdjustmentDetailsPage extends StatelessWidget {
  const InventoryAdjustmentDetailsPage({super.key, required this.adjustment});

  final InventoryAdjustment adjustment;

  Color get _typeColor {
    switch (adjustment.adjustmentType) {
      case AdjustmentType.expired:
        return constRed;
      case AdjustmentType.damaged:
        return constOrange;
      case AdjustmentType.shrinkage:
        return constGray;
      case AdjustmentType.found:
        return constGreen;
    }
  }

  Color get _typeBg {
    switch (adjustment.adjustmentType) {
      case AdjustmentType.expired:
        return constLightRed;
      case AdjustmentType.damaged:
        return constLightOrange;
      case AdjustmentType.shrinkage:
        return const Color(0xFFF3F4F6);
      case AdjustmentType.found:
        return constLightGreen;
    }
  }

  IconData get _typeIcon {
    switch (adjustment.adjustmentType) {
      case AdjustmentType.expired:
        return Icons.event_busy_outlined;
      case AdjustmentType.damaged:
        return Icons.broken_image_outlined;
      case AdjustmentType.shrinkage:
        return Icons.remove_circle_outline;
      case AdjustmentType.found:
        return Icons.add_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          const CustomBackContainer(),
          SizedBox(height: h * 0.005),
          const CustomHeadContainer(title: 'تفاصيل الأتلاف'),
          SizedBox(height: h * 0.02),
          // ── الهيدر ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.045),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    adjustment.displayName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: constColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _typeBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _typeColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_typeIcon, size: 15, color: _typeColor),
                      const SizedBox(width: 5),
                      Text(
                        adjustment.adjustmentType.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _typeColor,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: h * 0.015),

          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              children: [
                // ── بطاقة الكمية ──
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _typeColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _typeColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(_typeIcon, size: 32, color: _typeColor),
                      SizedBox(width: w * 0.05),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              adjustment.adjustmentType.label,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: _typeColor,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            const SizedBox(height: 2),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(
                                '${adjustment.quantity} ${adjustment.unitAbbreviation}',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: _typeColor,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: h * 0.015),

                // ── بطاقة المادة ──
                _InfoCard(
                  title: 'معلومات المادة',
                  icon: Icons.medication_outlined,
                  color: constBlue,
                  children: [
                    // _InfoRow(
                    //   icon: Icons.label_outline,
                    //   label: 'اسم الصنف',
                    //   value: adjustment.displayName,
                    // ),
                    BuildRow(
                      icon: Icons.label_outline,
                      label: 'اسم الصنف',
                      value: adjustment.displayName,
                    ),
                    if (adjustment.productName.isNotEmpty)
                      BuildRow(
                        icon: Icons.inventory_2_outlined,
                        label: 'المنتج',
                        value: adjustment.productName,
                      ),
                    BuildRow(
                      icon: Icons.qr_code_2_outlined,
                      label: 'SKU',
                      value: adjustment.sku,
                    ),

                    BuildRow(
                      icon: Icons.category_outlined,
                      label: 'الفئة',
                      value: adjustment.categoryName,
                    ),
                  ],
                ),
                SizedBox(height: h * 0.015),

                // ── بطاقة التسوية ──
                _InfoCard(
                  title: 'تفاصيل التسوية',
                  icon: Icons.history_edu_outlined,
                  color: _typeColor,
                  children: [
                    BuildRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'التاريخ',
                      value: adjustment.formattedCreatedAt,
                    ),
                    BuildRow(
                      icon: Icons.person_outline,
                      label: 'المُبلّغ',
                      value: adjustment.reportedByName,
                    ),
                    BuildRow(
                      icon: Icons.local_hospital_outlined,
                      label: 'القسم',
                      value: adjustment.departmentName,
                    ),
                    if (adjustment.hasNotes)
                      BuildRow(
                        icon: Icons.notes_outlined,
                        label: 'الملاحظات',
                        value: adjustment.notes,
                      ),
                  ],
                ),
                SizedBox(height: h * 0.015),

                // ── بطاقة الدفعة ──
                _InfoCard(
                  title: 'معلومات الدفعة',
                  icon: Icons.inventory_outlined,
                  color: constOrange,
                  children: [
                    BuildRow(
                      icon: Icons.confirmation_number_outlined,
                      label: 'رقم الدفعة',
                      value: adjustment.batchNumber,
                    ),
                  ],
                ),
                SizedBox(height: h * 0.03),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── بطاقة معلومات ──────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}
