// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Get_Request_Items_Controller.dart';
import 'package:stock_mate_project/core/models/Order_Item.dart';
import 'package:stock_mate_project/core/models/Order_Item_Details.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/Custom_Dialog.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/DialogType.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/PriorityBadge.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/RecurringBadge.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/StatusBadge.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/custom_Head_Card.dart';

class DisOrderDetailsPage extends StatelessWidget {
  DisOrderDetailsPage({super.key, required this.requestId})
    : controller = Get.put(
        RequestItemController(requestId: requestId),
        tag: requestId,
      );

  final String requestId;
  final RequestItemController controller;

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Get.delete<RequestItemController>(tag: requestId);
        }
      },
      child: Scaffold(
        backgroundColor: constBackgroundColor,
        // ─────────────────────────────────────────────────────────
        // ⚠️ الـ FloatingActionButton: نفس المنطق حرفياً بدون أي تعديل
        // ─────────────────────────────────────────────────────────
        floatingActionButton: Obx(() {
          if (controller.isLoading.value) return const SizedBox.shrink();

          final d = controller.details.value;
          if (d == null) return const SizedBox.shrink();

          if (controller.isApproved.value ||
              controller.isRejected.value ||
              d.status != OrderStatus.pending_hospital_approval) {
            return const SizedBox.shrink();
          }

          return SizedBox(
            width: w * 0.15,
            height: h * 0.1,
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
            SizedBox(height: h * 0.015),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CustomLoadingIndicator());
                }

                final d = controller.details.value;

                if (controller.hasError.value || d == null) {
                  return _buildErrorState(context);
                }

                return RefreshIndicator(
                  color: constBlue,
                  onRefresh: () => controller.fetchDetails(),
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.04,
                      vertical: h * 0.01,
                    ),
                    children: [
                      _buildHeaderCard(d),
                      if (d.isRejected && d.activeRejectionReason != null)
                        _buildRejectionCard(d.activeRejectionReason!),
                      if (d.activeApprovedAt != null) _buildApprovalCard(d),
                      _buildItemsCard(d),
                      if (d.notes != null && d.notes!.trim().isNotEmpty)
                        _buildNotesCard(d.notes!),
                      SizedBox(height: h * 0.02),
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

  // ─── كارد معلومات الطلب الأساسية ────────────────────────────────
  Widget _buildHeaderCard(OrderItemDetails d) {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        d.requestNumber,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Cairo',
                          color: constColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'القسم: ${d.department?.name ?? '—'}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF4B5563),
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(status: d.status),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              PriorityBadge(priority: d.priority),
              const SizedBox(width: 8),
              if (d.isRecurring && d.recurringInterval != null)
                RecurringBadge(interval: d.recurringInterval!),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),
          _infoRow(Icons.event_outlined, 'تاريخ الإنشاء', d.formattedCreatedAt),
          if (d.isRecurring && d.frequencyInterval != null)
            _infoRow(
              Icons.repeat_outlined,
              'عدد التكرارات',
              '${d.frequencyInterval} مرة',
            ),
          if (d.requestedBy != null)
            _infoRow(
              Icons.person_outline,
              'مقدم الطلب',
              d.requestedBy!.fullName,
            ),
        ],
      ),
    );
  }

  // ─── كارد سبب الرفض (أحمر) ────────────────────────────────────────
  Widget _buildRejectionCard(String reason) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: constLightRed,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: constRed.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: constRed, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'سبب الرفض',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Cairo',
                    color: constRed,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reason,
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'Cairo',
                    color: Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── كارد الموافقة (أخضر) ──────────────────────────────────────────
  Widget _buildApprovalCard(OrderItemDetails d) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: constLightGreen,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: constGreen.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: constGreen, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'تمت الموافقة على الطلب بتاريخ: ${d.formattedApprovedAt}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
                color: constGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── كارد الأصناف (نفس شكل RequestDetailsPage تمامًا) ✅ الجزء الأهم
  Widget _buildItemsCard(OrderItemDetails d) {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.medication_outlined, color: constBlue, size: 22),
              const SizedBox(width: 8),
              const Text(
                'الأصناف المطلوبة',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Cairo',
                  color: constColor,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: constBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${d.items.length}',
                  style: const TextStyle(
                    color: constBlue,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          d.items.isEmpty
              ? const CustomEmptyState(tital: 'لا توجد أصناف لهذا الطلب')
              : Column(
                  children: d.items
                      .map((item) => _buildItemTile(item))
                      .toList(),
                ),
        ],
      ),
    );
  }

  // ─── كارد صنف واحد (نفس تصميم RequestDetailsPage._buildItemTile) ──
  Widget _buildItemTile(DetailRequestItem item) {
    final unit = item.variant?.unit?.abbreviation ?? '';
    final productName =
        item.variant?.product?.name ?? item.variant?.variantName ?? '—';
    final category = item.variant?.product?.category?.name;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: constBlue.withOpacity(0.1),
                child: const Icon(
                  Icons.medication_outlined,
                  color: constBlue,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        color: constColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (category != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade700,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Expanded(
                          child: Text(
                            item.variant?.variantName ?? '',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                              fontFamily: 'Cairo',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── صناديق الكميات ──
          Row(
            children: [
              Expanded(
                child: _quantityBox(
                  'المطلوبة',
                  item.requestedQuantity,
                  unit,
                  constBlue,
                ),
              ),
              if (item.approvedQuantity != null) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: _quantityBox(
                    'الموافق عليها',
                    item.approvedQuantity!,
                    unit,
                    constGreen,
                  ),
                ),
              ],
              if (item.deliveredQuantity != null) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: _quantityBox(
                    'المسلّمة',
                    item.deliveredQuantity!,
                    unit,
                    constOrange,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // ─── صندوق كمية واحد ──────────────────────────────────────────────
  Widget _quantityBox(String label, int value, String unit, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              unit.isEmpty ? '$value' : '$value $unit',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                fontFamily: 'Cairo',
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  // ─── كارد الملاحظات ─────────────────────────────────────────────────
  Widget _buildNotesCard(String notes) {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.edit_note_outlined, color: constGray, size: 22),
              const SizedBox(width: 8),
              const Text(
                'الملاحظات',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Cairo',
                  color: constColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            notes,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: 'Cairo',
              color: Color(0xFF4B5563),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ─── حالة الخطأ ───────────────────────────────────────────────────
  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off_outlined, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'تعذر تحميل تفاصيل الطلب',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Cairo',
              color: constGray,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: controller.fetchDetails,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('إعادة المحاولة'),
            style: TextButton.styleFrom(foregroundColor: constBlue),
          ),
        ],
      ),
    );
  }

  // ─── صف معلومة ───────────────────────────────────────────────────
  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 13,
                color: constColor,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── غلاف كارد أبيض ───────────────────────────────────────────────
  Widget _card(Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
