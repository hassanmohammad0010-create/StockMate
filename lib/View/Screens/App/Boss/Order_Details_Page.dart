// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Get_Request_Items_Controller.dart';
import 'package:stock_mate_project/core/Function/Find_Color.dart';
import 'package:stock_mate_project/core/models/Order_Item.dart'; // يحتوي على OrderStatus و OrderPriority
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/Custom_Dialog.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/DialogType.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Version_Custom_Recurring_Details_Card.dart';

class DisOrderDetailsPage extends StatelessWidget {
  // ✅ 1. استقبال الـ ID فقط بدلاً من الـ Object كامل
  DisOrderDetailsPage({super.key, required this.requestId})
    : controller = Get.put(
        RequestItemController(requestId: requestId),
        tag: requestId,
      );

  final String requestId;
  final RequestItemController controller;

  // ✅ 2. دالة تحويل الـ Enum إلى نص عربي
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

  // ✅ 3. دالة مساعدة لتحويل نوع الطلب إلى نص عربي
  String _getRequestTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'normal':
        return 'عادي';
      case 'recurring':
        return 'متكرر';
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          // ✅ حذف الكونترولر باستخدام الـ ID
          Get.delete<RequestItemController>(tag: requestId);
        }
      },
      child: Scaffold(
        floatingActionButton: Obx(() {
          if (controller.isLoading.value) return const SizedBox.shrink();

          final d = controller.details.value;
          if (d == null) return const SizedBox.shrink();

          // ✅ الاعتماد على الحالة القادمة من الـ details
          final currentStatus = d.status;

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
            const CustomBackContainer(),
            const CustomHeadContainer(title: 'تفاصيل الطلب'),
            Expanded(
              // ✅ 4. تغليف المحتوى بـ Obx للتعامل مع حالة التحميل والبيانات
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CustomLoadingIndicator());
                }

                final d = controller.details.value;

                if (controller.hasError.value || d == null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomEmptyState(tital: 'تعذر تحميل تفاصيل الطلب'),
                      TextButton(
                        onPressed: controller.fetchDetails,
                        child: const Text(
                          'إعادة المحاولة',
                          style: TextStyle(color: constBlue),
                        ),
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
                          vertical: context.screenHeight * 0.01,
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
                              SizedBox(height: context.screenHeight * 0.01),

                              // ─── رقم الطلب ───────────────────────────────
                              _buildInfoRow(
                                context,
                                icon: Icons.confirmation_number_outlined,
                                label: 'رقم الطلب',
                                value: d.requestNumber,
                              ),
                              SizedBox(height: context.screenHeight * 0.01),
                              const Divider(
                                indent: 16,
                                endIndent: 16,
                                thickness: 0.5,
                              ),

                              // ─── القسم ───────────────────────────────
                              _buildInfoRow(
                                context,
                                icon: Icons.business_outlined,
                                label: 'القسم',
                                value: d.department?.name ?? '-',
                              ),
                              SizedBox(height: context.screenHeight * 0.01),
                              const Divider(
                                indent: 16,
                                endIndent: 16,
                                thickness: 0.5,
                              ),

                              // ─── النوع ───────────────────────────────
                              _buildInfoRow(
                                context,
                                icon: Icons.grid_view_outlined,
                                label: 'النوع',
                                value: _getRequestTypeLabel(d.requestType),
                              ),
                              SizedBox(height: context.screenHeight * 0.01),
                              const Divider(
                                indent: 16,
                                endIndent: 16,
                                thickness: 0.5,
                              ),

                              // ─── التاريخ ──────────────────────────────
                              _buildInfoRow(
                                context,
                                icon: Icons.date_range_outlined,
                                label: 'التاريخ',
                                value: d.formattedCreatedAt,
                              ),
                              SizedBox(height: context.screenHeight * 0.01),
                              const Divider(
                                indent: 16,
                                endIndent: 16,
                                thickness: 0.5,
                              ),

                              // ─── الأولوية ─────────────────────────────
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
                                        'الأولوية',
                                        style: _labelStyle(context),
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
                                          ? 'عاجل'
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
                              const Divider(
                                indent: 16,
                                endIndent: 16,
                                thickness: 0.5,
                              ),

                              // ─── الحالة ───────────────────────────────
                              Builder(
                                builder: (context) {
                                  final label = _statusLabel(d.status);
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
                                            style: _labelStyle(context),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              context.screenWidth * 0.04,
                                          vertical:
                                              context.screenHeight * 0.005,
                                        ),
                                        decoration: BoxDecoration(
                                          color: FindColor()
                                              .findBackgroundColor(word: label),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                },
                              ),

                              // ─── سبب الرفض (لو موجود) ─────────────────
                              if (d.isRejected &&
                                  d.activeRejectionReason != null) ...[
                                SizedBox(height: context.screenHeight * 0.01),
                                const Divider(
                                  indent: 16,
                                  endIndent: 16,
                                  thickness: 0.5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: context.screenHeight * 0.028,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: context.screenWidth * 0.02),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'سبب الرفض',
                                            style: _labelStyle(
                                              context,
                                            ).copyWith(color: Colors.red),
                                          ),
                                          SizedBox(
                                            height:
                                                context.screenHeight * 0.005,
                                          ),
                                          Text(
                                            d.activeRejectionReason!,
                                            style: TextStyle(
                                              fontFamily: cairo,
                                              fontSize:
                                                  context.screenHeight * 0.017,
                                              color: Colors.red.shade700,
                                            ),
                                          ),
                                        ],
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
                          horizontal: context.screenWidth * 0.02,
                          vertical: context.screenHeight * 0.02,
                        ),
                        child: d.items.isEmpty
                            ? const CustomEmptyState(
                                tital: 'لا توجد أصناف لهذا الطلب',
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: d.items.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: context.screenHeight * 0.01,
                                    ),
                                    child: VersionCustomRecurringDetailsCard(
                                      requestItemModel: d
                                          .items[index], // ✅ يمرر DetailRequestItem
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

  // ✅ دالة مساعدة لتنظيف الكود وتقليل التكرار
  Widget _buildInfoRow(
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
            Text(label, style: _labelStyle(context)),
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

  TextStyle _labelStyle(BuildContext context) {
    return TextStyle(
      color: constGray,
      fontFamily: cairo,
      fontSize: context.screenHeight * 0.019,
      fontWeight: FontWeight.w600,
    );
  }
}
