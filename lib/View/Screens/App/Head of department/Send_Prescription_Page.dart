// ignore_for_file: file_names, deprecated_member_use, unused_element_parameter

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Service/Send_Prescription_Controller.dart';
import 'package:stock_mate_project/core/models/Prescription_Model.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Drop_Down/Custom_My_Drop_Down.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';

class SendPrescriptionPage extends StatelessWidget {
  const SendPrescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;
    final c = Get.find<SendPrescriptionController>();

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          const CustomBackContainer(),

          // ── رأس الصفحة ──
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: w * 0.04, vertical: h * 0.01),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'الوصفات الطبية',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: constColor,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: c.addPrescription,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text(
                    'وصفة جديدة',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: constBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── قائمة الوصفات ──
          Expanded(
            child: Obx(() {
              if (c.prescriptions.isEmpty) {
                return _buildEmptyState();
              }
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                itemCount: c.prescriptions.length,
                itemBuilder: (_, i) => _PrescriptionCard(
                  prescription: c.prescriptions[i],
                  controller: c,
                  index: i + 1,
                ),
              );
            }),
          ),

          // ✅ زر التأكيد الثابت
          _ConfirmButton(w: w),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 70, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          const Text(
            'لا توجد وصفات بعد',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Cairo',
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'اضغط "وصفة جديدة" لإضافة وصفة',
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Cairo',
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── كارد وصفة واحدة ──────────────────────────────────────────────
class _PrescriptionCard extends StatelessWidget {
  final Prescription prescription;
  final SendPrescriptionController controller;
  final int index;

  const _PrescriptionCard({
    required this.prescription,
    required this.controller,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          // ── 1) رأس الوصفة ──
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: constBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.receipt_long,
                    color: constBlue, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                'وصفة #$index',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: constColor,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () =>
                    controller.removePrescription(prescription.localId),
                icon: const Icon(Icons.delete_outline,
                    color: constRed, size: 20),
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── 2) Dropdown الوحدة (أولاً) ──
          const Text(
            'وحدة التكرار',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Cairo',
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          CustomDropdown<String>(
            items: const ['day', 'week', 'month'],
            labelBuilder: (v) {
              switch (v) {
                case 'day':
                  return 'يوم';
                case 'week':
                  return 'أسبوع';
                case 'month':
                  return 'شهر';
                default:
                  return v;
              }
            },
            label: 'الوحدة',
            hint: 'اختر',
            icon: Icons.calendar_today_outlined,
            searchable: false,
            value: prescription.frequencyUnit,
            onChanged: (v) {
              if (v != null) {
                controller.updatePrescription(
                  prescription.localId,
                  prescription.copyWith(frequencyUnit: v),
                );
              }
            },
          ),

          const SizedBox(height: 12),

          // ── 3) الحقلان (كل X + دورات) جنباً إلى جنب مع +/- ──
          Row(
            children: [
              Expanded(
                child: _StepperField(
                  label: 'كل',
                  value: prescription.frequencyInterval,
                  min: 1,
                  onChanged: (v) => controller.updatePrescription(
                    prescription.localId,
                    prescription.copyWith(frequencyInterval: v),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StepperField(
                  label: 'دورات',
                  value: prescription.totalCycles,
                  min: 1,
                  onChanged: (v) => controller.updatePrescription(
                    prescription.localId,
                    prescription.copyWith(totalCycles: v),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // ── 4) عنوان الأدوية + زر إضافة ──
          Row(
            children: [
              const Icon(Icons.medication, size: 16, color: constBlue),
              const SizedBox(width: 6),
              const Text(
                'الأدوية',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: constColor,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _showAddMedicineDialog(context),
                icon: const Icon(Icons.add, size: 16),
                label: const Text(
                  'إضافة',
                  style: TextStyle(fontSize: 12, fontFamily: 'Cairo'),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: constBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ],
          ),

          // ── 5) قائمة الأدوية ──
          if (prescription.items.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Center(
                child: Text(
                  'لا توجد أدوية — اضغط "إضافة"',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            )
          else
            ...prescription.items.map(
              (item) => _MedicineTile(
                item: item,
                prescriptionId: prescription.localId,
                controller: controller,
              ),
            ),
        ],
      ),
    );
  }

  // ─── Dialog اختيار الدواء ─────────────────────────────────────────
  void _showAddMedicineDialog(BuildContext context) {
    final selectedName = Rxn<String>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text(
          'إضافة دواء',
          style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Obx(() => CustomDropdown<String>(
                items: controller.variantNames,
                isLoading: controller.isLoadingVariants.value,
                hasError: false,
                onRetry: controller.fetchVariants,
                labelBuilder: (v) => v,
                label: 'الدواء',
                hint: 'اختر الدواء المطلوب',
                icon: Icons.medication_outlined,
                searchable: true,
                value: selectedName.value,
                validator: (v) => v == null ? 'الرجاء اختيار دواء' : null,
                onChanged: (v) => selectedName.value = v,
              )),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Cairo')),
          ),
          ElevatedButton(
            onPressed: () {
              final name = selectedName.value;
              if (name != null && name.isNotEmpty) {
                controller.addMedicineToPrescription(
                  prescriptionId: prescription.localId,
                  variantName: name,
                );
                Navigator.of(ctx).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: constBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('إضافة', style: TextStyle(fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }
}

// ─── بلاطة دواء مع +/- ─────────────────────────────────────────────
class _MedicineTile extends StatelessWidget {
  final PrescriptionItem item;
  final String prescriptionId;
  final SendPrescriptionController controller;

  const _MedicineTile({
    required this.item,
    required this.prescriptionId,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── اسم الدواء + زر حذف ──
          Row(
            children: [
              const Icon(Icons.medication_liquid,
                  size: 16, color: constBlue),
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
              IconButton(
                onPressed: () => controller.removeMedicineFromPrescription(
                  prescriptionId: prescriptionId,
                  itemLocalId: item.localId,
                ),
                icon: const Icon(Icons.close, size: 16, color: constRed),
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints(minWidth: 24, minHeight: 24),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── الكمية + المدة مع +/- ──
          Row(
            children: [
              Expanded(
                child: _StepperField(
                  label: 'الكمية',
                  value: item.prescribedQuantity,
                  min: 1,
                  onChanged: (v) => controller.updateMedicineInPrescription(
                    prescriptionId: prescriptionId,
                    itemLocalId: item.localId,
                    prescribedQuantity: v,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StepperField(
                  label: 'المدة (أيام)',
                  value: item.durationDays,
                  min: 1,
                  onChanged: (v) => controller.updateMedicineInPrescription(
                    prescriptionId: prescriptionId,
                    itemLocalId: item.localId,
                    durationDays: v,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── ✅ ويدجت Stepper (+/-) قابل لإعادة الاستخدام ──────────────────
class _StepperField extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int step;
  final ValueChanged<int> onChanged;

  const _StepperField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.step = 1,
  });

  @override
  Widget build(BuildContext context) {
    final canDecrease = value - step >= min;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              // زر الإنقاص
              _StepperButton(
                icon: Icons.remove,
                enabled: canDecrease,
                onTap: canDecrease ? () => onChanged(value - step) : null,
              ),
              // القيمة في المنتصف
              Expanded(
                child: Center(
                  child: Text(
                    '$value',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: constColor,
                    ),
                  ),
                ),
              ),
              // زر الزيادة
              _StepperButton(
                icon: Icons.add,
                enabled: true,
                onTap: () => onChanged(value + step),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── زر +/- داخل Stepper ───────────────────────────────────────────
class _StepperButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  const _StepperButton({
    required this.icon,
    required this.enabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 18,
            color: enabled ? constBlue : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}

// ─── زر التأكيد ────────────────────────────────────────────────────
class _ConfirmButton extends StatelessWidget {
  final double w;

  const _ConfirmButton({required this.w});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.check_circle_outline, size: 20),
          label: const Text(
            'تأكيد',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: constGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}