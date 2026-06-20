// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/PrescriptionController.dart';
import 'package:stock_mate_project/core/models/PrescriptionModel.dart';

/// يعرض تفاصيل الوصفة كاملة في bottom sheet، مع زر تحويل الحالة
/// عندما تكون الوصفة جديدة. الانتقال بين الصفحتين يحدث تلقائيًا
/// لأن الكونترولر يحدّث القائمة المصدر (Rx) ما يعيد بناء واجهتي
/// الصفحتين عبر Obx.
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

    // Obx يربط الواجهة مباشرة بحالة الوصفة داخل الكونترولر،
    // فإذا تغيّرت الحالة (newRx -> processed) تُعاد بناء الـ sheet فورًا
    // بدلاً من الاعتماد على نسخة (snapshot) قديمة من PrescriptionModel.
    return Obx(() {
      final prescription = controller.findById(prescriptionId);

      // قد تُحذف الوصفة أو لا توجد مؤقتًا أثناء إعادة البناء
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
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isNew ? 'جديدة' : 'تمت المعالجة',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: accentColor,
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

              const SizedBox(height: 28),

              // زر التحويل يظهر فقط للوصفات الجديدة
              if (isNew)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.markAsProcessed(prescription.id);
                      Get.back();
                      Get.snackbar(
                        'نجاح العملية',
                        'تم صرف وصفة ${prescription.patientName}',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: constGreen,
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 12,
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: constlightGreen,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Text(
                      'هذه الوصفة تمت صرفها بالفعل',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: constGreen,
                      ),
                    ),
                  ),
                ),
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
