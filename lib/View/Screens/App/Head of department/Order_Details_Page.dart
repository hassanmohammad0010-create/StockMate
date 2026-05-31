// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Department_Heads_Add_New_Order_Page.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Details_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Reject_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';

class OrderDetailsPage extends StatelessWidget {
 const OrderDetailsPage({super.key, required this.order});


  final String pageName = '/OrderDetailsPage';
  final Order order;



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
                    CustomDetailsCard(order: order),
                    const SizedBox(height: 16),
                    order.status == OrderStatus.rejected
                        ? RejectionBanner(reason: order.rejectionReason)
                        : const SizedBox(),
                    order.isRecurring && order.status == OrderStatus.completed
                        ? const SizedBox(height: 112)
                        : order.status == OrderStatus.rejected
                        ? const SizedBox(height: 52)
                        : const SizedBox(height: 154),
                    order.isRecurring && order.status == OrderStatus.completed
                        ? CustomMainButtom(
                            title: 'حذف الطلب',
                            color: constRed,
                            fontcolor: Colors.white,
                            onPressed: () {},
                          )
                        : const SizedBox(),
                    const SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.02,
                      ),
                      child: Divider(),
                    ),
                    const SizedBox(height: 8),
                    CustomMainButtom(
                      title: 'ارسال طلب جديد',
                      color: constLightBlue,
                      fontcolor: constBlue,
                      onPressed: () {
                        Get.toNamed(DepartmentHeadsAddNewOrderPage().pageName);
                      },
                    ),
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
