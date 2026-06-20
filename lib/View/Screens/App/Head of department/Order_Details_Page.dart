// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Orders_Controller.dart';
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

  // ── يفتح Dialog تأكيد الاستلام ويتحقق من صحة الكمية المدخلة ──
  void _showConfirmReceiveDialog(OrdersController controller) {
    final textController = TextEditingController();

    CustomDialog.show(
      type: DialogType.info,
      title: 'تأكيد الاستلام',
      message: 'هل أنت متأكد من تأكيد استلام هذا الطلب؟',
      showTextField: true,
      textFieldHint: 'ادخل الكمية المستلمة (اتركه فارغاً لاستلام الكل)',
      textFieldIcon: Icons.inventory_2_outlined,
      textFieldKeyboard: TextInputType.number,
      textFieldController: textController,
      textFieldValidator: (value) {
        // فارغ => يعني استلام الكمية كاملة، هذا مقبول
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
          // الكمية الفعلية المستلمة: المُدخلة، أو الكمية كاملة لو ترك الحقل فارغاً
          final confirmedQty = receivedQty ?? order.quantity;

          CustomDialog.show(
            type: DialogType.success,
            title: 'تأكيد الاستلام',
            message: 'تم تأكيد استلام $confirmedQty بنجاح.',
            showCancel: false,
          );
        } else {
          CustomDialog.show(
            type: DialogType.danger,
            title: 'تعذر تأكيد الاستلام',
            message:
                'حدث خطأ أثناء تأكيد استلام الطلب، الرجاء المحاولة لاحقاً.',
            showCancel: false,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                        ? Obx(() {
                            // نقرأ نسخة الطلب المحدثة من الكونترولر عبر الـ id
                            final liveOrder =
                                controller.getOrderById(order.id!) ?? order;

                            if (liveOrder.receivedConfirmed) {
                              final confirmedQty =
                                  liveOrder.receivedQuantity ??
                                  liveOrder.quantity;
                              return CustomMainButtom(
                                title: 'تم تأكيد استلام $confirmedQty وحدة',
                                color: constlightGreen,
                                fontcolor: constGreen,
                                onPressed: () {},
                              );
                            }
                            return CustomMainButtom(
                              title: 'تأكيد الاستلام',
                              color: constGreen,
                              fontcolor: Colors.white,
                              onPressed: () =>
                                  _showConfirmReceiveDialog(controller),
                            );
                          })
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
