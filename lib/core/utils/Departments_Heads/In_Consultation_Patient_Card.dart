// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/models/Patient_Model.dart';

class InConsultationPatientCard extends StatelessWidget {
  final PatientListItem patient;
  final int queueNumber;

  /// ✅ سيُربط لاحقاً باستدعاء API لتحرير المريض من الطابور
  final VoidCallback? onRemoveFromQueue;

  const InConsultationPatientCard({
    super.key,
    required this.patient,
    required this.queueNumber,
    this.onRemoveFromQueue,
  });

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    final doctorName = patient.lockedByName;
    final hasDoctor = doctorName != null && doctorName.trim().isNotEmpty;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.007),
      padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.015),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── الصف العلوي: الرقم + الاسم + شارة "قيد المعاينة" ──
          Row(
            children: [
              Container(
                width: w * 0.1,
                height: h * 0.05,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: constLightBlue,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '#$queueNumber',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: constBlue,
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(width: w * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: constColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: h * 0.002),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        patient.nationalNumber,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: w * 0.02),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.02,
                  vertical: h * 0.005,
                ),
                decoration: BoxDecoration(
                  color: constGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: constGreen.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.medical_services,
                      size: 14,
                      color: constGreen,
                    ),
                    SizedBox(width: w * 0.01),
                    const Text(
                      'قيد المعاينة',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: constGreen,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── اسم الطبيب المعالج ──
          if (hasDoctor) ...[
            SizedBox(height: h * 0.012),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.03,
                vertical: h * 0.009,
              ),
              decoration: BoxDecoration(
                color: constBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_hospital, size: 16, color: constBlue),
                  SizedBox(width: w * 0.02),
                  const Text(
                    'الطبيب المعالج:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  SizedBox(width: w * 0.01),
                  Expanded(
                    child: Text(
                      doctorName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: constBlue,
                        fontFamily: 'Cairo',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ── زر تحرير من الطابور ──
          SizedBox(height: h * 0.012),
          const Divider(height: 1),
          SizedBox(height: h * 0.008),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: onRemoveFromQueue,
              icon: const Icon(
                Icons.person_remove_outlined,
                size: 18,
                color: constRed,
              ),
              label: const Text(
                'تحرير من الطابور',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: constRed,
                  fontFamily: 'Cairo',
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: constRed,
                padding: EdgeInsets.symmetric(vertical: h * 0.008),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
