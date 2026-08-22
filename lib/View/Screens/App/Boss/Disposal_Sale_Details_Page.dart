// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Get_Disposal_Sale_Details_Controller.dart';
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
    final h = context.screenHeight;
    final w = context.screenWidth;

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
        // ─────────────────────────────────────────────────────────
        // ⚠️ الـ FloatingActionButton: بدون أي تعديل — نفس المنطق حرفياً
        // ─────────────────────────────────────────────────────────
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
        backgroundColor: constBackgroundColor,
        body: Column(
          children: [
            const CustomBackContainer(),
            const CustomHeadContainer(title: 'تفاصيل طلب بيع الإتلاف'),
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
                      // vertical: h * 0.01,
                    ),
                    children: [
                      _buildHeaderCard(d),
                      // ─── سبب الرفض (لو موجود) ✅ Obx مستقلة ────
                      Obx(() {
                        final currentDetails = controller.details.value;
                        if (currentDetails == null ||
                            !currentDetails.isRejected ||
                            currentDetails.rejectionReason == null) {
                          return const SizedBox.shrink();
                        }
                        return _buildRejectionCard(
                          currentDetails.rejectionReason!,
                        );
                      }),
                      _buildItemsCard(d),
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
  Widget _buildHeaderCard(dynamic d) {
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
                    Text(
                      d.destination?.name ?? '—',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Cairo',
                        color: constColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'مقدم الطلب: ${d.requestedBy?.fullName ?? '—'}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF4B5563),
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
              // ─── شارة الحالة ✅ Obx مستقلة عشان تتحدث فورًا ───
              Obx(() {
                final currentDetails = controller.details.value;
                final label = currentDetails?.statusLabel ?? d.statusLabel;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: constLightBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Cairo',
                      color: constBlue,
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),
          _infoRow(Icons.event_outlined, 'تاريخ الإنشاء', d.formattedCreatedAt),
          _infoRow(
            Icons.attach_money_outlined,
            'إجمالي المبلغ',
            d.totalAmount.toStringAsFixed(2),
          ),
        ],
      ),
    );
  }

  // ─── كارد سبب الرفض (أحمر) — نفس تصميم DisOrderDetailsPage ────────
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

  // ─── كارد الأصناف (نفس شكل DisOrderDetailsPage._buildItemsCard) ───
  Widget _buildItemsCard(dynamic d) {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                color: constBlue,
                size: 22,
              ),
              const SizedBox(width: 8),
              const Text(
                'أصناف الإتلاف',
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
                  children: (d.items as List)
                      .map((item) => _buildItemTile(item))
                      .toList(),
                ),
        ],
      ),
    );
  }

  // ─── كارد صنف واحد (نفس تصميم DisOrderDetailsPage._buildItemTile) ─
  Widget _buildItemTile(dynamic item) {
    final productName = item.variant?.variantName ?? '—';
    final batchNumber = item.batch?.batchNumber;

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
                  Icons.inventory_2_outlined,
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
                    if (batchNumber != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'الدفعة: $batchNumber',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── صناديق الكمية / السعر / الإجمالي ──
          Row(
            children: [
              Expanded(
                child: _valueBox('الكمية', '${item.quantity}', constBlue),
              ),
              const SizedBox(width: 8),
              Expanded(child: _valueBox('السعر', '${item.price}', constOrange)),
              const SizedBox(width: 8),
              Expanded(
                child: _valueBox(
                  'الإجمالي',
                  item.subtotal.toStringAsFixed(2),
                  constGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── صندوق قيمة واحد (نفس _quantityBox) ────────────────────────────
  Widget _valueBox(String label, String value, Color color) {
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
              value,
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
