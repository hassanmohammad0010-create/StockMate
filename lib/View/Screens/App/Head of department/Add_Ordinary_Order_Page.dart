// // ignore_for_file: file_names
// import 'package:flutter/material.dart';
// import 'package:stock_mate_project/Constant/Const.dart';
// import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Add_New_Order_Card.dart';
// import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';
// import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Priority_Choose_Card.dart';

// class AddOrdinaryOrderPage extends StatelessWidget {
//   const AddOrdinaryOrderPage({super.key});

//   final String pageName = "/AddOrdinaryOrderPage";

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           SizedBox(height: MediaQuery.of(context).size.height * 0.002),
//           CustomAddNewOrderCard(),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.002),
//           CustomPriorityChooseCard(),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.06),
//           Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: MediaQuery.of(context).size.width * 0.04,
//             ),
//             child: Divider(),
//           ),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.002),
//           CustomMainButtom(title: 'تأكيد',color: constBlue,fontcolor: Colors.white , onPressed: (){}),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.002),
//         ],
//       ),
//     );
//   }
// }
// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/AddOrdinaryOrder_Controller.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Add_New_Order_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Priority_Choose_Card.dart';

class AddOrdinaryOrderPage extends StatelessWidget {
  const AddOrdinaryOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    // حقن الـ Controller
    final controller = Get.put(AddOrdinaryOrderController());
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: h * 0.012),

          // ─── ترويسة العداد وزر الإضافة ───
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.04),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الطلبات (${controller.orders.length} / ${AddOrdinaryOrderController.maxOrders})',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (controller.canAddMore)
                    TextButton.icon(
                      onPressed: controller.addOrder,
                      icon: const Icon(Icons.add_circle_outline, size: 18),
                      label: const Text('إضافة طلب'),
                      style: TextButton.styleFrom(foregroundColor: constBlue),
                    ),
                ],
              ),
            ),
          ),

          SizedBox(height: h * 0.012),

          // ─── قائمة الطلبات ───
          Obx(
            () => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.orders.length,
              separatorBuilder: ( _ , _ ) => SizedBox(height: h * 0.008),
              itemBuilder: (context, index) {
                return _OrderItemCard(index: index, controller: controller);
              },
            ),
          ),

          SizedBox(height: h * 0.04),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.04),
            child: const Divider(),
          ),

          SizedBox(height: h * 0.012),

          // ─── زر التأكيد ───
          Obx(
            () => CustomMainButtom(
              title: 'تأكيد الإرسال (${controller.orders.length})',
              color: constBlue,
              fontcolor: Colors.white,
              onPressed: controller.confirmOrders,
            ),
          ),

          SizedBox(height: h * 0.02),
        ],
      ),
    );
  }
}

class _OrderItemCard extends StatelessWidget {
  const _OrderItemCard({required this.index, required this.controller});

  final int index;
  final AddOrdinaryOrderController controller;

  @override
  Widget build(BuildContext context) {
    final order = controller.orders[index];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Obx(() {
          final isExpanded = controller.expandedIndex.value == index;

          return Column(
            children: [
              // ─── رأس البطاقة ───
              ListTile(
                onTap: () => controller.toggleExpanded(index),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                leading: CircleAvatar(
                  radius: 15,
                  // ignore: deprecated_member_use
                  backgroundColor: constBlue.withOpacity(0.12),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: constBlue,
                    ),
                  ),
                ),
                title: Obx(
                  () => Text(
                    order.medicine.value.isEmpty
                        ? 'طلب جديد'
                        : order.medicine.value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                subtitle: Obx(
                  () => Text(
                    'الكمية: ${order.quantity.value}  •  ${order.priority.value}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                trailing: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                ),
              ),

              // ─── منطقة التعديل ───
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(height: 1),
                      const SizedBox(height: 12),

                      // مرر order لهذين الـ widget حسب تصميمك
                      CustomAddNewOrderCard(
                        order: OrderItem(), // مرر الـ order هنا
                        // مثال:
                        // initialValue: order.medicine.value,
                        // onChanged: (val) => order.medicine.value = val,
                      ),

                      const SizedBox(height: 10),

                      CustomPriorityChooseCard(
                        order: OrderItem(), // مرر الـ order هنا
                        // مثال:
                        // selected: order.priority.value,
                        // onSelected: (p) => order.priority.value = p,
                      ),

                      const SizedBox(height: 14),

                      if (controller.orders.length > 1)
                        TextButton.icon(
                          onPressed: () => controller.removeOrder(index),
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.red,
                          ),
                          label: const Text(
                            'حذف هذا الطلب',
                            style: TextStyle(color: Colors.red, fontSize: 13),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

