// ignore_for_file: file_names, deprecated_member_use, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/PriorityBadge.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/RecurringBadge.dart';
import 'package:stock_mate_project/core/models/Order_Item.dart';
import 'package:stock_mate_project/core/models/Refill_Delivery_Model.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/StatusBadge.dart';

class RequestCard extends StatelessWidget {
  final OrdertItem request;
  final List<RefillDelivery> pendingDeliveries;
  final VoidCallback onTap;
  final VoidCallback? onConfirmDelivery;

  const RequestCard({
    super.key,
    required this.request,
    this.pendingDeliveries = const [],
    required this.onTap,
    this.onConfirmDelivery,
  });

  @override
  Widget build(BuildContext context) {
    final hasDeliveries = pendingDeliveries.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: context.screenHeight * 0.01),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          // ✅ إطار برتقالي خفيف إذا كان هناك تسليم وارد
          border: hasDeliveries
              ? Border.all(color: constOrange.withOpacity(0.4), width: 1.5)
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.screenWidth * 0.04,
            vertical: context.screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── رقم الطلب ──
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            request.requestNumber,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: constColor,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                        SizedBox(height: context.screenHeight * 0.01),

                        // ── اسم القسم + التاريخ ──
                        Text(
                          '${request.department?.name ?? 'القسم'} • ${request.formattedCreatedAt}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF4B5563),
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: context.screenWidth * 0.25,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.inventory_2_outlined,
                                    size: 14,
                                    color: Color(0xFF6B7280),
                                  ),
                                  SizedBox(width: context.screenWidth * 0.01),
                                  Text(
                                    request.isRecurring ? 'دوري' : 'عادي',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF4B5563),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: context.screenWidth * 0.02),

                            if (request.isRecurring &&
                                request.recurringInterval != null)
                              RecurringBadge(
                                interval: request.recurringInterval!,
                              )
                            else
                              PriorityBadge(priority: request.priority),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: context.screenWidth * 0.04),

                  // ✅ StatusBadge
                  StatusBadge(status: request.status),
                ],
              ),

              // ── ✅ شارات التسليم الوارد + زر تأكيد ────────────────────
              if (hasDeliveries) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: pendingDeliveries
                            .map((d) => _DeliveryBadge(delivery: d))
                            .toList(),
                      ),
                    ),
                    // ✅ زر تأكيد الاستلام المباشر
                    if (onConfirmDelivery != null)
                      ElevatedButton.icon(
                        onPressed: onConfirmDelivery,
                        icon: const Icon(Icons.verified_outlined, size: 20),
                        label: const Text(
                          'تأكيد',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: constGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── شارة تسليم وارد ──────────────────────────────────────────────
class _DeliveryBadge extends StatelessWidget {
  final RefillDelivery delivery;

  const _DeliveryBadge({required this.delivery});

  @override
  Widget build(BuildContext context) {
    final isFinal = delivery.type.isFinal;
    final color = isFinal ? constGreen : constOrange;
    final bgColor = isFinal
        ? constLightGreen.withOpacity(0.5)
        : constLightOrange.withOpacity(0.5);
    final icon = isFinal
        ? Icons.done_all_rounded
        : Icons.local_shipping_outlined;
    final label = isFinal ? 'نهائية' : 'دفعة';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(width: 4),
          Text(
            delivery.shortDate,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}
