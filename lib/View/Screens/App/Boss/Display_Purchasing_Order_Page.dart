// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Purchase_Order_Details_Controller.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Purchasing_Item_Card.dart';
import 'package:stock_mate_project/core/Function/Find_Color.dart';
import 'package:stock_mate_project/core/models/Order_Item.dart'
    show OrderStatus, OrderPriority;
import 'package:stock_mate_project/core/models/Purchase_Request_Model.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/custom_Head_Card.dart';

class DisplayPurchasingOrderPage extends StatelessWidget {
  DisplayPurchasingOrderPage({super.key, required this.requestId})
    : controller = Get.put(
        PurchaseOrderDetailsController(requestId: requestId),
        tag: requestId,
      );

  final String requestId;
  final PurchaseOrderDetailsController controller;

  // ← نفس تصنيف statusLabel الموجود بـ PurchaseRequestListItem
  String _statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.draft:
        return 'معلق';
      case OrderStatus.pending_hospital_approval:
        return 'بأنتظار موافقتك';
      case OrderStatus.pending_manager_approval:
      case OrderStatus.preparing:
        return 'قيد التنفيذ';
      case OrderStatus.hospital_rejected:
      case OrderStatus.manager_rejected:
      case OrderStatus.cancelled:
        return 'مرفوض';
      case OrderStatus.partially_complete:
        return 'منجز';
      case OrderStatus.complete:
        return 'مستلم';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Get.delete<PurchaseOrderDetailsController>(tag: requestId);
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            CustomBackContainer(),
            CustomHeadContainer(title: 'تفاصيل طلب الشراء'),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CustomLoadingIndicator());
                }

                final PurchaseRequestDetails? d = controller.details.value;

                if (controller.hasError.value || d == null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomEmptyState(tital: 'تعذر تحميل تفاصيل الطلب'),
                      TextButton(
                        onPressed: controller.fetchDetails,
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.screenWidth * 0.02,
                          vertical: context.screenHeight * 0.003,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.screenWidth * 0.04,
                            vertical: context.screenHeight * 0.015,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 8,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: context.screenHeight * 0.01),

                              // ─── صاحب الطلب ────────────────────────
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: context.screenHeight * 0.028,
                                        color: constGray,
                                      ),
                                      SizedBox(
                                        width: context.screenWidth * 0.02,
                                      ),
                                      Text(
                                        'صاحب الطلب',
                                        style: TextStyle(
                                          color: constGray,
                                          fontFamily: cairo,
                                          fontSize:
                                              context.screenHeight * 0.019,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    d.requestedBy?.fullName ?? '-',
                                    style: TextStyle(
                                      fontFamily: cairo,
                                      fontSize: context.screenHeight * 0.019,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: context.screenHeight * 0.01),
                              Divider(indent: 16, endIndent: 16),
                              // ─── التاريخ ───────────────────────────
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.date_range,
                                        size: context.screenHeight * 0.028,
                                        color: constGray,
                                      ),
                                      SizedBox(
                                        width: context.screenWidth * 0.02,
                                      ),
                                      Text(
                                        'التاريخ',
                                        style: TextStyle(
                                          color: constGray,
                                          fontFamily: cairo,
                                          fontSize:
                                              context.screenHeight * 0.019,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    d.formattedCreatedAt,
                                    style: TextStyle(
                                      fontFamily: cairo,
                                      fontSize: context.screenHeight * 0.019,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: context.screenHeight * 0.01),
                              Divider(
                                indent: 16,
                                endIndent: 16,
                                thickness: 0.5,
                              ),
                              // ─── الأولوية ──────────────────────────
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.bolt_outlined,
                                        size: context.screenHeight * 0.028,
                                        color: constGray,
                                      ),
                                      SizedBox(
                                        width: context.screenWidth * 0.02,
                                      ),
                                      Text(
                                        'الاولوية',
                                        style: TextStyle(
                                          color: constGray,
                                          fontFamily: cairo,
                                          fontSize:
                                              context.screenHeight * 0.019,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.screenWidth * 0.04,
                                      vertical: context.screenHeight * 0.005,
                                    ),
                                    decoration: BoxDecoration(
                                      color: d.priority == OrderPriority.urgent
                                          ? const Color(0xFFFDE8E8)
                                          : const Color(0xFFE8F0FE),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      d.priority == OrderPriority.urgent
                                          ? 'ضروري'
                                          : 'عادي',
                                      style: TextStyle(
                                        fontFamily: cairo,
                                        fontSize: context.screenHeight * 0.019,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            d.priority == OrderPriority.urgent
                                            ? Colors.red
                                            : Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: context.screenHeight * 0.01),
                              Divider(
                                indent: 16,
                                endIndent: 16,
                                thickness: 0.5,
                              ),
                              // ─── الحالة ────────────────────────────
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.list_alt_outlined,
                                        size: context.screenHeight * 0.028,
                                        color: constGray,
                                      ),
                                      SizedBox(
                                        width: context.screenWidth * 0.02,
                                      ),
                                      Text(
                                        'الحالة',
                                        style: TextStyle(
                                          color: constGray,
                                          fontFamily: cairo,
                                          fontSize:
                                              context.screenHeight * 0.019,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.screenWidth * 0.04,
                                      vertical: context.screenHeight * 0.005,
                                    ),
                                    decoration: BoxDecoration(
                                      color: FindColor().findBackgroundColor(
                                        word: _statusLabel(d.status),
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      _statusLabel(d.status),
                                      style: TextStyle(
                                        fontFamily: cairo,
                                        fontSize: context.screenHeight * 0.019,
                                        fontWeight: FontWeight.w600,
                                        color: FindColor()
                                            .findFontColorFunction(
                                              word: _statusLabel(d.status),
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // ─── الملاحظات (لو موجودة) ─────────────
                              if (d.notes != null && d.notes!.isNotEmpty) ...[
                                SizedBox(height: context.screenHeight * 0.01),
                                Divider(
                                  indent: 16,
                                  endIndent: 16,
                                  thickness: 0.5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'الملاحظات',
                                      style: TextStyle(
                                        color: constGray,
                                        fontFamily: cairo,
                                        fontSize: context.screenHeight * 0.019,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        d.notes!,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: cairo,
                                          fontSize:
                                              context.screenHeight * 0.017,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],

                              // ─── اعتماد الطلب (لو معتمد) ────────────

                              // ─── سبب الرفض (لو موجود) ───────────────
                              if (d.isRejected &&
                                  d.activeRejectionReason != null) ...[
                                SizedBox(height: context.screenHeight * 0.01),
                                Divider(
                                  indent: 16,
                                  endIndent: 16,
                                  thickness: 0.5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'سبب الرفض',
                                      style: TextStyle(
                                        color: constGray,
                                        fontFamily: cairo,
                                        fontSize: context.screenHeight * 0.019,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        d.activeRejectionReason!,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: cairo,
                                          fontSize:
                                              context.screenHeight * 0.017,
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

                      // ─── قائمة الأصناف ─────────────────────────────
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: context.screenHeight * 0.02,
                        ),
                        child: d.items.isEmpty
                            ? CustomEmptyState(
                                tital: 'لا توجد أصناف لهذا الطلب',
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: d.items.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.screenWidth * 0.02,
                                      vertical: context.screenHeight * 0.005,
                                    ),
                                    child: CustomPurchasingItemCard(
                                      item: d.items[index],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
