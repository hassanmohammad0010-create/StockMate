// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Service/In_Consultation_Patients_Controller.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/In_Consultation_Patient_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

class InConsultationPatientsPage extends StatelessWidget {
  const InConsultationPatientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(InConsultationPatientsController());

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (c.isLoading.value && c.patients.isEmpty) {
                return const Center(child: CustomLoadingIndicator());
              }

              if (c.errorMessage.value.isNotEmpty && c.patients.isEmpty) {
                return Center(
                  child: Text(
                    c.errorMessage.value,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              if (c.patients.isEmpty) {
                return CustomEmptyState(tital: 'لا يوجد مرضى قيد المعاينة');
              }

              return ListView.builder(
                controller: c.scrollController,
                itemCount: c.patients.length + (c.hasMore ? 1 : 0),
                itemBuilder: (_, i) {
                  if (i >= c.patients.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CustomLoadingIndicator()),
                    );
                  }
                  return InConsultationPatientCard(
                    patient: c.patients[i],
                    queueNumber: i + 1,
                    onRemoveFromQueue: () {
                      c.releaseFromQueue(c.patients[i]);
                      Get.back();
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
