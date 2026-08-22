// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Service/Patient_Details_Controller.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Name_Container.dart';
import 'package:stock_mate_project/core/models/Prescription_Model.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Send_Prescription_Page.dart';
import 'package:stock_mate_project/core/models/Patient_Model.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Text_Field/Custom_My_TextFormFaild.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';

class CompleteConsultationPage extends StatelessWidget {
  const CompleteConsultationPage({super.key, required this.patient});

  final PatientListItem patient;

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PatientDetailsController>(tag: patient.id);
    final h = context.screenHeight;
    final w = context.screenWidth;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: constBackgroundColor,
        body: Column(
          children: [
            CustomBackContainer(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  w * 0.02,
                  h * 0.01,
                  w * 0.02,
                  h * 0.04,
                ),
                children: [
                  CustomNameContainer(
                    empName: patient.name,
                    specializationName:
                        'اغلاق الزيارة الحالية للمريض وانهاء معاينته',
                  ),
                  SizedBox(height: h * 0.03),
                  _sectionLabel(
                    'التشخيص والملاحظات',
                    Icons.assignment_outlined,
                  ),
                  SizedBox(height: h * 0.012),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.02,
                      vertical: h * 0.005,
                    ),
                    child: Column(
                      children: [
                        CustomMyTextFormField(
                          prefixIcon: Icons.assignment_outlined,
                          label: 'التشخيص',
                          hint: 'أدخل التشخيص (اختياري)',
                          controller: c.diagnosisController,
                        ),
                        SizedBox(height: h * 0.018),
                        CustomMyTextFormField(
                          prefixIcon: Icons.notes_outlined,
                          label: 'الملاحظات السريرية',
                          hint: 'أضف أي ملاحظات سريرية (اختياري)',
                          controller: c.clinicalNotesController,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: h * 0.03),
                  _sectionLabel('أدوية خارجية', Icons.medication_outlined),
                  SizedBox(height: h * 0.012),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.02,
                      vertical: h * 0.005,
                    ),
                    child: CustomMyTextFormField(
                      prefixIcon: Icons.medication_outlined,
                      label: 'أدوية خارجية',
                      hint: 'أي أدوية خارجية يُوصى بها',
                      controller: c.externalMedicationsController,
                    ),
                  ),
                  SizedBox(height: h * 0.02),
                  _buildPrescriptionsHeader(c),
                  SizedBox(height: h * 0.01),
                  _buildPrescriptionsList(c, w),
                  SizedBox(height: h * 0.02),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildConfirmBar(context, c, w),
      ),
    );
  }

  Widget _sectionLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: constBlue),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
            color: constColor,
          ),
        ),
      ],
    );
  }

  // ─── رأس قسم الوصفات + زر الإضافة ──────────────────────────────────
  Widget _buildPrescriptionsHeader(PatientDetailsController c) {
    return Row(
      children: [
        Expanded(
          child: _sectionLabel('الوصفات الطبية', Icons.receipt_long_outlined),
        ),
        TextButton.icon(
          onPressed: () => Get.to(
            () => const SendPrescriptionPage(),
            transition: Transition.rightToLeft,
          ),
          icon: const Icon(Icons.add, size: 18),
          label: const Text(
            'إضافة وصفة',
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w700,
              color: constBlue,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildPrescriptionsList(PatientDetailsController c, double w) {
    return Obx(() {
      final list = c.prescriptionController.prescriptions;
      if (list.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.shade200,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 30,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 8),
              Text(
                'لا توجد وصفات مرفقة بعد',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }
      return Column(
        children: List.generate(
          list.length,
          (i) => _prescriptionTile(list[i], i + 1),
        ),
      );
    });
  }

  Widget _prescriptionTile(Prescription p, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: constLightBlue.withOpacity(0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: constBlue.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: constBlue.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.receipt_long,
                  size: 15,
                  color: constBlue,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'وصفة #$index',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: constBlue,
                ),
              ),
              const Spacer(),
              Text(
                '${p.items.length} دواء',
                style: const TextStyle(
                  fontSize: 11,
                  fontFamily: 'Cairo',
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              p.summaryText,
              style: const TextStyle(
                fontSize: 11.5,
                fontFamily: 'Cairo',
                color: constColor,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── شريط التأكيد الثابت أسفل الشاشة ───────────────────────────────
  Widget _buildConfirmBar(
    BuildContext context,
    PatientDetailsController c,
    double w,
  ) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(w * 0.05, 14, w * 0.05, 14 + bottomInset),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'رجوع',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: constGray,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Obx(() {
              final completing = c.isCompleting.value;
              return ElevatedButton.icon(
                onPressed: completing ? null : c.completeConsultation,
                icon: completing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check_circle_outline, size: 20),
                label: Text(
                  completing ? 'جارٍ الإنهاء...' : 'تأكيد إنهاء المعاينة',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: constGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
