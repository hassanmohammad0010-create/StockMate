// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/SendPrescriptionController.dart';
import 'package:stock_mate_project/core/models/PrescriptionModel.dart';


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

    return Obx(() {
      final prescription = controller.archivedPrescriptions.firstWhere(
        (p) => p.id == prescriptionId,
        orElse: () => controller.archivedPrescriptions.first,
      );

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
                    color: const Color(0xFFE5E7EB),
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
              SizedBox(height: h * 0.02),
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
