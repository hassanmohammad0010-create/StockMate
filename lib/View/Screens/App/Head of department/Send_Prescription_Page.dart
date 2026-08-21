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
              horizontal: w * 0.04,
              vertical: h * 0.01,
            ),
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
          Icon(
            Icons.receipt_long_outlined,
            size: 70,
            color: Colors.grey.shade300,
          ),
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
                child: const Icon(
                  Icons.receipt_long,
                  color: constBlue,
                  size: 18,
                ),
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
                icon: const Icon(
                  Icons.delete_outline,
                  color: constRed,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
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
          child: Obx(
            () => CustomDropdown<String>(
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
            ),
          ),
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
              IconButton(
                onPressed: () => controller.removeMedicineFromPrescription(
                  prescriptionId: prescriptionId,
                  itemLocalId: item.localId,
                ),
                icon: const Icon(Icons.close, size: 16, color: constRed),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
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

  const _StepperButton({required this.icon, required this.enabled, this.onTap});

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

// // ignore_for_file: file_names, deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:stock_mate_project/Constant/Const.dart';
// import 'package:stock_mate_project/Controller/Service/Send_Prescription_Controller.dart';
// import 'package:stock_mate_project/core/models/Prescription_Model.dart';
// import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Drop_Down/Custom_My_Drop_Down.dart';

// class SendPrescriptionPage extends StatelessWidget {
//   const SendPrescriptionPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final h = context.screenHeight;
//     final w = context.screenWidth;
//     final c = Get.find<SendPrescriptionController>();

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F6F8), // ✅ خلفية رمادية فاتحة عصرية
//       body: SafeArea(
//         child: Column(
//           children: [
//             // ─── ✅ AppBar عصري مدمج ──────────────────────────────────
//             _ModernAppBar(controller: c),

//             // ─── ✅ المحتوى ───────────────────────────────────────────
//             Expanded(
//               child: Obx(() {
//                 if (c.prescriptions.isEmpty) {
//                   return _EmptyState(onAdd: c.addPrescription);
//                 }

//                 return ListView.builder(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: w * 0.04,
//                     vertical: h * 0.015,
//                   ),
//                   itemCount: c.prescriptions.length,
//                   itemBuilder: (_, i) => _PrescriptionCardModern(
//                     prescription: c.prescriptions[i],
//                     controller: c,
//                     index: i + 1,
//                   ),
//                 );
//               }),
//             ),

//             // ─── ✅ شريط التأكيد الثابت ───────────────────────────────
//             _BottomConfirmBar(controller: c),
//           ],
//         ),
//       ),
//       // ✅ FAB سريع لإضافة وصفة
//       floatingActionButton: Obx(
//         () => c.prescriptions.isNotEmpty
//             ? FloatingActionButton.small(
//                 onPressed: c.addPrescription,
//                 backgroundColor: constBlue,
//                 child: const Icon(Icons.add, color: Colors.white),
//               )
//             : const SizedBox.shrink(),
//       ),
//     );
//   }
// }

// // ─── ✅ AppBar عصري ────────────────────────────────────────────────
// class _ModernAppBar extends StatelessWidget {
//   final SendPrescriptionController controller;

//   const _ModernAppBar({required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(24),
//           bottomRight: Radius.circular(24),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // زر الرجوع
//           _IconButtonCircle(
//             icon: Icons.arrow_back_ios_new,
//             onTap: () => Get.back(),
//           ),
//           const SizedBox(width: 12),
//           const Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'الوصفات الطبية',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w800,
//                     fontFamily: 'Cairo',
//                     color: constColor,
//                   ),
//                 ),
//                 SizedBox(height: 2),
//                 Text(
//                   'أضف الوصفات والأدوية المطلوبة',
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontFamily: 'Cairo',
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // زر إضافة وصفة
//           FilledButton.icon(
//             onPressed: controller.addPrescription,
//             icon: const Icon(Icons.add, size: 18),
//             label: const Text(
//               'وصفة جديدة',
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//                 fontFamily: 'Cairo',
//               ),
//             ),
//             style: FilledButton.styleFrom(
//               backgroundColor: constBlue,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── ✅ حالة فارغة عصرية ──────────────────────────────────────────
// class _EmptyState extends StatelessWidget {
//   final VoidCallback onAdd;

//   const _EmptyState({required this.onAdd});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 120,
//             height: 120,
//             decoration: BoxDecoration(
//               color: constBlue.withOpacity(0.08),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.receipt_long_outlined,
//               size: 56,
//               color: constBlue.withOpacity(0.5),
//             ),
//           ),
//           const SizedBox(height: 24),
//           const Text(
//             'لا توجد وصفات بعد',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w700,
//               fontFamily: 'Cairo',
//               color: constColor,
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'اضغط على الزر أدناه لإضافة وصفة جديدة',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 13,
//               fontFamily: 'Cairo',
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 24),
//           FilledButton.icon(
//             onPressed: onAdd,
//             icon: const Icon(Icons.add),
//             label: const Text(
//               'إضافة وصفة جديدة',
//               style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w600,
//                 fontFamily: 'Cairo',
//               ),
//             ),
//             style: FilledButton.styleFrom(
//               backgroundColor: constBlue,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(14),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── ✅ كارد الوصفة العصري ────────────────────────────────────────
// class _PrescriptionCardModern extends StatelessWidget {
//   final Prescription prescription;
//   final SendPrescriptionController controller;
//   final int index;

//   const _PrescriptionCardModern({
//     required this.prescription,
//     required this.controller,
//     required this.index,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.grey.shade200),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 16,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ─── 1) رأس البطاقة ──────────────────────────────────────
//           _CardHeader(
//             index: index,
//             onDelete: () => controller.removePrescription(prescription.localId),
//           ),

//           const Divider(height: 1, indent: 16, endIndent: 16),

//           // ─── 2) إعدادات الوصفة (صف واحد أنيق) ────────────────────
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 // وحدة التكرار
//                 Expanded(
//                   flex: 2,
//                   child: _SettingsDropdown(
//                     label: 'الوحدة',
//                     value: prescription.frequencyUnit,
//                     items: const [
//                       MapEntry('day', 'يوم'),
//                       MapEntry('week', 'أسبوع'),
//                       MapEntry('month', 'شهر'),
//                     ],
//                     onChanged: (v) => controller.updatePrescription(
//                       prescription.localId,
//                       prescription.copyWith(frequencyUnit: v),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 // كل X
//                 Expanded(
//                   child: _CompactStepper(
//                     label: 'كل',
//                     value: prescription.frequencyInterval,
//                     onChanged: (v) => controller.updatePrescription(
//                       prescription.localId,
//                       prescription.copyWith(frequencyInterval: v),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 // دورات
//                 Expanded(
//                   child: _CompactStepper(
//                     label: 'دورات',
//                     value: prescription.totalCycles,
//                     onChanged: (v) => controller.updatePrescription(
//                       prescription.localId,
//                       prescription.copyWith(totalCycles: v),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // ─── 3) قسم الأدوية ──────────────────────────────────────
//           Container(
//             width: double.infinity,
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF8F9FB),
//               borderRadius: BorderRadius.circular(14),
//               border: Border.all(color: Colors.grey.shade200),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // عنوان القسم
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         color: constBlue.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Icon(
//                         Icons.medication_outlined,
//                         size: 16,
//                         color: constBlue,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     const Text(
//                       'الأدوية',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                         fontFamily: 'Cairo',
//                         color: constColor,
//                       ),
//                     ),
//                     const Spacer(),
//                     // عداد الأدوية
//                     if (prescription.items.isNotEmpty)
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 3,
//                         ),
//                         decoration: BoxDecoration(
//                           color: constBlue.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           '${prescription.items.length}',
//                           style: const TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: constBlue,
//                             fontFamily: 'Cairo',
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),

//                 // قائمة الأدوية
//                 if (prescription.items.isEmpty)
//                   _EmptyMedicines(onAdd: () => _showAddMedicineDialog(context))
//                 else
//                   Column(
//                     children: prescription.items
//                         .map(
//                           (item) => _MedicineTileModern(
//                             item: item,
//                             prescriptionId: prescription.localId,
//                             controller: controller,
//                           ),
//                         )
//                         .toList(),
//                   ),

//                 const SizedBox(height: 10),
//                 // زر إضافة دواء
//                 SizedBox(
//                   width: double.infinity,
//                   child: OutlinedButton.icon(
//                     onPressed: () => _showAddMedicineDialog(context),
//                     icon: const Icon(Icons.add, size: 18),
//                     label: const Text(
//                       'إضافة دواء',
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         fontFamily: 'Cairo',
//                       ),
//                     ),
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: constBlue,
//                       side: BorderSide(color: constBlue.withOpacity(0.3)),
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }

//   // ─── Dialog إضافة دواء ───────────────────────────────────────────
//   void _showAddMedicineDialog(BuildContext context) {
//     final selectedName = Rxn<String>();

//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: const Row(
//           children: [
//             Icon(Icons.medication_outlined, color: constBlue, size: 24),
//             SizedBox(width: 10),
//             Text(
//               'إضافة دواء',
//               style: TextStyle(
//                 fontFamily: 'Cairo',
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ],
//         ),
//         content: SizedBox(
//           width: double.maxFinite,
//           child: Obx(
//             () => CustomDropdown<String>(
//               items: controller.variantNames,
//               isLoading: controller.isLoadingVariants.value,
//               hasError: false,
//               onRetry: controller.fetchVariants,
//               labelBuilder: (v) => v,
//               label: 'اختر الدواء',
//               hint: 'ابحث عن الدواء...',
//               icon: Icons.search,
//               searchable: true,
//               value: selectedName.value,
//               validator: (v) => v == null ? 'الرجاء اختيار دواء' : null,
//               onChanged: (v) => selectedName.value = v,
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(),
//             child: const Text(
//               'إلغاء',
//               style: TextStyle(fontFamily: 'Cairo', fontSize: 14),
//             ),
//           ),
//           FilledButton(
//             onPressed: () {
//               final name = selectedName.value;
//               if (name != null && name.isNotEmpty) {
//                 controller.addMedicineToPrescription(
//                   prescriptionId: prescription.localId,
//                   variantName: name,
//                 );
//                 Navigator.of(ctx).pop();
//               }
//             },
//             style: FilledButton.styleFrom(
//               backgroundColor: constBlue,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             child: const Text(
//               'إضافة',
//               style: TextStyle(fontFamily: 'Cairo', fontSize: 14),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── ✅ رأس البطاقة ────────────────────────────────────────────────
// class _CardHeader extends StatelessWidget {
//   final int index;
//   final VoidCallback onDelete;

//   const _CardHeader({required this.index, required this.onDelete});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: constBlue.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Center(
//               child: Text(
//                 '#$index',
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w800,
//                   color: constBlue,
//                   fontFamily: 'Cairo',
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           const Expanded(
//             child: Text(
//               'وصفة طبية',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//                 fontFamily: 'Cairo',
//                 color: constColor,
//               ),
//             ),
//           ),
//           _IconButtonCircle(
//             icon: Icons.delete_outline,
//             color: constRed,
//             bgColor: constRed.withOpacity(0.08),
//             onTap: onDelete,
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── ✅ Dropdown مدمج للإعدادات ───────────────────────────────────
// class _SettingsDropdown extends StatelessWidget {
//   final String label;
//   final String value;
//   final List<MapEntry<String, String>> items;
//   final ValueChanged<String> onChanged;

//   const _SettingsDropdown({
//     required this.label,
//     required this.value,
//     required this.items,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 11,
//             fontWeight: FontWeight.w600,
//             fontFamily: 'Cairo',
//             color: Colors.grey.shade500,
//           ),
//         ),
//         const SizedBox(height: 6),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           decoration: BoxDecoration(
//             color: const Color(0xFFF5F6F8),
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: Colors.grey.shade200),
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: value,
//               isExpanded: true,
//               icon: const Icon(Icons.keyboard_arrow_down, size: 18),
//               borderRadius: BorderRadius.circular(10),
//               items: items.map((e) {
//                 return DropdownMenuItem(
//                   value: e.key,
//                   child: Text(
//                     e.value,
//                     style: const TextStyle(
//                       fontSize: 13,
//                       fontFamily: 'Cairo',
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 );
//               }).toList(),
//               onChanged: (v) {
//                 if (v != null) onChanged(v);
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ─── ✅ Stepper مدمج صغير ─────────────────────────────────────────
// class _CompactStepper extends StatelessWidget {
//   final String label;
//   final int value;
//   final ValueChanged<int> onChanged;

//   const _CompactStepper({
//     required this.label,
//     required this.value,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 11,
//             fontWeight: FontWeight.w600,
//             fontFamily: 'Cairo',
//             color: Colors.grey.shade500,
//           ),
//         ),
//         const SizedBox(height: 6),
//         Container(
//           height: 40,
//           decoration: BoxDecoration(
//             color: const Color(0xFFF5F6F8),
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: Colors.grey.shade200),
//           ),
//           child: Row(
//             children: [
//               _StepperBtn(
//                 icon: Icons.remove,
//                 enabled: value > 1,
//                 onTap: value > 1 ? () => onChanged(value - 1) : null,
//               ),
//               Expanded(
//                 child: Center(
//                   child: Text(
//                     '$value',
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w700,
//                       fontFamily: 'Cairo',
//                       color: constColor,
//                     ),
//                   ),
//                 ),
//               ),
//               _StepperBtn(icon: Icons.add, onTap: () => onChanged(value + 1)),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ─── ✅ زر +/- صغير ───────────────────────────────────────────────
// class _StepperBtn extends StatelessWidget {
//   final IconData icon;
//   final bool enabled;
//   final VoidCallback? onTap;

//   const _StepperBtn({required this.icon, this.enabled = true, this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       borderRadius: BorderRadius.circular(8),
//       child: InkWell(
//         onTap: enabled ? onTap : null,
//         borderRadius: BorderRadius.circular(8),
//         child: Container(
//           width: 32,
//           height: 32,
//           alignment: Alignment.center,
//           child: Icon(
//             icon,
//             size: 16,
//             color: enabled ? constBlue : Colors.grey.shade400,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─── ✅ بلاطة دواء عصرية ──────────────────────────────────────────
// class _MedicineTileModern extends StatelessWidget {
//   final PrescriptionItem item;
//   final String prescriptionId;
//   final SendPrescriptionController controller;

//   const _MedicineTileModern({
//     required this.item,
//     required this.prescriptionId,
//     required this.controller,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // اسم الدواء + زر حذف
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color: constBlue.withOpacity(0.08),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(
//                   Icons.medication_liquid_outlined,
//                   size: 16,
//                   color: constBlue,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Text(
//                   item.displayName,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                     fontFamily: 'Cairo',
//                     color: constColor,
//                   ),
//                 ),
//               ),
//               _IconButtonCircle(
//                 icon: Icons.close,
//                 color: constRed,
//                 bgColor: constRed.withOpacity(0.08),
//                 size: 28,
//                 iconSize: 14,
//                 onTap: () => controller.removeMedicineFromPrescription(
//                   prescriptionId: prescriptionId,
//                   itemLocalId: item.localId,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           // الكمية والمدة
//           Row(
//             children: [
//               Expanded(
//                 child: _CompactStepper(
//                   label: 'الكمية',
//                   value: item.prescribedQuantity,
//                   onChanged: (v) => controller.updateMedicineInPrescription(
//                     prescriptionId: prescriptionId,
//                     itemLocalId: item.localId,
//                     prescribedQuantity: v,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: _CompactStepper(
//                   label: 'المدة (أيام)',
//                   value: item.durationDays,
//                   onChanged: (v) => controller.updateMedicineInPrescription(
//                     prescriptionId: prescriptionId,
//                     itemLocalId: item.localId,
//                     durationDays: v,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── ✅ حالة لا توجد أدوية ────────────────────────────────────────
// class _EmptyMedicines extends StatelessWidget {
//   final VoidCallback onAdd;

//   const _EmptyMedicines({required this.onAdd});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 20),
//       child: Column(
//         children: [
//           Icon(
//             Icons.medication_outlined,
//             size: 40,
//             color: Colors.grey.shade300,
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'لا توجد أدوية',
//             style: TextStyle(
//               fontSize: 13,
//               color: Colors.grey.shade500,
//               fontFamily: 'Cairo',
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── ✅ شريط التأكيد الثابت في الأسفل ─────────────────────────────
// class _BottomConfirmBar extends StatelessWidget {
//   final SendPrescriptionController controller;

//   const _BottomConfirmBar({required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => controller.prescriptions.isEmpty
//           ? const SizedBox.shrink()
//           : Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(24),
//                   topRight: Radius.circular(24),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.06),
//                     blurRadius: 16,
//                     offset: const Offset(0, -4),
//                   ),
//                 ],
//               ),
//               child: SafeArea(
//                 child: Row(
//                   children: [
//                     // عداد الوصفات
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 14,
//                         vertical: 8,
//                       ),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF5F6F8),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Obx(
//                         () => Text(
//                           '${controller.prescriptions.length} وصفة',
//                           style: const TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w700,
//                             fontFamily: 'Cairo',
//                             color: constColor,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     // زر التأكيد
//                     Expanded(
//                       child: FilledButton.icon(
//                         onPressed: () => Get.back(),
//                         icon: const Icon(Icons.check_circle_outline, size: 20),
//                         label: const Text(
//                           'تأكيد وإرسال',
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w700,
//                             fontFamily: 'Cairo',
//                           ),
//                         ),
//                         style: FilledButton.styleFrom(
//                           backgroundColor: constGreen,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }

// // ─── ✅ زر أيقونة دائري ───────────────────────────────────────────
// class _IconButtonCircle extends StatelessWidget {
//   final IconData icon;
//   final Color? color;
//   final Color? bgColor;
//   final double size;
//   final double iconSize;
//   final VoidCallback onTap;

//   const _IconButtonCircle({
//     required this.icon,
//     required this.onTap,
//     this.color,
//     this.bgColor,
//     this.size = 36,
//     this.iconSize = 18,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: bgColor ?? Colors.grey.shade100,
//       borderRadius: BorderRadius.circular(10),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(10),
//         child: Container(
//           width: size,
//           height: size,
//           alignment: Alignment.center,
//           child: Icon(
//             icon,
//             size: iconSize,
//             color: color ?? Colors.grey.shade600,
//           ),
//         ),
//       ),
//     );
//   }
// }
