// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/SendPrescriptionController.dart';
import 'package:stock_mate_project/core/models/PrescriptionModel.dart';

class CustomArchivePrescriptionCard extends StatelessWidget {
  final PrescriptionModel prescription;

  const CustomArchivePrescriptionCard({super.key, required this.prescription});

  String _formatDate(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final period = date.hour >= 12 ? 'م' : 'ص';
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    final min = date.minute.toString().padLeft(2, '0');
    return '${date.year}/$mm/$dd  ${hour.toString().padLeft(2, '0')}:$min $period';
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'تأكيد الحذف',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontFamily: cairo, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'هل أنت متأكد من حذف وصفة "${prescription.patientName}"؟',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontFamily: cairo, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('إلغاء', style: TextStyle(fontFamily: cairo)),
          ),
          TextButton(
            onPressed: () {
              Get.find<SendPrescriptionController>().deletePrescription(
                prescription.id,
              );
              Navigator.pop(ctx);
            },
            child: Text(
              'حذف',
              style: TextStyle(
                fontFamily: cairo,
                color: Colors.red.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              prescription.patientName,
              style: TextStyle(
                fontFamily: cairo,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'الطبيب: ${prescription.doctorName}',
              style: TextStyle(
                fontFamily: cairo,
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
            Divider(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'الحالة المرضية',
                style: TextStyle(
                  fontFamily: cairo,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: constBlue,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              prescription.condition,
              style: TextStyle(fontFamily: cairo, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'الأدوية الموصوفة',
                style: TextStyle(
                  fontFamily: cairo,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: constBlue,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              prescription.medications,
              style: TextStyle(fontFamily: cairo, fontSize: 14),
            ),
            const SizedBox(height: 12),
            prescription.notes != null && prescription.notes!.trim().isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'ملاحظات',
                          style: TextStyle(
                            fontFamily: cairo,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: constBlue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        prescription.notes!,
                        style: TextStyle(fontFamily: cairo, fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                    ],
                  )
                : const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => _showDetails(context),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: h * 0.01, horizontal: w * 0.02),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: constBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.medical_information_rounded, color: constBlue),
            ),
            SizedBox(width: w * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prescription.patientName,
                    style: TextStyle(
                      fontFamily: cairo,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'د. ${prescription.doctorName}',
                    style: TextStyle(
                      fontFamily: cairo,
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    _formatDate(prescription.date),
                    style: TextStyle(
                      fontFamily: cairo,
                      fontSize: 11,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _confirmDelete(context),
              icon: Icon(Icons.delete_outline_rounded, color: constRed),
            ),
          ],
        ),
      ),
    );
  }
}
