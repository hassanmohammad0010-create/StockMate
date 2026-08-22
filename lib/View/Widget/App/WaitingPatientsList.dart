// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Service/Patients_Controller.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Patient_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

/// ✅ محتوى قائمة المرضى المنتظرين — بدون Scaffold
/// قابل للتضمين داخل أي صفحة (DoctorHomePage) أو للاستخدام كصفحة مستقلة
class WaitingPatientsList extends StatelessWidget {
  const WaitingPatientsList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PatientsController());
    final h = context.screenHeight;

    return Obx(() {
      if (controller.isLoading.value && controller.patients.isEmpty) {
        return Column(
          children: [
            SizedBox(height: h * 0.2),
            Center(child: CustomLoadingIndicator()),
          ],
        );
      }

      if (controller.errorMessage.value.isNotEmpty &&
          controller.patients.isEmpty) {
        return _buildErrorState(controller);
      }

      if (controller.patients.isEmpty) {
        return CustomEmptyState(tital: 'لا يوجد مرضى في الانتظار');
      }

      // ✅ لا يملك RefreshIndicator هنا لأن هذا widget مضمّن
      // (السحب للتحديث يُدار من الصفحة الحاوية، انظر الملاحظة أدناه)
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: h * 0.015),
        itemCount: controller.patients.length + (controller.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= controller.patients.length) {
            return _buildLoadMoreFooter(controller);
          }
          final patient = controller.patients[index];
          return PatientCard(patient: patient, queueNumber: index + 1);
        },
      );
    });
  }

  Widget _buildErrorState(PatientsController c) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off_outlined, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            c.errorMessage.value,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Cairo',
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => c.fetchPatients(),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('إعادة المحاولة'),
            style: TextButton.styleFrom(foregroundColor: constBlue),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreFooter(PatientsController c) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: c.isLoadingMore.value
            ? const Center(child: CustomLoadingIndicator())
            : const SizedBox.shrink(),
      ),
    );
  }
}
