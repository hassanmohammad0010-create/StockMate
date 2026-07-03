// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/PrescriptionController.dart';
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
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.05,
            vertical: h * 0.02,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: w * 0.15,
                  height: h * 0.005,
                  decoration: BoxDecoration(
                    color: constGray.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              SizedBox(height: h * 0.02),
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
                      horizontal: w * 0.02,
                      vertical: h * 0.006,
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
              SizedBox(height: h * 0.005),
              Text(
                _formatDate(prescription.date),
                style: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
              ),

              SizedBox(height: h * 0.02),
              Divider(height: h * 0.001, color: Colors.grey.shade300),
              SizedBox(height: h * 0.02),

              _DetailRow(
                icon: Icons.person_outline,
                label: 'الطبيب المعالج',
                value: prescription.doctorName,
              ),
              SizedBox(height: h * 0.02),
              _DetailRow(
                icon: Icons.healing,
                label: 'الحالة الطبية',
                value: prescription.condition,
              ),
              SizedBox(height: h * 0.02),
              _DetailRow(
                icon: Icons.medication_outlined,
                label: 'الأدوية الموصوفة',
                value: prescription.medications,
              ),
              if (prescription.notes != null &&
                  prescription.notes!.trim().isNotEmpty) ...[
                SizedBox(height: h * 0.02),
                _DetailRow(
                  icon: Icons.notes_outlined,
                  label: 'ملاحظات',
                  value: prescription.notes!,
                ),
              ],

              SizedBox(height: h * 0.034),

              if (isNew)
                SizedBox(
                  width: double.infinity,
                  height: h * 0.056,
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
                        margin: EdgeInsets.symmetric(
                          horizontal: w * 0.04,
                          vertical: h * 0.02,
                        ),
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
                  padding: EdgeInsets.symmetric(vertical: h * 0.02),
                  decoration: BoxDecoration(
                    color: constLightGreen,
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
