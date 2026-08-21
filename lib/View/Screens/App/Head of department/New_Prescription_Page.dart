// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Prescription_Card.dart';
import 'package:stock_mate_project/Controller/Service/Pharmacy_Dispense_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Prescription_Details_Page.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Patient_Search_Field.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

class NewPrescriptionPage extends StatelessWidget {
  const NewPrescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;

    // ✅ استخدام PharmacyDispenseController مع status='ready'
    final controller = Get.put(
      PharmacyDispenseController(statuses: const ['ready']),
      tag: 'newPrescriptions',
    );

    // ✅ متغير محلي للبحث
    final searchQuery = ''.obs;

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          // ── حقل البحث ──
          PatientSearchField(
            onChanged: (query) => searchQuery.value = query,
            onClear: () => searchQuery.value = '',
          ),

          // ── قائمة الوصفات الجاهزة ──
          Expanded(
            child: Obx(() {
              // ✅ حالة التحميل الأول
              if (controller.isLoading.value &&
                  controller.prescriptions.isEmpty) {
                return const Center(child: CustomLoadingIndicator());
              }

              // ✅ حالة الخطأ
              if (controller.errorMessage.value.isNotEmpty &&
                  controller.prescriptions.isEmpty) {
                return _buildErrorState(controller);
              }

              // ✅ فلترة محلية حسب نص البحث
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

              // ✅ حالة القائمة الفارغة (بعد الفلترة)
              if (filtered.isEmpty) {
                return _EmptyState(
                  icon: controller.prescriptions.isEmpty
                      ? Icons.inbox_outlined
                      : Icons.search_off_outlined,
                  message: controller.prescriptions.isEmpty
                      ? 'لا توجد وصفات جاهزة للصرف'
                      : 'لا توجد وصفات مطابقة للبحث',
                );
              }

              // ✅ القائمة
              return RefreshIndicator(
                color: constBlue,
                onRefresh: () => controller.fetchPrescriptions(),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: h * 0.005),
                  itemCount: filtered.length + (controller.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    // فوتر تحميل المزيد
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

  // ─── فوتر تحميل المزيد ────────────────────────────────────────────
  Widget _buildLoadMoreFooter(PharmacyDispenseController c) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: c.isLoadingMore.value
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: TextButton(
                  onPressed: c.loadMore,
                  child: const Text(
                    'تحميل المزيد',
                    style: TextStyle(
                      color: constBlue,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  // ─── حالة الخطأ ───────────────────────────────────────────────────
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

// ─── حالة فارغة ────────────────────────────────────────────────────
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
          Icon(icon, size: 64, color: const Color(0xFFD1D5DB)),
          SizedBox(height: context.screenHeight * 0.01),
          Text(
            message,
            style: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 14,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}
