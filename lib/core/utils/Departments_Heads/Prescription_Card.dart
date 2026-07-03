// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/models/PrescriptionModel.dart';

class PrescriptionCard extends StatelessWidget {
  final PrescriptionModel prescription;
  final VoidCallback onTap;

  const PrescriptionCard({
    super.key,
    required this.prescription,
    required this.onTap,
  });

  bool get _isNew => prescription.status == PrescriptionStatus.newRx;

  @override
  Widget build(BuildContext context) {
    
    final h = context.screenHeight;
    final w = context.screenWidth;

    final Color accentColor = _isNew ? constRed : constGreen;
    final Color backgroundTint = _isNew ? constLightRed : constLightGreen;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: w * 0.04,
            vertical: h * 0.01,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.04,
            vertical: h * 0.018,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: const [
              BoxShadow(
                color: constColor,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: w * 0.01,
                height: h * 0.08,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(width: w * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            prescription.patientName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: w * 0.02,
                            vertical: h * 0.005,
                          ),
                          decoration: BoxDecoration(
                            color: backgroundTint,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _isNew ? 'جديدة' : 'مصروفة',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.005),
                    Row(
                      children: [
                        const Icon(
                          Icons.healing,
                          size: 15,
                          color: Color(0xFF6B7280),
                        ),
                        SizedBox(width: w * 0.01),
                        Expanded(
                          child: Text(
                            prescription.condition,
                            style: const TextStyle(
                              fontSize: 13.5,
                              color: Color(0xFF4B5563),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.005),
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 15,
                          color: Color(0xFF6B7280),
                        ),
                        SizedBox(width: w * 0.01),
                        Expanded(
                          child: Text(
                            prescription.doctorName,
                            style: const TextStyle(
                              fontSize: 13.5,
                              color: Color(0xFF4B5563),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          DateFormat('yyyy/MM/dd').format(prescription.date),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
