// ignore_for_file: file_names, deprecated_member_use, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Patients_Controller.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/models/Patient_Model.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';

class PatientsDetailsPage extends StatelessWidget {
  final PatientModel patient;

  const PatientsDetailsPage({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final PatientsController controller = Get.find<PatientsController>();
    final h = context.screenHeight;
    final w = context.screenWidth;

    // نستخدم Obx لمراقبة القائمة وجلب أحدث بيانات للمريض لحظياً
    return Obx(() {
      // البحث عن المريض المحدث في القائمة، أو استخدام البيانات القديمة كملاذ أخير
      final currentPatient = controller.patients.firstWhere(
        (p) => p.id == patient.id,
        orElse: () => patient,
      );

      final isUnderExamination = currentPatient.status == 'قيد الفحص';

      // تحديد خصائص الزر بناءً على الحالة الحالية
      final statusButtonColor = isUnderExamination ? constGreen : constOrange;
      final statusButtonText = isUnderExamination
          ? 'إرجاع الحالة إلى: في الانتظار'
          : 'تغيير الحالة إلى: قيد الفحص';
      final statusButtonIcon = isUnderExamination
          ? Icons.restore
          : Icons.check_circle_outline;

      return Scaffold(
        backgroundColor: constBackgroundColor,
        body: Column(
          children: [
            const CustomBackContainer(),
            CustomHeadContainer(title: 'تفاصيل المريض'),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.05,
                  vertical: h * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. زر تغيير الحالة (تفاعلي وذكي)
                    Container(
                      padding: EdgeInsets.symmetric(vertical: h * 0.02),
                      decoration: BoxDecoration(
                        color: statusButtonColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: statusButtonColor.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'الحالة الحالية: ${currentPatient.status}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: statusButtonColor,
                            ),
                          ),
                          SizedBox(height: h * 0.015),
                          Container(
                            width: w * 0.6,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                final newStatus = isUnderExamination
                                    ? 'في الانتظار'
                                    : 'قيد الفحص';
                                controller.updatePatientStatus(
                                  currentPatient.id,
                                  newStatus,
                                );
                                customSnackBar(
                                  title: 'تم التحديث',
                                  message:
                                      'تم تغيير حالة المريض إلى: $newStatus',
                                  color: constGreen,
                                  messageColor: Colors.white,
                                );
                              },
                              icon: Icon(statusButtonIcon, color: Colors.white),
                              label: Text(
                                statusButtonText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: statusButtonColor,
                                padding: EdgeInsets.symmetric(
                                  vertical: h * 0.015,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: h * 0.03),

                    // 2. بطاقة تفاصيل المريض
                    Container(
                      padding: EdgeInsets.all(w * 0.04),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                            'اسم المريض',
                            currentPatient.name,
                            Icons.person_outline_outlined,
                          ),
                          SizedBox(height: h * 0.015),
                          _buildInfoRow(
                            'الرقم الوطني',
                            currentPatient.nationalNumber,
                            Icons.badge_outlined,
                          ),
                          SizedBox(height: h * 0.015),
                          _buildInfoRow(
                            'وقت الوصول',
                            _formatTime(currentPatient.arrivalTime),
                            Icons.access_time,
                          ),
                          SizedBox(height: h * 0.015),
                          _buildInfoRow(
                            'مدة الانتظار',
                            currentPatient.waitingDurationText,
                            Icons.hourglass_empty,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: h * 0.04),

                    // 3. أزرار الإجراءات في نهاية الصفحة
                    const Text(
                      'إجراءات نهاية المعاينة',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: h * 0.015),
                    Row(
                      children: [
                        // زر إرسال وصفة طبية
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.receipt_long,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'إرسال وصفة',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: constBlue,
                              padding: EdgeInsets.symmetric(
                                vertical: h * 0.018,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: w * 0.03),
                        // زر انتهت المعاينة
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Get.back();
                              // تغيير الحالة إلى "تمت المعاينة" بدلاً من الحذف
                              controller.completeConsultation(
                                currentPatient.id,
                              );
                              customSnackBar(
                                title: 'تم بنجاح',
                                message: 'انتهت معاينة المريض',
                                color: constGreen,
                                messageColor: Colors.white,
                              );
                            },
                            icon: const Icon(Icons.done_all, color: constRed),
                            label: const Text(
                              'انتهت المعاينة',
                              style: TextStyle(
                                color: constRed,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: constRed,
                                width: 1.5,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: h * 0.018,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
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
      );
    });
  }

  // دالة مساعدة لبناء صفوف المعلومات
  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: constColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
