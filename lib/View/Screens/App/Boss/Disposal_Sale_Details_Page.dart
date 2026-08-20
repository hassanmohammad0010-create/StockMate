// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Get_Disposal_Sale_Details_Controller.dart';
import 'package:stock_mate_project/core/Function/Find_Color.dart';
import 'package:stock_mate_project/core/models/Disposal_Sales_Page_Data_Model.dart'
    show DisposalSaleRequestStatus;
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/Custom_Dialog.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/DialogType.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/custom_Head_Card.dart';

class DisposalSaleDetailsPage extends StatelessWidget {
  DisposalSaleDetailsPage({super.key, required this.disposalSaleRequestId})
    : controller = Get.put(
        GetDisposalSaleDetailsController(
          disposalSaleRequestId: disposalSaleRequestId,
        ),
        tag: disposalSaleRequestId,
      );

  final String disposalSaleRequestId;
  final GetDisposalSaleDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Get.delete<GetDisposalSaleDetailsController>(
            tag: disposalSaleRequestId,
          );
        }
      },
      child: Scaffold(
        // ✅ جديد — نفس منطق DisOrderDetailsPage
        floatingActionButton: Obx(() {
          if (controller.isLoading.value) {
            return const SizedBox.shrink();
          }

          final currentStatus = controller.details.value?.status;

          if (controller.isApproved.value ||
              controller.isRejected.value ||
              currentStatus != DisposalSaleRequestStatus.pendingApproval) {
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
                      CustomDialog.show(
                        title: 'تأكيد الموافقة',
                        message: 'هل أنت متأكد من الموافقة على هذا الطلب؟',
                        type: DialogType.warning,
                        confirmText: 'موافقة',
                        cancelText: 'رفض',
                        onConfirm: () {
                          Get.back();
                          controller.approveRequest();
                        },
                        onCancel: () {
                          Get.back();
                          final TextEditingController reasonController =
                              TextEditingController();

                          CustomDialog.show(
                            title: 'سبب الرفض',
                            message: 'الرجاء إدخال سبب رفض الطلب',
                            type: DialogType.warning,
                            confirmText: 'تأكيد',
                            cancelText: 'إلغاء',
                            showTextField: true,
                            textFieldHint: 'ادخل سبب الرفض',
                            textFieldLabel: 'سبب الرفض',
                            textFieldIcon: Icons.edit_outlined,
                            textFieldKeyboard: TextInputType.text,
                            textFieldController: reasonController,
                            textFieldValidator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'الرجاء إدخال سبب الرفض';
                              }
                              return null;
                            },
                            onConfirm: () {
                              Get.back();
                              controller.rejectRequest(
                                reasonController.text.trim(),
                              );
                            },
                          );
                        },
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
            CustomHeadContainer(title: 'تفاصيل طلب بيع الإتلاف'),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CustomLoadingIndicator());
                }

                final d = controller.details.value;

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
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _infoRow(
                                context,
                                icon: Icons.local_shipping_outlined,
                                label: 'الوجهة',
                                value: d.destination?.name ?? '-',
                              ),
                              const Divider(indent: 16, endIndent: 16),
                              _infoRow(
                                context,
                                icon: Icons.person,
                                label: 'مقدم الطلب',
                                value: d.requestedBy?.fullName ?? '-',
                              ),
                              const Divider(indent: 16, endIndent: 16),
                              _infoRow(
                                context,
                                icon: Icons.date_range,
                                label: 'التاريخ',
                                value: d.formattedCreatedAt,
                              ),
                              const Divider(indent: 16, endIndent: 16),

                              // ─── الحالة ✅ صارت Obx مستقلة عشان تتحدث فورًا ──
                              Obx(() {
                                final currentDetails = controller.details.value;
                                final label =
                                    currentDetails?.statusLabel ??
                                    d.statusLabel;
                                return Row(
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
                                          word: label,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        label,
                                        style: TextStyle(
                                          fontFamily: cairo,
                                          fontSize:
                                              context.screenHeight * 0.019,
                                          fontWeight: FontWeight.w600,
                                          color: FindColor()
                                              .findFontColorFunction(
                                                word: label,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),

                              // ─── سبب الرفض (لو موجود) ✅ Obx مستقلة ────
                              Obx(() {
                                final currentDetails = controller.details.value;
                                if (currentDetails == null ||
                                    !currentDetails.isRejected ||
                                    currentDetails.rejectionReason == null) {
                                  return const SizedBox.shrink();
                                }
                                return Column(
                                  children: [
                                    const Divider(indent: 16, endIndent: 16),
                                    _infoRow(
                                      context,
                                      icon: Icons.info_outline,
                                      label: 'سبب الرفض',
                                      value: currentDetails.rejectionReason!,
                                    ),
                                  ],
                                );
                              }),

                              const Divider(indent: 16, endIndent: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'إجمالي المبلغ',
                                    style: TextStyle(
                                      color: constGray,
                                      fontFamily: cairo,
                                      fontSize: context.screenHeight * 0.019,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    d.totalAmount.toStringAsFixed(2),
                                    style: TextStyle(
                                      fontFamily: cairo,
                                      fontSize: context.screenHeight * 0.019,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ─── قائمة الأصناف ─────────────────────────
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
                                  final item = d.items[index];
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.screenWidth * 0.02,
                                      vertical: context.screenHeight * 0.005,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.variant?.variantName ?? '-',
                                            style: TextStyle(
                                              fontFamily: cairo,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            'الكمية: ${item.quantity} | السعر: ${item.price} | الإجمالي: ${item.subtotal.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontFamily: cairo,
                                              fontSize: 13,
                                              color: constGray,
                                            ),
                                          ),
                                          if (item.batch != null)
                                            Text(
                                              'الدفعة: ${item.batch!.batchNumber}',
                                              style: TextStyle(
                                                fontFamily: cairo,
                                                fontSize: 13,
                                                color: constGray,
                                              ),
                                            ),
                                        ],
                                      ),
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

  Widget _infoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: context.screenHeight * 0.028, color: constGray),
            SizedBox(width: context.screenWidth * 0.02),
            Text(
              label,
              style: TextStyle(
                color: constGray,
                fontFamily: cairo,
                fontSize: context.screenHeight * 0.019,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: cairo,
              fontSize: context.screenHeight * 0.019,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
