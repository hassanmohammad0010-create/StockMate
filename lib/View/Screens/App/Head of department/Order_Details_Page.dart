// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Orders_Controller.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/Custom_Dialog.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/DialogType.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Details_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Reject_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key, required this.order});

  final Order order;

  void _showConfirmReceiveDialog(OrdersController controller) {
    final textController = TextEditingController();

    CustomDialog.show(
      type: DialogType.info,
      title: 'تأكيد الاستلام',
      message:
          'الكمية المطلوبة: ${order.quantity}\nالرجاء إدخال الكمية المستلمة.',
      showTextField: true,
      textFieldHint: 'ادخل الكمية المستلمة (${order.quantity})',
      textFieldIcon: Icons.inventory_2_outlined,
      textFieldKeyboard: TextInputType.number,
      textFieldController: textController,
      textFieldValidator: (value) {
        if (value == null || value.trim().isEmpty) return null;
        final parsed = int.tryParse(value.trim());
        if (parsed == null) {
          return 'الرجاء إدخال رقم صحيح';
        }
        if (parsed <= 0) {
          return 'الكمية يجب أن تكون أكبر من صفر';
        }
        if (parsed > order.quantity) {
          return 'لا يمكن استلام كمية أكبر من الكمية المطلوبة (${order.quantity})';
        }
        return null;
      },
      onConfirm: () {
        final text = textController.text.trim();
        final receivedQty = text.isEmpty ? null : int.tryParse(text);
        final success = controller.confirmReceive(
          order.id!,
          receivedQty: receivedQty,
        );

        Get.back();

        if (success) {
          final confirmedQty = receivedQty ?? order.quantity;

          customSnackBar(
            title: 'تأكيد الاستلام',
            message: 'تم تأكيد استلام $confirmedQty بنجاح.',
            color: constGreen,
            messageColor: Colors.white,
          );
        } else {
          customSnackBar(
            title: 'تعذر تأكيد الاستلام',
            message:
                'حدث خطأ أثناء تأكيد استلام الطلب، الرجاء المحاولة لاحقاً.',
            color: constRed,
            messageColor: Colors.white,
          );
        }
      },
    );
  }

  Widget _buildStatusActionButton(
    Order liveOrder,
    OrdersController controller,
  ) {
    final showRecurringDeleteButton =
        liveOrder.isRecurring && liveOrder.status == OrderStatus.completed;
    final showReceivedButton =
        !liveOrder.isRecurring && liveOrder.status == OrderStatus.reserved;
    final showConfirmReceiveButton =
        !liveOrder.isRecurring && liveOrder.status == OrderStatus.completed;

    if (showRecurringDeleteButton) {
      return CustomMainButtom(
        title: 'حذف الطلب',
        color: constRed,
        fontcolor: Colors.white,
        onPressed: () => CustomDialog.show(
          type: DialogType.danger,
          title: 'حذف الطلب',
          message: 'هل أنت متأكد من حذف هذا الطلب؟',
        ),
      );
    }

    if (showReceivedButton) {
      final confirmedQty = liveOrder.receivedQuantity ?? liveOrder.quantity;
      return CustomMainButtom(
        title: 'تم تأكيد استلام $confirmedQty وحدة',
        color: constLightGreen,
        fontcolor: constGreen,
        onPressed: () {},
      );
    }

    if (showConfirmReceiveButton) {
      return CustomMainButtom(
        title: 'تأكيد الاستلام',
        color: constGreen,
        fontcolor: Colors.white,
        onPressed: () => _showConfirmReceiveDialog(controller),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildBottomBar(double h, double w) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(),
            SizedBox(height: h * 0.01),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    final controller = Get.find<OrdersController>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: constBackgroundColor,
        body: Column(
          children: [
            CustomBackContainer(),
            CustomHeadContainer(title: 'تفاصيل الطلب'),
            Expanded(
              child: Obx(() {
                final liveOrder = controller.getOrderById(order.id!) ?? order;
                final isRejectedWithReason =
                    liveOrder.status == OrderStatus.rejected &&
                    liveOrder.rejectionReason.trim().isNotEmpty;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: h * 0.02),
                      CustomDetailsCard(order: liveOrder),

                      if (isRejectedWithReason) ...[
                        SizedBox(height: h * 0.02),
                        RejectionBanner(reason: liveOrder.rejectionReason),
                      ],

                      SizedBox(height: h * 0.03),
                      _buildStatusActionButton(liveOrder, controller),

                      SizedBox(height: h * 0.02),
                    ],
                  ),
                );
              }),
            ),
            _buildBottomBar(h, w),
          ],
        ),
      ),
    );
  }
}
