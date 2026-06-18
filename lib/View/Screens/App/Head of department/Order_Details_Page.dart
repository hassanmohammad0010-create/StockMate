// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Details_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Dialog.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Reject_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: constBackgroundColor,
        body: Column(
          children: [
            CustomBackContainer(),
            CustomHeadContainer(title: 'تفاصيل الطلب'),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: context.screenWidth * 0.03,
                ),
                child: Column(
                  children: [
                    SizedBox(height: context.screenHeight * 0.02),
                    CustomDetailsCard(order: order),
                    SizedBox(height: context.screenHeight * 0.02),
                    order.status == OrderStatus.rejected
                        ? order.rejectionReason == ''
                              ? SizedBox(height: context.screenHeight * 0.12)
                              : RejectionBanner(reason: order.rejectionReason)
                        : const SizedBox(),
                    order.isRecurring &&
                                order.status == OrderStatus.completed ||
                            order.isRecurring == false &&
                                order.status == OrderStatus.completed
                        ? SizedBox(height: context.screenHeight * 0.12)
                        : order.status == OrderStatus.rejected
                        ? SizedBox(height: context.screenHeight * 0.06)
                        : SizedBox(height: context.screenHeight * 0.18),
                    order.isRecurring && order.status == OrderStatus.completed
                        ? CustomMainButtom(
                            title: 'حذف الطلب',
                            color: constRed,
                            fontcolor: Colors.white,
                            onPressed: () => CustomDialog.show(
                              type: DialogType.danger,
                              title: 'حذف الطلب',
                              message: 'هل أنت متأكد من حذف هذا الطلب؟',
                            ),
                          )
                        : order.isRecurring == false &&
                              order.status == OrderStatus.completed
                        ? CustomMainButtom(
                            title: 'تأكيد الاستلام',
                            color: constGreen,
                            fontcolor: Colors.white,
                            onPressed: () => CustomDialog.show(
                              type: DialogType.info,
                              title: 'تأكيد الاستلام',
                              message:
                                  'هل أنت متأكد من تأكيد استلام هذا الطلب؟',
                              showTextField: true,
                              textFieldHint: 'ادخل الكمية المستلمة',
                              textFieldIcon: Icons.inventory_2_outlined,
                            ),
                          )
                        : const SizedBox(),
                    SizedBox(height: context.screenHeight * 0.01),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.screenWidth * 0.02,
                      ),
                      child: Divider(),
                    ),
                    SizedBox(height: context.screenHeight * 0.01),
                    CustomMainButtom(
                      title: 'ارسال طلب جديد',
                      color: constLightBlue,
                      fontcolor: constBlue,
                      onPressed: () {
                        Get.toNamed(AppRoutes.DepartmentHeadsAddNewOrderPage);
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
