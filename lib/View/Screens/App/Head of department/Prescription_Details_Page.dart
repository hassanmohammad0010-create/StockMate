// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Service/Prescription_Details_Controller.dart';
import 'package:stock_mate_project/core/models/Dispense_Queue_Item.dart';
import 'package:stock_mate_project/core/models/Prescription_Details_Model.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/Custom_Dialog.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/DialogType.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Text_Field/Custom_My_TextFormFaild.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';

class PrescriptionDetailsPage extends StatelessWidget {
  const PrescriptionDetailsPage({super.key, required this.queueItem});

  final DispenseQueueItem queueItem;

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    final c = Get.put(
      PrescriptionDetailsController(queueItem: queueItem),
      tag: queueItem.id,
    );

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          const CustomBackContainer(),

          // ── الهيدر ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.04),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    queueItem.patientName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: constColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _StatusBadge(status: queueItem.status),
              ],
            ),
          ),
          SizedBox(height: h * 0.015),

          Expanded(
            child: Obx(() {
              if (c.isLoading.value && c.details.value == null) {
                return const Center(child: CircularProgressIndicator());
              }

              if (c.errorMessage.value.isNotEmpty && c.details.value == null) {
                return _buildErrorState(c);
              }

              final d = c.details.value;
              if (d == null) return _buildErrorState(c);

              return ListView(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                children: [
                  _InfoCard(
                    title: 'معلومات المريض والزيارة',
                    icon: Icons.person_outline,
                    color: constBlue,
                    children: [
                      _InfoRow(
                        icon: Icons.badge_outlined,
                        label: 'المريض',
                        value: d.patient?.fullName ?? queueItem.patientName,
                      ),
                      _InfoRow(
                        icon: Icons.sick_outlined,
                        label: 'الطبيب',
                        value: d.doctor?.fullName ?? '—',
                      ),
                      _InfoRow(
                        icon: Icons.local_hospital_outlined,
                        label: 'القسم',
                        value: d.visit?.department?.name ?? '—',
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.015),

                  _InfoCard(
                    title: 'تفاصيل الوصفة',
                    icon: Icons.receipt_long_outlined,
                    color: constOrange,
                    children: [
                      _InfoRow(
                        icon: Icons.loop_outlined,
                        label: 'التكرار',
                        value:
                            'كل ${d.frequencyInterval} ${d.frequencyUnitLabel}',
                      ),
                      _InfoRow(
                        icon: Icons.refresh_outlined,
                        label: 'الدورة',
                        value: '${d.currentCycleNumber} من ${d.totalCycles}',
                      ),
                      _InfoRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'تاريخ البدء',
                        value: d.formattedStartDate,
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.015),

                  _MedicinesCard(controller: c, details: d),
                  SizedBox(height: h * 0.015),

                  // ── حقل الملاحظات الاختياري ──
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CustomMyTextFormField(
                      prefixIcon: Icons.edit_note_outlined,
                      label: 'ملاحظات (اختياري)',
                      hint: 'أضف أي ملاحظات حول عملية الصرف',
                      controller: c.notesController,
                    ),
                  ),
                  SizedBox(height: h * 0.015),

                  _DispenseSummary(controller: c),
                  SizedBox(height: h * 0.02),

                  _ConfirmDispenseButton(controller: c),

                  // ─── ✅✅✅ زر إلغاء الوصفة ───
                  if (queueItem.status.canDispense) ...[
                    SizedBox(height: h * 0.012),
                    _CancelPrescriptionButton(
                      controller: c,
                      onPressed: () => _showCancelDialog(c),
                    ),
                  ],

                  SizedBox(height: h * 0.03),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // ─── ✅✅✅ ديالوغ إلغاء الوصفة (السبب اجباري) ─────────────────────
  void _showCancelDialog(PrescriptionDetailsController c) {
    c.cancelReasonController.clear();

    CustomDialog.show(
      title: 'إلغاء الوصفة',
      message:
          'هل أنت متأكد من رغبتك في إلغاء هذه الوصفة؟\nيجب إدخال سبب الإلغاء.',
      type: DialogType.danger,
      showTextField: true,
      textFieldHint: 'ادخل سبب الإلغاء (اجباري)',
      textFieldKeyboard: TextInputType.text,
      textFieldController: c.cancelReasonController,
      textFieldValidator: (value) {
        // ✅✅✅ السبب اجباري
        if (value == null || value.trim().isEmpty) {
          return 'يرجى إدخال سبب الإلغاء';
        }
        if (value.trim().length < 3) {
          return 'السبب قصير جداً';
        }
        return null;
      },
      onConfirm: () {
        final reason = c.cancelReasonController.text.trim();
        Get.back(); // إغلاق الديالوغ
        c.cancelPrescription(reason); // تنفيذ الإلغاء
      },
    );
  }

  Widget _buildErrorState(PrescriptionDetailsController c) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off_outlined, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            c.errorMessage.value,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Cairo',
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: c.fetchDetails,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('إعادة المحاولة'),
            style: TextButton.styleFrom(foregroundColor: constBlue),
          ),
        ],
      ),
    );
  }
}

// ─── شارة الحالة ────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final CycleStatus status;

  const _StatusBadge({required this.status});

  Color get _color {
    switch (status) {
      case CycleStatus.ready:
        return constGreen;
      case CycleStatus.partially_delivered:
        return constOrange;
      case CycleStatus.delivered:
        return constBlue;
      case CycleStatus.missed:
        return constRed;
      case CycleStatus.cancelled:
        return constGray;
    }
  }

  Color get _bg {
    switch (status) {
      case CycleStatus.ready:
        return constLightGreen;
      case CycleStatus.partially_delivered:
        return constLightOrange;
      case CycleStatus.delivered:
        return constLightBlue;
      case CycleStatus.missed:
        return constLightRed;
      case CycleStatus.cancelled:
        return const Color(0xFFF3F4F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: _color,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }
}

// ─── بطاقة معلومات ──────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          SizedBox(
            width: 90,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: constColor,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── بطاقة الأدوية مع stepper ──────────────────────────────────────
class _MedicinesCard extends StatelessWidget {
  final PrescriptionDetailsController controller;
  final PrescriptionDetails details;

  const _MedicinesCard({required this.controller, required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: constGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.medication_outlined,
                  size: 18,
                  color: constGreen,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'الأدوية والكميات',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: constGreen,
                  fontFamily: 'Cairo',
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${details.items.length}',
                  style: const TextStyle(
                    color: constColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...details.items.map(
            (item) => _MedicineStepperTile(item: item, controller: controller),
          ),
        ],
      ),
    );
  }
}

// ─── بلاطة دواء مع stepper ─────────────────────────────────────────
class _MedicineStepperTile extends StatelessWidget {
  final PrescriptionItem item;
  final PrescriptionDetailsController controller;

  const _MedicineStepperTile({required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    final remaining = controller.remainingFor(item);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.medication_liquid, size: 16, color: constBlue),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.displayName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: constColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              if (item.dosage.isNotEmpty) ...[
                _chip('💊 ${item.dosage}'),
                const SizedBox(width: 6),
              ],
              _chip('⏰ ${item.frequency}'),
              const SizedBox(width: 6),
              _chip('📅 ${item.durationDays} يوم'),
            ],
          ),
          const SizedBox(height: 10),

          // ── الثلاثة أرقام ──
          Row(
            children: [
              _miniInfo('المطلوبة', item.prescribedQuantity, constColor),
              const SizedBox(width: 8),
              _miniInfo('صُرف سابقاً', item.dispensedQuantity, constBlue),
              const SizedBox(width: 8),
              _miniInfo('المتبقي', remaining, constOrange),
            ],
          ),
          const SizedBox(height: 12),

          // ── stepper ──
          if (remaining == 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: constLightBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  '✅ تم صرف هذا الدواء بالكامل سابقاً',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: constBlue,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            )
          else
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'سيُصرف الآن',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cairo',
                      color: Colors.grey,
                    ),
                  ),
                ),
                Obx(() {
                  final chosen = controller.quantityFor(item);
                  final isFull = chosen >= remaining;
                  return _StepperField(
                    value: chosen,
                    min: 0,
                    max: remaining,
                    accentColor: isFull ? constGreen : constOrange,
                    onChanged: (v) => controller.updateQuantity(item.id, v),
                  );
                }),
              ],
            ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: Colors.grey.shade700,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }

  Widget _miniInfo(String label, int value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Text(
              '$value',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: color,
                fontFamily: 'Cairo',
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey.shade600,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── stepper (+/-) ─────────────────────────────────────────────────
class _StepperField extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final Color accentColor;
  final ValueChanged<int> onChanged;

  const _StepperField({
    required this.value,
    required this.onChanged,
    this.min = 0,
    required this.max,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final canDec = value - 1 >= min;
    final canInc = value + 1 <= max;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: accentColor.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(Icons.remove, canDec, () => onChanged(value - 1)),
          SizedBox(
            width: 36,
            child: Center(
              child: Text(
                '$value',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: accentColor,
                ),
              ),
            ),
          ),
          _btn(Icons.add, canInc, () => onChanged(value + 1)),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, bool enabled, VoidCallback? onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        customBorder: const CircleBorder(),
        child: Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 17,
            color: enabled ? accentColor : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}

// ─── ملخص الصرف ────────────────────────────────────────────────────
class _DispenseSummary extends StatelessWidget {
  final PrescriptionDetailsController controller;

  const _DispenseSummary({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final status = controller.computeFinalStatus();
      final color = status == CycleStatus.delivered ? constGreen : constOrange;

      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            Icon(
              status == CycleStatus.delivered
                  ? Icons.check_circle_outline
                  : Icons.inventory_2_outlined,
              color: color,
              size: 24,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'سيتم الصرف كـ: ${status.label}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'سيُصرف الآن: ${controller.summaryText} (من المتبقي)',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Cairo',
                      color: color.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ─── زر تأكيد الصرف ────────────────────────────────────────────────
class _ConfirmDispenseButton extends StatelessWidget {
  final PrescriptionDetailsController controller;

  const _ConfirmDispenseButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final confirming = controller.isConfirming.value;
      final enabled = controller.hasAnyDispensed && !confirming;

      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: enabled ? controller.confirmDispense : null,
          icon: confirming
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.check_circle_outline, size: 20),
          label: Text(
            confirming ? 'جارٍ الصرف...' : 'تأكيد الصرف',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: constGreen,
            disabledBackgroundColor: Colors.grey.shade300,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    });
  }
}

// ─── ✅✅✅ زر إلغاء الوصفة ─────────────────────────────────────────
class _CancelPrescriptionButton extends StatelessWidget {
  final PrescriptionDetailsController controller;
  final VoidCallback onPressed;

  const _CancelPrescriptionButton({
    required this.controller,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final cancelling = controller.isCancelling.value;

      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: cancelling ? null : onPressed,
          icon: cancelling
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: constRed,
                  ),
                )
              : const Icon(Icons.cancel_outlined, size: 20),
          label: Text(
            cancelling ? 'جارٍ الإلغاء...' : 'إلغاء الوصفة',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              color: constRed,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: constRed),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    });
  }
}
