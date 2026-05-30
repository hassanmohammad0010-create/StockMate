// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Details_Card.dart';

import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Reject_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';

class OrderDetailsPage extends StatelessWidget {
  final Order order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        body: Column(
          children: [
            CustomBackContainer(),
            CustomHeadContainer(title: 'تفاصيل الطلب'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    CustomRecurringDetailsCard(order: order),
                    const SizedBox(height: 16),
                    if (order.status == OrderStatus.rejected)
                      RejectionBanner(reason: order.rejectionReason),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
