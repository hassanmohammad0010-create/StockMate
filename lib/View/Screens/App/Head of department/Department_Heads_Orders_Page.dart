// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
import 'package:stock_mate_project/Controller/Service/Unified_Requests_Controller.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Request_Card.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Filter_Bar.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

class DepartmentOrdersPage extends GetView<FilterController> {
  const DepartmentOrdersPage({super.key, this.initialFilter = 'الكل'});

  final String initialFilter;
  static const String _filterTag = AppRoutes.DepartmentOrdersPage;

  static const List<String> _requiredFilters = [
    'الكل',
    'بانتظار التأكيد',
    'بانتظار موافقة المشفى',
    'بانتظار موافقة المدير',
    'قيد التحضير',
    'منجز جزئي',
    'منجز',
    'مرفوض',
    'ملغي',
    'الطلبات الدورية',
  ];

  @override
  String? get tag => _filterTag;

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    final bool alreadyRegistered = Get.isRegistered<FilterController>(
      tag: _filterTag,
    );

    if (alreadyRegistered) {
      final existing = Get.find<FilterController>(tag: _filterTag);
      final bool filtersMatch = _listsEqual(
        existing.filters.toList(),
        _requiredFilters,
      );

      if (!filtersMatch) {
        Get.delete<FilterController>(tag: _filterTag, force: true);
        _registerFilterController();
      }
    } else {
      _registerFilterController();
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
              if (c.isLoading.value && c.allRequests.isEmpty) {
                return const Center(child: CustomLoadingIndicator());
              }

              if (c.errorMessage.value.isNotEmpty && c.allRequests.isEmpty) {
                return _buildErrorState(c);
              }

              if (c.isDisplayedEmpty) {
                return CustomEmptyState(
                  tital: 'لا يوجد طلبات "${controller.selectedFilter.value}"',
                );
              }

              return RefreshIndicator(
                color: constBlue,
                onRefresh: () => c.fetchAll(),
                child: ListView.builder(
                  controller: c.scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.04,
                    vertical: h * 0.01,
                  ),
                  itemCount:
                      c.filteredRequests.length +
                      (c.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= c.filteredRequests.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: h * 0.02),
                        child: Center(
                          child: SizedBox(
                            width: w * 0.2,
                            height: h * 0.06,
                            child: CustomLoadingIndicator(),
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

  void _registerFilterController() {
    Get.put<FilterController>(
      FilterController()
        ..initFilters(_requiredFilters)
        ..setFilter(initialFilter),
      tag: _filterTag,
    );
  }

  // ─── ✅ مقارنة قائمتين ────────────────────────────────────────────
  bool _listsEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

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
