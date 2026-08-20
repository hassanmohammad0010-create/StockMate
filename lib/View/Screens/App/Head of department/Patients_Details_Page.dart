// ignore_for_file: file_names, deprecated_member_use, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Service/Patient_Details_Controller.dart';
import 'package:stock_mate_project/core/models/Patient_Details_Info.dart';
import 'package:stock_mate_project/core/models/Prescription_Model.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Send_Prescription_Page.dart';
import 'package:stock_mate_project/core/models/Patient_Model.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Text_Field/Custom_My_TextFormFaild.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

class PatientsDetailsPage extends StatelessWidget {
  const PatientsDetailsPage({super.key, required this.patient});

  final PatientListItem patient;

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    final c = Get.put(
      PatientDetailsController(patient: patient),
      tag: patient.id,
    );

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          const CustomBackContainer(),
          _PatientHeaderCard(patient: patient, h: h, w: w),
          SizedBox(height: h * 0.015),
          Expanded(
            child: Obx(() {
              if (c.isLoading.value && c.details.value == null) {
                return const Center(child: CustomLoadingIndicator());
              }
              if (c.errorMessage.value.isNotEmpty && c.details.value == null) {
                return _buildErrorState(c);
              }
              final d = c.details.value;
              if (d == null) return _buildErrorState(c);
              if (d.totalVisits == 0) {
                return _buildEmptyHistoryState(c, h, w);
              }
              return RefreshIndicator(
                color: constBlue,
                onRefresh: () => c.fetchHistory(),
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.04,
                    vertical: h * 0.01,
                  ),
                  children: [
                    _buildActionButtons(c, w),
                    SizedBox(height: h * 0.02),
                    _buildInputFields(c, h, w),
                    SizedBox(height: h * 0.02),
                    _buildSummaryCard(d, w),
                    const SizedBox(height: 12),
                    ...d.departments.map(
                      (dept) => _buildDepartmentSection(dept, h, w),
                    ),
                    SizedBox(height: h * 0.03),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ─── ✅ الأزرار: حجز + إنهاء المعاينة + إلغاء الحجز ──────────────
  Widget _buildActionButtons(PatientDetailsController c, double w) {
    return Column(
      children: [
        Row(
          children: [
            // زر حجز المريض
            Expanded(
              child: Obx(() {
                final booking = c.isBooking.value;
                final booked = c.isBooked.value;
                return ElevatedButton.icon(
                  onPressed: (booking || booked) ? null : c.bookPatient,
                  icon: booking
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          booked ? Icons.check_circle : Icons.event_available,
                          size: 20,
                        ),
                  label: Text(
                    booking
                        ? 'جارٍ الحجز...'
                        : booked
                        ? 'قيد المعاينة'
                        : 'حجز المريض',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: booked ? constGray : constGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(width: w * 0.03),

            // ✅ زر إنهاء المعاينة (يستبدل زر إرفاق الوصفة)
            Expanded(
              child: Obx(() {
                final booked = c.isBooked.value;
                return ElevatedButton.icon(
                  onPressed: booked ? () => _showCompleteBottomSheet(c) : null,
                  icon: const Icon(Icons.task_alt_outlined, size: 20),
                  label: const Text(
                    'إنهاء المعاينة',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: constBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),

        // زر إلغاء الحجز
        Obx(() {
          if (!c.isBooked.value) return const SizedBox.shrink();
          final releasing = c.isReleasing.value;
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: releasing ? null : c.releasePatient,
                icon: releasing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: constRed,
                        ),
                      )
                    : const Icon(Icons.person_remove_alt_1_outlined, size: 20),
                label: Text(
                  releasing
                      ? 'جارٍ إلغاء الحجز...'
                      : 'إلغاء الحجز (الإعادة إلى الانتظار)',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: constRed,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: constRed),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // ─── ✅✅✅ Bottom Sheet لإنهاء المعاينة ────────────────────────────
  // ─── Bottom Sheet لإنهاء المعاينة ────────────────────────────────
  void _showCompleteBottomSheet(PatientDetailsController c) {
    final context = Get.context!;
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return Container(
          padding: EdgeInsets.fromLTRB(w * 0.04, h * 0.02, w * 0.04, h * 0.03),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // المقبض
                Center(
                  child: Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // العنوان
                const Text(
                  'إنهاء المعاينة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: constColor,
                  ),
                ),
                const SizedBox(height: 12),

                // ملخص البيانات
                _summaryItem(
                  'التشخيص',
                  c.diagnosisController.text.isEmpty
                      ? '(فارغ)'
                      : c.diagnosisController.text,
                ),
                _summaryItem(
                  'الملاحظات السريرية',
                  c.clinicalNotesController.text.isEmpty
                      ? '(فارغ)'
                      : c.clinicalNotesController.text,
                ),
                const SizedBox(height: 16),

                // الأدوية الخارجية — باستخدام CustomMyTextFormField
                CustomMyTextFormField(
                  prefixIcon: Icons.medication_outlined,
                  label: 'أدوية خارجية (اختياري)',
                  hint: 'أي أدوية خارجية يوصى بها',
                  controller: c.externalMedicationsController,
                ),
                const SizedBox(height: 16),

                // الوصفات الطبية
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'الوصفات الطبية:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Cairo',
                          color: constColor,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(sheetCtx).pop(); // إغلاق BottomSheet أولاً
                        Get.to(
                          () => const SendPrescriptionPage(),
                          transition: Transition.rightToLeft,
                        );
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text(
                        'إضافة وصفة',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Cairo',
                          color: constBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // قائمة الوصفات
                Obx(() {
                  final list = c.prescriptionController.prescriptions;
                  if (list.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const Center(
                        child: Text(
                          'لا توجد وصفات',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: List.generate(
                      list.length,
                      (i) => _prescriptionTile(list[i], i + 1),
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // الأزرار
                Obx(() {
                  final completing = c.isCompleting.value;
                  return Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: completing
                              ? null
                              : () => Navigator.of(sheetCtx).pop(),
                          child: const Text(
                            'إلغاء',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                              color: constGray,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: completing
                              ? null
                              : () async {
                                  Navigator.of(
                                    sheetCtx,
                                  ).pop(); // ✅ إغلاق BottomSheet
                                  await Future.delayed(
                                    const Duration(milliseconds: 300),
                                  );
                                  // ✅ سيستدعي Get.back() لإغلاق صفحة التفاصيل أيضاً
                                  await c.completeConsultation();
                                },
                          icon: completing
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.check_circle_outline,
                                  size: 20,
                                ),
                          label: Text(
                            completing ? 'جارٍ الإنهاء...' : 'إنهاء المعاينة',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: constGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _summaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Cairo',
                color: value == '(فارغ)' ? Colors.grey : constColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _prescriptionTile(Prescription p, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: constLightBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: constBlue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long, size: 16, color: constBlue),
              const SizedBox(width: 6),
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
          const SizedBox(height: 4),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              p.summaryText,
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'Cairo',
                color: constColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── الحقول النصية ────────────────────────────────────────────────
  Widget _buildInputFields(PatientDetailsController c, double h, double w) {
    return Container(
      padding: EdgeInsets.all(w * 0.04),
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
          const Text(
            'معلومات الزيارة الحالية',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              color: constColor,
            ),
          ),
          SizedBox(height: h * 0.015),
          CustomMyTextFormField(
            prefixIcon: Icons.assignment_outlined,
            label: 'التشخيص',
            hint: 'أدخل التشخيص (اختياري)',
            controller: c.diagnosisController,
          ),
          SizedBox(height: h * 0.015),
          CustomMyTextFormField(
            prefixIcon: Icons.notes_outlined,
            label: 'الملاحظات السريرية',
            hint: 'أضف أي ملاحظات سريرية (اختياري)',
            controller: c.clinicalNotesController,
          ),
        ],
      ),
    );
  }

  // ─── هيدر المريض ──────────────────────────────────────────────────
  Widget _PatientHeaderCard({
    required PatientListItem patient,
    required double h,
    required double w,
  }) {
    final waitColor = _waitColor(patient.waitingDuration.inMinutes);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.015),
      padding: EdgeInsets.all(w * 0.04),
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
      child: Row(
        children: [
          Container(
            width: w * 0.15,
            height: w * 0.15,
            decoration: BoxDecoration(
              color: constLightBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline, color: constBlue, size: 32),
          ),
          SizedBox(width: w * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: constColor,
                  ),
                ),
                const SizedBox(height: 4),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    patient.nationalNumber,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: w * 0.03),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.025,
              vertical: h * 0.006,
            ),
            decoration: BoxDecoration(
              color: waitColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: waitColor.withOpacity(0.4)),
            ),
            child: Column(
              children: [
                Icon(Icons.access_time, size: 16, color: waitColor),
                const SizedBox(height: 2),
                Text(
                  patient.waitingDurationText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: waitColor,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── كارت الملخص ──────────────────────────────────────────────────
  Widget _buildSummaryCard(PatientDetailsResponse d, double w) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: constBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: constBlue.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItemBox(
            Icons.business_outlined,
            '${d.departments.length}',
            'الأقسام',
          ),
          Container(width: 1, height: 30, color: constBlue.withOpacity(0.2)),
          _summaryItemBox(
            Icons.event_note_outlined,
            '${d.totalVisits}',
            'الزيارات',
          ),
        ],
      ),
    );
  }

  Widget _summaryItemBox(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: constBlue, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: constBlue,
            fontFamily: 'Cairo',
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }

  // ─── قسم قسم ──────────────────────────────────────────────────────
  Widget _buildDepartmentSection(
    PatientDepartmentHistory dept,
    double h,
    double w,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: constBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.local_hospital_outlined,
                  color: constBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  dept.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: constColor,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${dept.visits.length}',
                  style: const TextStyle(
                    color: constColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...dept.sortedVisits.map((v) => _buildVisitCard(v, w)),
        ],
      ),
    );
  }

  Widget _buildVisitCard(PatientVisit visit, double w) {
    final statusColor = _visitStatusColor(visit.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: visit.isCancelled
              ? constRed.withOpacity(0.3)
              : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 15,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 6),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  visit.formattedVisitDate,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor.withOpacity(0.4)),
                ),
                child: Text(
                  visit.statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
          if (visit.doctor != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: constBlue.withOpacity(0.1),
                  child: const Icon(
                    Icons.medical_services_outlined,
                    color: constBlue,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'د. ${visit.doctor!.fullName}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: constColor,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                if (visit.doctor!.specialty != null)
                  Text(
                    visit.doctor!.specialty!,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontFamily: 'Cairo',
                    ),
                  ),
              ],
            ),
          ],
          if (visit.hasDiagnosis) ...[
            const SizedBox(height: 10),
            _infoBox(
              icon: Icons.assignment_outlined,
              label: 'التشخيص',
              value: visit.diagnosis!,
              color: constBlue,
            ),
          ],
          if (visit.hasClinicalNotes) ...[
            const SizedBox(height: 8),
            _infoBox(
              icon: Icons.notes_outlined,
              label: 'الملاحظات السريرية',
              value: visit.clinicalNotes!,
              color: constGray,
            ),
          ],
          if (visit.hasExternalMedications) ...[
            const SizedBox(height: 8),
            _infoBox(
              icon: Icons.medication_outlined,
              label: 'الأدوية الخارجية',
              value: visit.externalMedications!,
              color: constGreen,
            ),
          ],
          if (visit.hasCancelReason) ...[
            const SizedBox(height: 8),
            _infoBox(
              icon: Icons.cancel_outlined,
              label: 'سبب الإلغاء',
              value: visit.cancelReason!,
              color: constRed,
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoBox({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade800,
                    fontFamily: 'Cairo',
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── حالات فارغة / خطأ ───────────────────────────────────────────
  Widget _buildEmptyHistoryState(
    PatientDetailsController c,
    double h,
    double w,
  ) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.01),
      children: [
        _buildActionButtons(c, w),
        SizedBox(height: h * 0.02),
        _buildInputFields(c, h, w),
        SizedBox(height: h * 0.04),
        Center(
          child: Column(
            children: [
              Icon(
                Icons.history_outlined,
                size: 70,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 12),
              const Text(
                'لا يوجد سجل طبي لهذا المريض',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Cairo',
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(PatientDetailsController c) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off_outlined, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            c.errorMessage.value.isEmpty
                ? 'تعذر تحميل السجل الطبي'
                : c.errorMessage.value,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Cairo',
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: c.fetchHistory,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('إعادة المحاولة'),
            style: TextButton.styleFrom(foregroundColor: constBlue),
          ),
        ],
      ),
    );
  }

  Color _visitStatusColor(String status) {
    switch (status) {
      case 'completed':
        return constGreen;
      case 'cancelled':
        return constRed;
      case 'scheduled':
        return constBlue;
      case 'in_progress':
        return constOrange;
      default:
        return constGray;
    }
  }

  Color _waitColor(int minutes) {
    if (minutes >= 60) return constRed;
    if (minutes >= 30) return constOrange;
    return constGreen;
  }
}
