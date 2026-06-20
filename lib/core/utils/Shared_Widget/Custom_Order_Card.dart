// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Priority_Badge.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Recurring_Badge.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Status_Badge.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const OrderCard({super.key, required this.order, required this.onTap});

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
                    Text(
                      order.medicineName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: constColor,
                      ),
                    ),
                    SizedBox(height: context.screenHeight * 0.01),
                    Text(
                      'التاريخ : ${order.date}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF4B5563),
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
                                'الكمية : ${order.quantity}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF4B5563),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: context.screenWidth * 0.02),
                        if (order.isRecurring &&
                            order.recurringInterval != null)
                          RecurringBadge(interval: order.recurringInterval!)
                        else
                          PriorityBadge(priority: order.priority),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: context.screenWidth * 0.04),
              StatusBadge(status: order.status),
            ],
          ),
        ),
      ),
    );
  }
}
