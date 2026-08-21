// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/models/Dispense_Queue_Item.dart';

class MyPrescriptionCard extends StatelessWidget {
  final DispenseQueueItem prescription;
  final VoidCallback onTap;

  const MyPrescriptionCard({
    super.key,
    required this.prescription,
    required this.onTap,
  });

  Color get _accentColor {
    switch (prescription.status) {
      case CycleStatus.ready:
        return constRed;
      case CycleStatus.partially_delivered:
        return constOrange;
      case CycleStatus.delivered:
        return constGreen;
      case CycleStatus.missed:
        return constBlue;
      case CycleStatus.cancelled:
        return constGray;
    }
  }

  Color get _backgroundTint {
    switch (prescription.status) {
      case CycleStatus.ready:
        return constLightRed;
      case CycleStatus.partially_delivered:
        return constLightOrange;
      case CycleStatus.delivered:
        return constLightGreen;
      case CycleStatus.missed:
        return constLightBlue;
      case CycleStatus.cancelled:
        return const Color(0xFFF3F4F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: w * 0.04,
            vertical: h * 0.005,
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
                color: Color(0x1A000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الشريط الجانبي الملون
              Container(
                width: w * 0.01,
                height: h * 0.08,
                decoration: BoxDecoration(
                  color: _accentColor,
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
                              fontFamily: 'Cairo',
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
                            color: _backgroundTint,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            prescription.status.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _accentColor,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: h * 0.01),
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 15,
                          color: Color(0xFF6B7280),
                        ),
                        SizedBox(width: w * 0.01),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            prescription.displayId,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: h * 0.008),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: prescription.isNew
                              ? constOrange
                              : const Color(0xFF9CA3AF),
                        ),
                        SizedBox(width: w * 0.01),
                        Text(
                          prescription.waitingDurationText,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: prescription.isNew
                                ? constOrange
                                : const Color(0xFF9CA3AF),
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const Spacer(),
                        Text(
                          prescription.formattedReadySince,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF9CA3AF),
                            fontFamily: 'Cairo',
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
