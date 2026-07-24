// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/ArchiveController.dart';
import 'package:stock_mate_project/core/models/PrescriptionModel.dart';

void showPrescriptionArchiveDetails(
  BuildContext context,
  PrescriptionModel prescription,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _PrescriptionArchiveSheet(prescriptionId: prescription.id),
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

class _PrescriptionArchiveSheet extends StatelessWidget {
  final String prescriptionId;

  const _PrescriptionArchiveSheet({required this.prescriptionId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ArchiveController>();

    return Obx(() {
      final prescription = controller.archivedPrescriptions.firstWhereOrNull(
        (p) => p.id == prescriptionId,
      );

      if (prescription == null) return const SizedBox.shrink();

      return _buildContent(context, prescription);
    });
  }

  Widget _buildContent(BuildContext context, PrescriptionModel prescription) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    final hasDoctorName = (prescription.doctorName ?? '').trim().isNotEmpty;
    final hasNotes = (prescription.notes ?? '').trim().isNotEmpty;

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
            // ── مقبض السحب ──
            Padding(
              padding: EdgeInsets.only(top: h * 0.015),
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
                    // ── اسم المريض + شارة مأرشفة ──
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            prescription.patientName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: w * 0.025,
                            vertical: h * 0.007,
                          ),
                          decoration: BoxDecoration(
                            color: constBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: constBlue.withOpacity(0.3),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.archive_rounded,
                                size: 13,
                                color: constBlue,
                              ),
                              SizedBox(width: w * 0.01),
                              Text(
                                'مأرشفة',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: constBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.005),
                    Text(
                      _formatDate(prescription.date),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),

                    SizedBox(height: h * 0.02),
                    Divider(height: 1, color: Colors.grey.shade300),
                    SizedBox(height: h * 0.02),

                    // ── الطبيب المعالج ──
                    if (hasDoctorName) ...[
                      _DetailRow(
                        icon: Icons.person_outline,
                        label: 'الطبيب المعالج',
                        value: prescription.doctorName!,
                      ),
                      SizedBox(height: h * 0.02),
                    ],

                    // ── الأدوية الموصوفة (قائمة مرقّمة) ──
                    _MedicationsSection(medications: prescription.medications),

                    // ── الملاحظات ──
                    if (hasNotes) ...[
                      SizedBox(height: h * 0.02),
                      _DetailRow(
                        icon: Icons.notes_outlined,
                        label: 'ملاحظات',
                        value: prescription.notes!,
                      ),
                    ],
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
//  قسم الأدوية المتعددة (أزرق ثابت للأرشيف)
// ─────────────────────────────────────────────────────────
class _MedicationsSection extends StatelessWidget {
  final String medications;

  const _MedicationsSection({required this.medications});

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
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.medication_outlined,
                size: 18,
                color: Color(0xFF4B5563),
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
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.02,
                vertical: h * 0.004,
              ),
              decoration: BoxDecoration(
                color: constBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${meds.length} ${meds.length == 1 ? 'دواء' : 'أدوية'}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: constBlue,
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
              vertical: h * 0.012,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: constBlue.withOpacity(0.12),
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: h * 0.026,
                  height: h * 0.026,
                  decoration: const BoxDecoration(
                    color: constBlue,
                    shape: BoxShape.circle,
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
                Icon(
                  Icons.medication_liquid_outlined,
                  size: h * 0.018,
                  color: constBlue.withOpacity(0.4),
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

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
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
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF4B5563)),
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