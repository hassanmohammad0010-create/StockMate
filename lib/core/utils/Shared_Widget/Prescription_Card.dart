// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/models/Prescriptions_Model.dart';

class PrescriptionCard extends StatelessWidget {
  const PrescriptionCard({
    super.key,
    required this.prescription,
    required this.onTap,
  });

  final Prescription prescription;
  final VoidCallback onTap;

  // ─── helpers ───────────────────────────────────────────────

  Color get _statusColor {
    switch (prescription.status) {
      case PrescriptionStatus.newRx:
        return constBlue;
      case PrescriptionStatus.processed:
        return const Color(0xFF09C05E);
      case PrescriptionStatus.rejected:
        return const Color(0xFFFF2125);
    }
  }

  String get _statusLabel {
    switch (prescription.status) {
      case PrescriptionStatus.newRx:
        return 'جديدة';
      case PrescriptionStatus.processed:
        return 'مُصرَّفة';
      case PrescriptionStatus.rejected:
        return 'مرفوضة';
    }
  }

  Color get _statusBg {
    switch (prescription.status) {
      case PrescriptionStatus.newRx:
        return constLightBlue;
      case PrescriptionStatus.processed:
        return const Color(0xFFE3FDED);
      case PrescriptionStatus.rejected:
        return const Color(0xFFFFEBEE);
    }
  }

  // ─── build ─────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: h * 0.006),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // ── شريط الحالة الجانبي ──
              Container(
                width: w * 0.015,
                decoration: BoxDecoration(
                  color: _statusColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
              ),

              // ── المحتوى ──
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.04,
                    vertical: h * 0.016,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // الصف العلوي: رقم الوصفة + badge الحالة
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            prescription.id,
                            style: TextStyle(
                              fontFamily: cairo,
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: w * 0.03,
                              vertical: h * 0.004,
                            ),
                            decoration: BoxDecoration(
                              color: _statusBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _statusLabel,
                              style: TextStyle(
                                fontFamily: cairo,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: _statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: h * 0.008),

                      // اسم الطبيب
                      Row(
                        children: [
                          Icon(Icons.person_outline,
                              size: 16, color: constBlue),
                          SizedBox(width: w * 0.015),
                          Text(
                            prescription.doctorName,
                            style: TextStyle(
                              fontFamily: cairo,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: h * 0.004),

                      // القسم
                      Row(
                        children: [
                          Icon(Icons.local_hospital_outlined,
                              size: 14, color: Colors.grey.shade500),
                          SizedBox(width: w * 0.015),
                          Text(
                            prescription.department,
                            style: TextStyle(
                              fontFamily: cairo,
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: h * 0.01),

                      // فاصل
                      Divider(height: 1, color: Colors.grey.shade100),

                      SizedBox(height: h * 0.01),

                      // الصف السفلي: المريض + التاريخ + عدد الأدوية
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // المريض
                          Row(
                            children: [
                              Icon(Icons.personal_injury_outlined,
                                  size: 14, color: Colors.grey.shade500),
                              SizedBox(width: w * 0.01),
                              Text(
                                prescription.patientName,
                                style: TextStyle(
                                  fontFamily: cairo,
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),

                          // التاريخ
                          Row(
                            children: [
                              Icon(Icons.calendar_today_outlined,
                                  size: 13, color: Colors.grey.shade500),
                              SizedBox(width: w * 0.01),
                              Text(
                                prescription.date,
                                style: TextStyle(
                                  fontFamily: cairo,
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),

                          // عدد الأدوية
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: w * 0.025,
                              vertical: h * 0.003,
                            ),
                            decoration: BoxDecoration(
                              color: constLightBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.medication_outlined,
                                    size: 13, color: constBlue),
                                SizedBox(width: w * 0.01),
                                Text(
                                  '${prescription.medicines.length} أدوية',
                                  style: TextStyle(
                                    fontFamily: cairo,
                                    fontSize: 11,
                                    color: constBlue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
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