// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Get_Purchase_Receipts_Controller.dart';
import 'package:stock_mate_project/Controller/App/Purchase_Order_Details_Controller.dart';
import 'package:stock_mate_project/Controller/Service/Get_Name_Roll_Of_User.dart';
import 'package:stock_mate_project/Service/Head%20of%20Purchasing/Manager_Approve_Purchase_Request_Service.dart';
import 'package:stock_mate_project/Service/Head%20of%20Purchasing/Manager_Reject_Purchase_Request_Service.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Display_Purchase_Receipt_Details_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Purchase_Receipt_Card.dart';
import 'package:stock_mate_project/View/Widget/App/show_Create_Purchase_Receipt_Sheet.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/Function/Find_Color.dart';
import 'package:stock_mate_project/core/Function/show_Loading_Dialog.dart';
import 'package:stock_mate_project/core/models/Approve_Purchase_Item_Input.dart';
import 'package:stock_mate_project/core/models/Order_Item.dart'
    show OrderStatus, OrderPriority;
import 'package:stock_mate_project/core/models/Purchase_Request_Model.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/Custom_Dialog.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/DialogType.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/custom_Head_Card.dart';

class DisplayPurchasingOrderWithReciptsPage extends StatelessWidget {
  DisplayPurchasingOrderWithReciptsPage({super.key, required this.requestId})
    : controller = Get.put(
        PurchaseOrderDetailsController(requestId: requestId),
        tag: requestId,
      ),
      receiptsController = Get.put(
        GetPurchaseReceiptsController(purchaseRequestId: requestId),
        tag: requestId,
      );

  final GetNameRollOfUserController userController = Get.put(
    GetNameRollOfUserController(),
  );
  final RxBool _isManagerProcessing = false.obs;
  final String requestId;
  final PurchaseOrderDetailsController controller;
  final GetPurchaseReceiptsController receiptsController;

  String _statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.draft:
        return 'معلق';
      case OrderStatus.pending_hospital_approval:
        return 'بأنتظار مدير المستشفى';
      case OrderStatus.pending_manager_approval:
        return 'بأنتظار مدير اللجنة';
      case OrderStatus.preparing:
        return 'قيد التنفيذ';
      case OrderStatus.hospital_rejected:
        return 'مرفوض مدير المستشفى';

      case OrderStatus.manager_rejected:
        return 'مرفوض مدير اللجنة';

      case OrderStatus.cancelled:
        return 'مرفوض';
      case OrderStatus.partially_complete:
        return 'مكتمل جزئيا';
      case OrderStatus.complete:
        return 'منجز';
    }
  }

  Widget _buildApprovalCard(PurchaseRequestDetails d) {
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

  Future<void> _approveAsManager(BuildContext context) async {
    final d = controller.details.value;
    if (d == null) return;

    _isManagerProcessing.value = true;
    showLoadingDialog();

    final items = d.items
        .map(
          (item) => ApprovePurchaseItemInput(
            purchaseRequestItemId: item.id,
            approvedQuantity: item.requestedQuantity,
          ),
        )
        .toList();

    final success = await ManagerApprovePurchaseRequestService().approveRequest(
      purchaseRequestId: requestId,
      items: items,
    );

    hideLoadingDialog();
    _isManagerProcessing.value = false;

    if (success) {
      customSnackBar(
        title: 'تمت الموافقة',
        message: 'تمت الموافقة على الطلب بنجاح',
        color: constGreen,
        messageColor: constLightGreen,
      );
      await controller.fetchDetails();
    }
  }

  Future<void> _rejectAsManager(String reason) async {
    if (reason.isEmpty) {
      customSnackBar(
        title: 'خطأ',
        message: 'الرجاء إدخال سبب الرفض',
        color: constRed,
        messageColor: constLightRed,
      );
      return;
    }

    _isManagerProcessing.value = true;
    showLoadingDialog();

    final success = await ManagerRejectPurchaseRequestService().rejectRequest(
      purchaseRequestId: requestId,
      reason: reason,
    );

    hideLoadingDialog();
    _isManagerProcessing.value = false;

    if (success) {
      customSnackBar(
        title: 'تم الرفض',
        message: 'تم رفض الطلب بنجاح',
        color: constGreen,
        messageColor: constLightGreen,
      );
      await controller.fetchDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Get.delete<PurchaseOrderDetailsController>(tag: requestId);
          Get.delete<GetPurchaseReceiptsController>(tag: requestId);
        }
      },
      child: Scaffold(
        backgroundColor: constBackgroundColor,
        // ─────────────────────────────────────────────────────────
        // ⚠️ الـ FloatingActionButton: نفس المنطق حرفياً بدون أي تعديل
        // ─────────────────────────────────────────────────────────
        floatingActionButton: Obx(() {
          if (controller.isLoading.value || userController.role.value == null) {
            return const SizedBox.shrink();
          }

          final currentStatus = controller.details.value?.status;
          final String? currentRole = userController.role.value;

          // ═══════════════ purchasing_manager + preparing ═══════════════
          if (currentRole == 'purchasing_manager' &&
              currentStatus == OrderStatus.preparing) {
            final d = controller.details.value;
            if (d == null || d.items.isEmpty) return const SizedBox.shrink();

            return SizedBox(
              width: w * 0.15,
              height: h * 0.1,
              child: FloatingActionButton(
                backgroundColor: constBlue,
                elevation: 8,
                shape: const CircleBorder(),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => CreatePurchaseReceiptBottomSheet(
                      purchaseRequestId: requestId,
                      items: d.items,
                      onSuccess: () {
                        controller.fetchDetails();
                        receiptsController.refreshReceipts();
                      },
                    ),
                  );
                },
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: Colors.white,
                ),
              ),
            );
          }

          // ═══════════════ purchasing_manager (الموافقة والرفض) ═══════════════
          if (currentRole == 'purchasing_manager') {
            if (controller.isApproved.value ||
                controller.isRejected.value ||
                currentStatus != OrderStatus.pending_manager_approval) {
              return const SizedBox.shrink();
            }

            return SizedBox(
              width: w * 0.15,
              height: h * 0.1,
              child: FloatingActionButton(
                backgroundColor: constBlue,
                elevation: 8,
                shape: const CircleBorder(),
                onPressed: _isManagerProcessing.value
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
                            _approveAsManager(context);
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
                                _rejectAsManager(reasonController.text.trim());
                              },
                            );
                          },
                        );
                      },
                child: _isManagerProcessing.value
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
          }

          // ═══════════════ hospital_manager (السلوك الأصلي) ═══════════════
          if (controller.isApproved.value ||
              controller.isRejected.value ||
              currentStatus != OrderStatus.pending_hospital_approval) {
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
            const CustomHeadContainer(title: 'تفاصيل طلب الشراء'),
            SizedBox(height: h * 0.015),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CustomLoadingIndicator());
                }

                final PurchaseRequestDetails? d = controller.details.value;

                if (controller.hasError.value || d == null) {
                  return _buildErrorState();
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
                      // ─── كارد المعلومات الأساسية ─────────────────
                      _card(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (d.requestedBy != null)
                                        Text(
                                          d.requestedBy!.fullName,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'Cairo',
                                            color: constColor,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                _statusBadge(_statusLabel(d.status)),
                              ],
                            ),
                            SizedBox(height: h * 0.012),
                            _priorityBadge(d.priority),
                            SizedBox(height: h * 0.014),
                            const Divider(height: 1),
                            SizedBox(height: h * 0.012),
                            _infoRow(
                              icon: Icons.date_range_outlined,
                              label: 'التاريخ',
                              value: d.formattedCreatedAt,
                            ),
                            if (d.notes != null && d.notes!.isNotEmpty)
                              _infoRow(
                                icon: Icons.edit_note_outlined,
                                label: 'الملاحظات',
                                value: d.notes!,
                              ),
                          ],
                        ),
                      ),
                      if (d.activeApprovedAt != null) _buildApprovalCard(d),
                      // ─── كارد سبب الرفض (شرطي) ────────────────────
                      if (d.isRejected && d.activeRejectionReason != null)
                        _buildRejectionCard(d.activeRejectionReason!),

                      // ─── كارد الأصناف ─────────────────────────────
                      _card(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.medication_outlined,
                                  color: constBlue,
                                  size: 22,
                                ),
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
                                ? const CustomEmptyState(
                                    tital: 'لا توجد أصناف لهذا الطلب',
                                  )
                                : Column(
                                    children: d.items
                                        .map((item) => _buildItemTile(item))
                                        .toList(),
                                  ),
                          ],
                        ),
                      ),

                      // ─── سجل إيصالات الاستلام ─────────────────────
                      _card(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.receipt_long_outlined,
                                  color: constBlue,
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'سجل إيصالات الاستلام',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'Cairo',
                                    color: constColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(height: 1),
                            const SizedBox(height: 12),
                            Obx(() {
                              if (receiptsController.isLoading.value) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: CustomLoadingIndicator(),
                                  ),
                                );
                              }

                              if (receiptsController.receipts.isEmpty) {
                                return const CustomEmptyState(
                                  tital: 'لا توجد إيصالات استلام لهذا الطلب',
                                );
                              }

                              return Column(
                                children: receiptsController.receipts
                                    .map(
                                      (receipt) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: CustomPurchaseReceiptCard(
                                          receipt: receipt,
                                          onTap: () {
                                            Get.to(
                                              () =>
                                                  DisplayPurchaseReceiptDetailsPage(
                                                    receiptId: receipt.id,
                                                  ),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                    .toList(),
                              );
                            }),
                          ],
                        ),
                      ),

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

  // ─── شارة الحالة (نفس ألوان FindColor الأصلية) ─────────────────────
  Widget _statusBadge(String label) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: FindColor().findBackgroundColor(word: label),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: FindColor().findFontColorFunction(word: label),
        ),
      ),
    );
  }

  // ─── شارة الأولوية ──────────────────────────────────────────────────
  Widget _priorityBadge(OrderPriority priority) {
    final isUrgent = priority == OrderPriority.urgent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isUrgent ? const Color(0xFFFDE8E8) : const Color(0xFFE8F0FE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bolt_outlined,
            size: 15,
            color: isUrgent ? Colors.red : Colors.blue,
          ),
          const SizedBox(width: 4),
          Text(
            isUrgent ? 'ضروري' : 'عادي',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isUrgent ? Colors.red : Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  // ─── صف معلومة (أيقونة + عنوان + قيمة) ──────────────────────────────
  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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

  // ─── صندوق سبب الرفض المميز ──────────────────────────────────────
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

  // ─── كارد صنف واحد (نفس تصميم RequestDetailsPage._buildItemTile) ──
  Widget _buildItemTile(PurchaseDetailItem item) {
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
              if (item.receivedQuantity > 0) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: _quantityBox(
                    'المستلمة',
                    item.receivedQuantity,
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

  // ─── حالة الخطأ ───────────────────────────────────────────────────
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off_outlined, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text(
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
