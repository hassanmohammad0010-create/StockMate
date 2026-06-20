// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/SendPrescriptionController.dart';
import 'package:stock_mate_project/core/models/PrescriptionModel.dart';

/// يعرض تفاصيل الوصفة كاملة في bottom sheet، مع زر تحويل الحالة
/// عندما تكون الوصفة جديدة. الانتقال بين الصفحتين يحدث تلقائيًا
/// لأن الكونترولر يحدّث القائمة المصدر (Rx) ما يعيد بناء واجهتي
/// الصفحتين عبر Obx.
void showPrescriptionArchiveDetails(
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
    final controller = Get.find<SendPrescriptionController>();

    // Obx يربط الواجهة مباشرة بحالة الوصفة داخل الكونترولر，
    // فإذا تغيّرت الحالة (newRx -> processed) تُعاد بناء الـ sheet فورًا
    // بدلاً من الاعتماد على نسخة (snapshot) قديمة من PrescriptionModel.
    return Obx(() {
      final prescription = controller.archivedPrescriptions.firstWhere(
        (p) => p.id == prescriptionId,
        orElse: () => controller.archivedPrescriptions.first,
      );

      // قد تُحذف الوصفة أو لا توجد مؤقتًا أثناء إعادة البناء

      return _buildContent(
        context,
        controller,
        prescription,
        prescription.status == PrescriptionStatus.newRx,
      );
    });
  }

  Widget _buildContent(
    BuildContext context,
    SendPrescriptionController controller,
    PrescriptionModel prescription,
    bool isNew,
  ) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // مقبض السحب
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // رأس البطاقة: الاسم + الشارة
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: constLightBlue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'مأرشفة',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: constBlue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(prescription.date),
                style: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
              ),

              const SizedBox(height: 20),
              const Divider(height: 1, color: Color(0xFFE5E7EB)),
              const SizedBox(height: 20),

              _DetailRow(
                icon: Icons.person_outline,
                label: 'الطبيب المعالج',
                value: prescription.doctorName,
              ),
              const SizedBox(height: 16),
              _DetailRow(
                icon: Icons.healing,
                label: 'الحالة الطبية',
                value: prescription.condition,
              ),
              const SizedBox(height: 16),
              _DetailRow(
                icon: Icons.medication_outlined,
                label: 'الأدوية الموصوفة',
                value: prescription.medications,
              ),
              if (prescription.notes != null &&
                  prescription.notes!.trim().isNotEmpty) ...[
                const SizedBox(height: 16),
                _DetailRow(
                  icon: Icons.notes_outlined,
                  label: 'ملاحظات',
                  value: prescription.notes!,
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF4B5563)),
        ),
        const SizedBox(width: 12),
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
              const SizedBox(height: 2),
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
