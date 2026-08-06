// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Test/PriorityBadge.dart';
import 'package:stock_mate_project/Test/RecurringBadge.dart';
import 'package:stock_mate_project/Test/RefillRequestsPageData.dart';
import 'package:stock_mate_project/Test/StatusBadge.dart';

class OrderCard2 extends StatelessWidget {
  final RefillRequestItem2 request;
  final VoidCallback onTap;

  const OrderCard2({super.key, required this.request, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.screenWidth * 0.04,
            vertical: context.screenHeight * 0.02,
          ),
          child: Row(
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
                        // ignore: sized_box_for_whitespace
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
                                request.requestTypeLabel,
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

                        // ✅ استخدام الـ enums مباشرة (متوافقة مع الـ Badges)
                        if (request.isRecurring &&
                            request.recurringInterval != null)
                          RecurringBadge(interval: request.recurringInterval!)
                        else
                          PriorityBadge(priority: request.priority),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: context.screenWidth * 0.04),

              // ✅ استخدام الـ enum مباشرة
              StatusBadge(status: request.status),
            ],
          ),
        ),
      ),
    );
  }
}
