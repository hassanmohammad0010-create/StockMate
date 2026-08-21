// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Request_Card.dart';
import 'package:stock_mate_project/Controller/Service/Unified_Requests_Controller.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Filter_Bar.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

class DepartmentOrdersPage extends GetView<FilterController> {
  const DepartmentOrdersPage({super.key, this.initialFilter = 'الكل'});

  final String initialFilter;
  static const String _filterTag = AppRoutes.DepartmentOrdersPage;

  @override
  String? get tag => _filterTag;

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    // ✅ فلاتر جديدة — كل حالة enum لوحدها + بانتظار التأكيد (بدون draft)
    if (!Get.isRegistered<FilterController>(tag: _filterTag)) {
      Get.put<FilterController>(
        FilterController()
          ..initFilters([
            'الكل',
            'بانتظار التأكيد',
            'بانتظار موافقة المشفى',
            'بانتظار موافقة المدير',
            'قيد التحضير',
            'مكتمل جزئي',
            'مكتمل',
            'مرفوض مشفى',
            'مرفوض مدير',
            'ملغي',
            'الطلبات الدورية',
          ])
          ..setFilter(initialFilter),
        tag: _filterTag,
      );
    }

    final c = Get.put(
      UnifiedRequestsController(filterTag: _filterTag),
      tag: _filterTag,
    );

    c.bindFilter();

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          Align(
            alignment: AlignmentGeometry.centerRight,
            child: CustomFilterBar(controller: controller),
          ),
          Expanded(
            child: Obx(() {
              // ✅ حالة التحميل الأول
              if (c.isLoading.value && c.allRequests.isEmpty) {
                return const Center(child: CustomLoadingIndicator());
              }

              // ✅ حالة الخطأ
              if (c.errorMessage.value.isNotEmpty && c.allRequests.isEmpty) {
                return _buildErrorState(c);
              }

              // ✅ حالة القائمة الفارغة
              if (c.isDisplayedEmpty) {
                return _buildEmptyState(c);
              }

              // ✅ القائمة المفلترة مع ScrollController + تحميل تلقائي
              return RefreshIndicator(
                color: constBlue,
                onRefresh: () => c.fetchAll(),
                child: ListView.builder(
                  controller: c.scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.04,
                    vertical: h * 0.01,
                  ),
                  // ✅ +1 فقط إذا كنا نحمل حالياً (CircularProgressIndicator)
                  itemCount:
                      c.filteredRequests.length +
                      (c.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    // ✅ Footer: مؤشر تحميل فقط (بدون زر)
                    if (index >= c.filteredRequests.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: constBlue,
                            ),
                          ),
                        ),
                      );
                    }

                    final request = c.filteredRequests[index];
                    final pendingDeliveries = c.getPendingDeliveries(
                      request.id,
                    );
                    return RequestCard(
                      request: request,
                      pendingDeliveries: pendingDeliveries,
                      onTap: () => c.openRequestDetails(request),
                      onConfirmDelivery: pendingDeliveries.isNotEmpty
                          ? () {
                              final firstDelivery = c.getFirstPendingDelivery(
                                request.id,
                              );
                              if (firstDelivery != null) {
                                c.openDeliveryConfirm(firstDelivery.id);
                              }
                            }
                          : null,
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

  // ─── حالة القائمة الفارغة (ذكية) ──────────────────────────────────
  Widget _buildEmptyState(UnifiedRequestsController c) {
    // ✅ إذا كنا نحمل تلقائياً (صفحات إضافية)
    if (c.isLoadingMore.value) {
      return const Center(child: CustomLoadingIndicator());
    }

    // ✅ إذا وصلنا للنهاية ولا توجد نتائج
    if (!c.hasMore) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              c.currentFilter.value == 'الكل'
                  ? 'لا توجد طلبات بعد'
                  : c.currentFilter.value == 'بانتظار التأكيد'
                  ? 'لا توجد طلبات بانتظار التأكيد'
                  : 'لا توجد طلبات تحت فلتر "${c.currentFilter.value}"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF6B7280),
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      );
    }

    // ✅ إذا كانت النتائج فارغة لكن هناك صفحات أخرى (يحمل تلقائياً)
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(strokeWidth: 2, color: constBlue),
          ),
          const SizedBox(height: 16),
          Text(
            'جارٍ البحث في الصفحات التالية...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  // ─── حالة الخطأ + إعادة المحاولة ──────────────────────────────────
  Widget _buildErrorState(UnifiedRequestsController c) {
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
              color: constGray,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => c.fetchAll(),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('إعادة المحاولة'),
            style: TextButton.styleFrom(foregroundColor: constBlue),
          ),
        ],
      ),
    );
  }
}
