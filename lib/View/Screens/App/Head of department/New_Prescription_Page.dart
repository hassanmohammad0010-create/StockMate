// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Prescription_Card.dart';
import 'package:stock_mate_project/Controller/Service/Pharmacy_Dispense_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Prescription_Details_Page.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Patient_Search_Field.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

class NewPrescriptionPage extends StatelessWidget {
  const NewPrescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;

    final controller = Get.put(
      PharmacyDispenseController(statuses: const ['ready']),
      tag: 'newPrescriptions',
    );

    final searchQuery = ''.obs;

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          PatientSearchField(
            onChanged: (query) => searchQuery.value = query,
            onClear: () => searchQuery.value = '',
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.prescriptions.isEmpty) {
                return const Center(child: CustomLoadingIndicator());
              }

              if (controller.errorMessage.value.isNotEmpty &&
                  controller.prescriptions.isEmpty) {
                return _buildErrorState(controller);
              }

              final query = searchQuery.value.toLowerCase().trim();
              final filtered = query.isEmpty
                  ? controller.prescriptions.toList()
                  : controller.prescriptions.where((p) {
                      final name = p.patientName.toLowerCase();
                      final nationalId = (p.nationalId ?? '').toLowerCase();
                      final familyBook = (p.familyBookNumber ?? '')
                          .toLowerCase();
                      final summary = p.medicationSummary.toLowerCase();
                      return name.contains(query) ||
                          nationalId.contains(query) ||
                          familyBook.contains(query) ||
                          summary.contains(query);
                    }).toList();

              if (filtered.isEmpty) {
                return controller.prescriptions.isEmpty
                    ? CustomEmptyState(tital: 'لا توجد وصفات جاهزة للصرف')
                    : CustomEmptyState(tital: 'لا توجد وصفات مطابقة للبحث');
              }

              return RefreshIndicator(
                color: constBlue,
                onRefresh: () => controller.fetchPrescriptions(),
                child: ListView.builder(
                  controller: controller.scrollController,
                  padding: EdgeInsets.symmetric(vertical: h * 0.005),
                  itemCount: filtered.length + (controller.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= filtered.length) {
                      return _buildLoadMoreFooter(controller);
                    }
                    final prescription = filtered[index];
                    return MyPrescriptionCard(
                      prescription: prescription,
                      onTap: () => Get.to(
                        () => PrescriptionDetailsPage(queueItem: prescription),
                        transition: Transition.rightToLeft,
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreFooter(PharmacyDispenseController c) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: c.isLoadingMore.value
            ? const Center(child: CustomLoadingIndicator())
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildErrorState(PharmacyDispenseController c) {
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
            onPressed: () => c.fetchPrescriptions(),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('إعادة المحاولة'),
            style: TextButton.styleFrom(foregroundColor: constBlue),
          ),
        ],
      ),
    );
  }
}