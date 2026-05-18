// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';
import 'package:stock_mate_project/View/Widget/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/View/Widget/Shared_Widget/Custom_Details_Card.dart';
import 'package:stock_mate_project/View/Widget/Shared_Widget/Custom_Head_Card.dart';
import 'package:stock_mate_project/View/Widget/Shared_Widget/Custom_Status_Banner.dart';

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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CustomHeadContainer(empName: 'تفاصيل الطلب'),
                    const SizedBox(height: 16),
                    CustomDetailsCard(order: order),
                    const SizedBox(height: 16),
                    CustomStatusBanner(order: order),
                    // Visibility(
                    //   // visible: order.status == OrderStatus.suspended,
                    //   child: Row(
                    //     children: [
                    //       Container(
                    //         width: MediaQuery.of(context).size.width * 2 / 3,
                    //         height: 200,
                    //         decoration: BoxDecoration(
                    //           color: constGreen,
                    //           borderRadius: BorderRadius.circular(8),
                    //         ),
                    //         child: Text('26548sko'),
                    //       ),
                    //     ],
                    //   ),
                    // ),
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
