// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/PrescriptionController.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/models/PrescriptionModel.dart';

void showPrescriptionDetails(
  BuildContext context,
  PrescriptionModel prescription,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _PrescriptionDetailsSheet(prescriptionId: prescription.id),
  );
}

String _formatDate(DateTime date) {
  final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final period = date.hour >= 12 ? 'م' : 'ص';
  final mm = date.month.toString().padLeft(2, '0');
  final dd = date.day.toString().padLeft(2, '0');
  final min = date.minute.toString().padLeft(2, '0');
  return '${date.year}/$mm/$dd  ${hour.toString().padLeft(2, '0')}:$min $period';
}

class _PrescriptionDetailsSheet extends StatelessWidget {
  final String prescriptionId;

  const _PrescriptionDetailsSheet({required this.prescriptionId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PrescriptionController>();

    return Obx(() {
      final prescription = controller.findById(prescriptionId);

      if (prescription == null) return const SizedBox.shrink();

      final bool isNew = prescription.status == PrescriptionStatus.newRx;
      final Color accentColor = isNew ? constRed : constGreen;

      return _buildContent(
        context,
        controller,
        prescription,
        isNew,
        accentColor,
      );
    });
  }

  Widget _buildContent(
    BuildContext context,
    PrescriptionController controller,
    PrescriptionModel prescription,
    bool isNew,
    Color accentColor,
  ) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return Container(
      constraints: BoxConstraints(maxHeight: h * 0.85),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── شريط علوي ملون حسب الحالة ──
            // Container(
            //   width: double.infinity,
            //   height: h * 0.004,
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       colors: [accentColor, accentColor.withOpacity(0.4)],
            //       begin: Alignment.centerRight,
            //       end: Alignment.centerLeft,
            //     ),
            //     borderRadius: const BorderRadius.vertical(
            //       top: Radius.circular(24),
            //     ),
            //   ),
            // ),

            // ── مقبض السحب ──
            Padding(
              padding: EdgeInsets.only(top: h * 0.012),
              child: Container(
                width: w * 0.15,
                height: h * 0.005,
                decoration: BoxDecoration(
                  color: constGray.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

            // ── المحتوى القابل للتمرير ──
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.05,
                  vertical: h * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── اسم المريض + الحالة ──
                    Row(
                      children: [
                        // أيقونة حالة ملونة
                        Container(
                          width: h * 0.045,
                          height: h * 0.045,
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isNew
                                ? Icons.fiber_new_rounded
                                : Icons.check_circle_rounded,
                            size: h * 0.024,
                            color: accentColor,
                          ),
                        ),
                        SizedBox(width: w * 0.03),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                prescription.patientName,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              SizedBox(height: h * 0.003),
                              Text(
                                _formatDate(prescription.date),
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // شارة الحالة
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: w * 0.025,
                            vertical: h * 0.007,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: accentColor.withOpacity(0.3),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isNew
                                    ? Icons.schedule_rounded
                                    : Icons.verified_rounded,
                                size: 13,
                                color: accentColor,
                              ),
                              SizedBox(width: w * 0.01),
                              Text(
                                isNew ? 'جديدة' : 'تمت المعالجة',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: accentColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: h * 0.02),
                    Divider(height: 1, color: Colors.grey.shade200),
                    SizedBox(height: h * 0.02),

                    // ── الطبيب المعالج ──
                    _DetailRow(
                      icon: Icons.person_outline,
                      label: 'الطبيب المعالج',
                      value: prescription.doctorName ?? '---',
                      accentColor: accentColor,
                    ),
                    SizedBox(height: h * 0.02),

                    // ── الأدوية الموصوفة (قائمة) ──
                    _MedicationsSection(
                      medications: prescription.medications,
                      accentColor: accentColor,
                    ),

                    // ── الملاحظات ──
                    if (prescription.notes != null &&
                        prescription.notes!.trim().isNotEmpty) ...[
                      SizedBox(height: h * 0.02),
                      _DetailRow(
                        icon: Icons.notes_outlined,
                        label: 'ملاحظات',
                        value: prescription.notes!,
                        accentColor: accentColor,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // ── زر الصرف (ثابت أسفل) ──
            Padding(
              padding: EdgeInsets.only(
                right: w * 0.05,
                left: w * 0.05,
                bottom: h * 0.015,
              ),
              child: isNew
                  ? SizedBox(
                      width: double.infinity,
                      height: h * 0.056,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.back();
                          customSnackBar(
                            title: 'نجاح العملية',
                            message: 'تم صرف وصفة ${prescription.patientName}',
                            messageColor: Colors.white,
                            color: constGreen,
                          );
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text(
                          'صرف الوصفة',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: constGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: constGreen.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: h * 0.018),
                      decoration: BoxDecoration(
                        color: constGreen.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: constGreen.withOpacity(0.25),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: h * 0.022,
                            color: constGreen,
                          ),
                          SizedBox(width: w * 0.02),
                          const Text(
                            'هذه الوصفة تمت صرفها بالفعل',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: constGreen,
                            ),
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

// ─────────────────────────────────────────────────────────
//  قسم الأدوية المتعددة
// ─────────────────────────────────────────────────────────
class _MedicationsSection extends StatelessWidget {
  final String medications;
  final Color accentColor;

  const _MedicationsSection({
    required this.medications,
    required this.accentColor,
  });

  List<String> get _medicineList =>
      medications.split('\n').where((m) => m.trim().isNotEmpty).toList();

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;
    final meds = _medicineList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── العنوان مع العدد ──
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.02,
                vertical: h * 0.01,
              ),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.medication_outlined,
                size: 18,
                color: accentColor.withOpacity(0.8),
              ),
            ),
            SizedBox(width: w * 0.03),
            const Text(
              'الأدوية الموصوفة',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF9CA3AF),
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            // شارة العدد
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.022,
                vertical: h * 0.005,
              ),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: accentColor.withOpacity(0.2),
                  width: 0.5,
                ),
              ),
              child: Text(
                '${meds.length} ${meds.length == 1 ? 'دواء' : 'أدوية'}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: h * 0.012),

        // ── قائمة الأدوية ──
        ...meds.asMap().entries.map((entry) {
          final index = entry.key;
          final med = entry.value.trim();

          return Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: h * 0.008),
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.03,
              vertical: h * 0.013,
            ),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.04),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: accentColor.withOpacity(0.12),
                width: 0.7,
              ),
            ),
            child: Row(
              children: [
                // رقم الدواء
                Container(
                  width: h * 0.027,
                  height: h * 0.027,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [accentColor, accentColor.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: h * 0.011,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: w * 0.025),

                // اسم الدواء
                Expanded(
                  child: Text(
                    med,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ),

                // أيقونة
                Icon(
                  Icons.medication_liquid_outlined,
                  size: h * 0.018,
                  color: accentColor.withOpacity(0.35),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
//  صف تفصيل عادي (طبيب، ملاحظات)
// ─────────────────────────────────────────────────────────
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.02,
            vertical: h * 0.01,
          ),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.07),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: accentColor.withOpacity(0.7)),
        ),
        SizedBox(width: w * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: h * 0.002),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14.5,
                  color: Color(0xFF1F2937),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
