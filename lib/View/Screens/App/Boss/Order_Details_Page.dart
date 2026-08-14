// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Get_Request_Items_Controller.dart';
import 'package:stock_mate_project/Controller/Service/Get_Request_Details_Controller.dart';
import 'package:stock_mate_project/core/Function/Custom_Dialog.dart';
import 'package:stock_mate_project/core/Function/Custom_Dialog_With_Textfailed.dart';
import 'package:stock_mate_project/core/Function/Find_Color.dart';
import 'package:stock_mate_project/core/models/Order_Item.dart';

import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Version_Custom_Recurring_Details_Card.dart';

class DisOrderDetailsPage extends StatelessWidget {
  DisOrderDetailsPage({super.key, required this.item})
    : controller = Get.put(
        RequestItemController(requestId: item.id),
        tag: item.id,
      );

  final OrdertItem item;
  final RequestItemController controller;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Get.delete<RequestItemController>(tag: item.id);
        }
      },
      child: Scaffold(
        floatingActionButton: Obx(() {
          if (controller.isLoading.value) {
            return const SizedBox.shrink();
          }

          final currentStatus = controller.details.value?.status;

          if (controller.isApproved.value ||
              controller.isRejected.value ||
              currentStatus != OrderStatus.pending_hospital_approval) {
            return const SizedBox.shrink();
          }

          return SizedBox(
            width: context.screenWidth * 0.15,
            height: context.screenHeight * 0.1,
            child: FloatingActionButton(
              backgroundColor: constBlue,
              elevation: 8,
              shape: const CircleBorder(),
              onPressed:
                  (controller.isApproving.value || controller.isRejecting.value)
                  ? null
                  : () {
                      showConfirmDialog(
                        onConfirm: () => controller.approveRequest(),
                        onReject: () {
                          showDialogWithTextFailed(
                            onConfirm: (reason) {
                              controller.rejectRequest(reason);
                            },
                          );
                        },
                        sub: 'هل أنت متأكد من الموافقة على هذا الطلب؟',
                        tital: 'تأكيد الموافقة',
                      );
                    },
              child: controller.isApproving.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check, color: Colors.white),
            ),
          );
        }),
        body: Column(
          children: [
            CustomBackContainer(),
            CustomHeadContainer(title: 'تفاصيل الطلب'),
            Expanded(
              child: SingleChildScrollView(
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
                            // ─── القسم ───────────────────────────────
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: context.screenHeight * 0.028,
                                      color: constGray,
                                    ),
                                    SizedBox(width: context.screenWidth * 0.02),
                                    Text(
                                      ' القسم',
                                      style: TextStyle(
                                        color: constGray,
                                        fontFamily: cairo,
                                        fontSize: context.screenHeight * 0.019,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  item.department?.name ?? '-',
                                  style: TextStyle(
                                    fontFamily: cairo,
                                    fontSize: context.screenHeight * 0.019,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: context.screenHeight * 0.01),
                            Divider(indent: 16, endIndent: 16, thickness: 0.5),
                            // ─── النوع ───────────────────────────────
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.grid_view_outlined,
                                      size: context.screenHeight * 0.028,
                                      color: constGray,
                                    ),
                                    SizedBox(width: context.screenWidth * 0.02),
                                    Text(
                                      'النوع',
                                      style: TextStyle(
                                        color: constGray,
                                        fontFamily: cairo,
                                        fontSize: context.screenHeight * 0.019,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  item.requestTypeLabel,
                                  style: TextStyle(
                                    fontFamily: cairo,
                                    fontSize: context.screenHeight * 0.019,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: context.screenHeight * 0.01),
                            Divider(indent: 16, endIndent: 16, thickness: 0.5),
                            // ─── التاريخ ──────────────────────────────
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.date_range,
                                      size: context.screenHeight * 0.028,
                                      color: constGray,
                                    ),
                                    SizedBox(width: context.screenWidth * 0.02),
                                    Text(
                                      'التاريخ',
                                      style: TextStyle(
                                        color: constGray,
                                        fontFamily: cairo,
                                        fontSize: context.screenHeight * 0.019,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  item.formattedCreatedAt,
                                  style: TextStyle(
                                    fontFamily: cairo,
                                    fontSize: context.screenHeight * 0.019,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: context.screenHeight * 0.01),
                            Divider(indent: 16, endIndent: 16, thickness: 0.5),
                            // ─── الأولوية ─────────────────────────────
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.bolt_outlined,
                                      size: context.screenHeight * 0.028,
                                      color: constGray,
                                    ),
                                    SizedBox(width: context.screenWidth * 0.02),
                                    Text(
                                      'الاولوية',
                                      style: TextStyle(
                                        color: constGray,
                                        fontFamily: cairo,
                                        fontSize: context.screenHeight * 0.019,
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
                                    color: item.priority == OrderPriority.urgent
                                        ? const Color(0xFFFDE8E8)
                                        : const Color(0xFFE8F0FE),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item.priorityLabel,
                                    style: TextStyle(
                                      fontFamily: cairo,
                                      fontSize: context.screenHeight * 0.019,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          item.priority == OrderPriority.urgent
                                          ? Colors.red
                                          : Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: context.screenHeight * 0.01),
                            Divider(indent: 16, endIndent: 16, thickness: 0.5),
                            // ─── الحالة ───────────────────────────────
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.list_alt_outlined,
                                      size: context.screenHeight * 0.028,
                                      color: constGray,
                                    ),
                                    SizedBox(width: context.screenWidth * 0.02),
                                    Text(
                                      'الحالة',
                                      style: TextStyle(
                                        color: constGray,
                                        fontFamily: cairo,
                                        fontSize: context.screenHeight * 0.019,
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
                                      word: item.statusLabel,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item.statusLabel,
                                    style: TextStyle(
                                      fontFamily: cairo,
                                      fontSize: context.screenHeight * 0.019,
                                      fontWeight: FontWeight.w600,
                                      color: FindColor().findFontColorFunction(
                                        word: item.statusLabel,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // ─── سبب الرفض (لو موجود) ─────────────────
                            Obx(() {
                              final d = controller.details.value;
                              if (d == null ||
                                  !d.isRejected ||
                                  d.activeRejectionReason == null) {
                                return const SizedBox.shrink();
                              }
                              return Column(
                                children: [
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
                                          fontSize:
                                              context.screenHeight * 0.019,
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
                              );
                            }),
                          ],
                        ),
                      ),
                    ),

                    // ─── قائمة الأصناف ─────────────────────────────
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: context.screenHeight * 0.02,
                      ),
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(child: CustomLoadingIndicator());
                        }

                        final d = controller.details.value;

                        if (controller.hasError.value || d == null) {
                          return Column(
                            children: [
                              CustomEmptyState(
                                tital: 'تعذر تحميل تفاصيل الأصناف',
                              ),
                              TextButton(
                                onPressed: controller.fetchDetails,
                                child: const Text('إعادة المحاولة'),
                              ),
                            ],
                          );
                        }

                        if (d.items.isEmpty) {
                          return CustomEmptyState(
                            tital: 'لا توجد أصناف لهذا الطلب',
                          );
                        }

                        return ListView.builder(
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
                              child: VersionCustomRecurringDetailsCard(
                                requestItemModel: d.items[index],
                              ),
                            );
                          },
                        );
                      }),
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
