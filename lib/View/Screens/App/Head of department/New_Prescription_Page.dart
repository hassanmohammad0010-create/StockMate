import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/PrescriptionController.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Prescription_Details_Sheet.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Patient_Search_Field.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Prescription_Card.dart';

class NewPrescriptionPage extends StatelessWidget {
  const NewPrescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PrescriptionController>();
    return Scaffold(
      backgroundColor: constBackgroundColor,

      body: Column(
        children: [
        PatientSearchField(
                onChanged: controller.updateNewRxSearch,
                onClear: () {
                  controller.updateNewRxSearch('');
                },
              ),
          Expanded(
            child: Obx(() {
              final prescriptions = controller.newPrescriptions;

              if (prescriptions.isEmpty) {
                return const _EmptyState(
                  icon: Icons.inbox_outlined,
                  message: 'لا توجد وصفات جديدة مطابقة',
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: prescriptions.length,
                itemBuilder: (context, index) {
                  final prescription = prescriptions[index];
                  return PrescriptionCard(
                    prescription: prescription,
                    onTap: () => showPrescriptionDetails(context, prescription),
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

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: const Color(0xFFD1D5DB)),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
          ),
        ],
      ),
    );
  }
}
