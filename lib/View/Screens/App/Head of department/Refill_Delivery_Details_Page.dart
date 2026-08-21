// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Service/Refill_Delivery_Details_Controller.dart';
import 'package:stock_mate_project/core/models/Refill_Delivery_Details_Model.dart';
import 'package:stock_mate_project/core/models/Refill_Delivery_Model.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Build_Row.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Text_Field/Custom_My_TextFormFaild.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/custom_Head_Card.dart';

class RefillDeliveryDetailsPage extends StatelessWidget {
  const RefillDeliveryDetailsPage({super.key, required this.deliveryId});

  final String deliveryId;

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    final c = Get.put(
      RefillDeliveryDetailsController(deliveryId: deliveryId),
      tag: deliveryId,
    );

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          const CustomBackContainer(),
          SizedBox(height: h * 0.005),
          CustomHeadContainer(
            title: 'تفاصيل التسليم',
            trailing: Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              child: Obx(() {
                final d = c.details.value;
                return d != null ? _TypeBadge(type: d.type) : Container();
              }),
            ),
          ),
          SizedBox(height: h * 0.015),
          Expanded(
            child: Obx(() {
              if (c.isLoading.value && c.details.value == null) {
                return const Center(child: CustomLoadingIndicator());
              }

              if (c.errorMessage.value.isNotEmpty && c.details.value == null) {
                return _buildErrorState(c);
              }

              final d = c.details.value;
              if (d == null) return _buildErrorState(c);

              return ListView(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                children: [
                  _SummaryCard(details: d),
                  SizedBox(height: h * 0.015),

                  _InfoCard(
                    title: 'معلومات التسليم',
                    icon: Icons.local_shipping_outlined,
                    color: constBlue,
                    children: [
                      BuildRow(
                        icon: Icons.local_shipping_outlined,
                        label: 'تاريخ التسليم',
                        value: d.formattedDeliveredAt,
                      ),
                      BuildRow(
                        icon: Icons.verified_outlined,
                        label: 'تاريخ التأكيد',
                        value: d.formattedConfirmedAt,
                      ),
                      if (d.hasNotes)
                        BuildRow(
                          icon: Icons.notes_outlined,
                          label: 'ملاحظات',
                          value: d.notes!,
                        ),
                    ],
                  ),
                  SizedBox(height: h * 0.015),

                  _ItemsCard(details: d),
                  SizedBox(height: h * 0.02),
                ],
              );
            }),
          ),

          // ─── ✅✅✅ زر تأكيد الاستلام (أسفل الصفحة) ───
          Obx(() {
            // إذا تم التأكيد مسبقاً → إشعار بدل الزر
            if (c.isConfirmed) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.04,
                  vertical: h * 0.01,
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: constLightGreen,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: constGreen.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.check_circle_outline,
                        color: constGreen,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'تم تأكيد استلام هذا التسليم',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: constGreen,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // ✅ زر تأكيد الاستلام
            final confirming = c.isConfirming.value;
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.04,
                vertical: h * 0.01,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: confirming
                      ? null
                      : () => _showConfirmDialog(context, c),
                  icon: confirming
                      ? SizedBox(
                          width: w * 0.4,
                          height: h * 0.03,
                          child: CustomLoadingIndicator(size: 16),
                        )
                      : const Icon(Icons.verified_outlined, size: 20),
                  label: Text(
                    confirming ? 'جارٍ التأكيد...' : 'تأكيد الاستلام',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: constGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ─── ✅✅✅ ديالوغ تأكيد الاستلام ─────────────────────────────────
  void _showConfirmDialog(
    BuildContext context,
    RefillDeliveryDetailsController c,
  ) {
    final d = c.details.value;
    if (d == null) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text(
          'تأكيد الاستلام',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'تحقق من الكميات المستلمة لكل صنف:',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 12),

                // ✅ قائمة الأصناف مع stepper للكمية المستلمة
                ...d.items.map(
                  (item) => _DialogItemRow(item: item, controller: c),
                ),

                const SizedBox(height: 12),

                // ✅ حقل الملاحظات الاختياري
                CustomMyTextFormField(
                  prefixIcon: Icons.edit_note_outlined,
                  label: 'ملاحظات (اختياري)',
                  hint: 'مثال: جميع الأصناف بحالة جيدة',
                  controller: c.notesController,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Cairo')),
          ),

          ElevatedButton(
            onPressed: () {
              c.confirmReceipt();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: constGreen,
              foregroundColor: Colors.white,
            ),
            child: Text('تأكيد', style: const TextStyle(fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(RefillDeliveryDetailsController c) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off_outlined, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            c.errorMessage.value,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Cairo',
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: c.fetchDetails,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('إعادة المحاولة'),
            style: TextButton.styleFrom(foregroundColor: constBlue),
          ),
        ],
      ),
    );
  }
}

// ─── صف صنف داخل الديالوغ مع stepper ──────────────────────────────
class _DialogItemRow extends StatelessWidget {
  final DeliveryItem item;
  final RefillDeliveryDetailsController controller;

  const _DialogItemRow({required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // اسم الصنف
          Text(
            item.displayName,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              color: constColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            'المرسَل: ${item.shippedQuantity} ${item.unitAbbreviation}',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 8),

          // stepper الكمية المستلمة
          Row(
            children: [
              const Expanded(
                child: Text(
                  'المستلَم',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                    color: Colors.grey,
                  ),
                ),
              ),
              Obx(() {
                final chosen = controller.quantityFor(item);
                final isFull = chosen >= item.shippedQuantity;
                return _StepperField(
                  value: chosen,
                  min: 0,
                  max: item.shippedQuantity,
                  accentColor: isFull ? constGreen : constRed,
                  onChanged: (v) =>
                      controller.updateReceivedQuantity(item.id, v),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── stepper (+/-) ─────────────────────────────────────────────────
class _StepperField extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final Color accentColor;
  final ValueChanged<int> onChanged;

  const _StepperField({
    required this.value,
    required this.onChanged,
    this.min = 0,
    required this.max,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final canDec = value - 1 >= min;
    final canInc = value + 1 <= max;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: accentColor.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(Icons.remove, canDec, () => onChanged(value - 1)),
          SizedBox(
            width: 36,
            child: Center(
              child: Text(
                '$value',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: accentColor,
                ),
              ),
            ),
          ),
          _btn(Icons.add, canInc, () => onChanged(value + 1)),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, bool enabled, VoidCallback? onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        customBorder: const CircleBorder(),
        child: Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 17,
            color: enabled ? accentColor : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}

// ─── شارة النوع ────────────────────────────────────────────────────
class _TypeBadge extends StatelessWidget {
  final DeliveryType type;

  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final color = type.isFinal ? constGreen : constBlue;
    final bg = type.isFinal ? constLightGreen : constLightBlue;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        type.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }
}

// ─── بطاقة الملخص ──────────────────────────────────────────────────
class _SummaryCard extends StatelessWidget {
  final RefillDeliveryDetails details;

  const _SummaryCard({required this.details});

  @override
  Widget build(BuildContext context) {
    final discrepancyColor = details.hasAnyDiscrepancy ? constRed : constGreen;

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
      child: Row(
        children: [
          _summaryItem(
            Icons.outbound_outlined,
            '${details.totalShipped}',
            'إجمالي المرسَل',
            constBlue,
          ),
          Container(width: 1, height: 30, color: Colors.grey.shade200),
          _summaryItem(
            Icons.inbox_outlined,
            '${details.totalReceived}',
            'إجمالي المستلَم',
            constGreen,
          ),
          Container(width: 1, height: 30, color: Colors.grey.shade200),
          _summaryItem(
            details.hasAnyDiscrepancy
                ? Icons.warning_amber_rounded
                : Icons.check_circle_outline,
            details.hasAnyDiscrepancy ? 'يوجد فرق' : 'مطابق',
            'حالة المطابقة',
            discrepancyColor,
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: color,
              fontFamily: 'Cairo',
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade700,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}

// ─── بطاقة الأصناف ─────────────────────────────────────────────────
class _ItemsCard extends StatelessWidget {
  final RefillDeliveryDetails details;

  const _ItemsCard({required this.details});

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
                  color: constLightRed.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  size: 18,
                  color: constRed,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'الأصناف المسلّمة',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: constRed,
                  fontFamily: 'Cairo',
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${details.items.length}',
                  style: const TextStyle(
                    color: constColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...details.items.map((item) => _ItemTile(item: item)),
        ],
      ),
    );
  }
}

// ─── بلاطة صنف ─────────────────────────────────────────────────────
class _ItemTile extends StatelessWidget {
  final DeliveryItem item;

  const _ItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final discrepancyColor = item.hasDiscrepancy ? constRed : constGreen;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: item.hasDiscrepancy
              ? constRed.withOpacity(0.3)
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.medication_outlined, size: 16, color: constBlue),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.displayName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: constColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: discrepancyColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: discrepancyColor.withOpacity(0.3)),
                ),
                child: Text(
                  item.hasDiscrepancy
                      ? 'فرق: ${item.quantityDiscrepancy}'
                      : 'مطابق ✓',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: discrepancyColor,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  'دفعة: ${item.batchNumber}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontFamily: 'Cairo',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'انتهاء: ${item.formattedExpiry}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _qtyBox(
                'مرسَل',
                item.shippedQuantity,
                item.unitAbbreviation,
                constBlue,
              ),
              const SizedBox(width: 8),
              _qtyBox(
                'مستلَم',
                item.receivedQuantity,
                item.unitAbbreviation,
                constGreen,
              ),
              const SizedBox(width: 8),
              _qtyBox('الفرق', item.quantityDiscrepancy, '', discrepancyColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyBox(String label, int value, String unit, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                unit.isEmpty ? '$value' : '$value $unit',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: color,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey.shade600,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── بطاقة معلومات ─────────────────────────────────────────────────
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
