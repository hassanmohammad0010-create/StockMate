// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
import 'package:stock_mate_project/Controller/Service/Get_Requests_Controller.dart';
import 'package:stock_mate_project/core/utils/New_Customs/RequestCard.dart';
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

    // ✅ 1) أولاً: سجّل FilterController (قبل الكونترولر الآخر)
    if (!Get.isRegistered<FilterController>(tag: _filterTag)) {
      Get.put<FilterController>(
        FilterController()
          ..initFilters([
            'الكل',
            'منجز',
            'طلبات مستلمة',
            'معلق',
            'قيد التنفيذ',
            'الطلبات الدورية',
            'مرفوض',
          ])
          ..setFilter(initialFilter),
        tag: _filterTag,
      );
    }

    // ✅ 2) ثانياً: أنشئ MyRequestsController (ليجد الفلتر في onInit)
    final c = Get.put(
      MyRequestsController(filterTag: _filterTag),
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

              // ✅ حالة القائمة الفارغة (بعد الفلترة)
              if (c.isDisplayedEmpty) {
                return Column(
                  children: [
                    Expanded(
                      child: _buildEmptyState(c.currentFilter.value, c.hasMore),
                    ),
                    // ✅ إذا كانت توجد صفحات غير محمّلة، يبقى زر "تحميل المزيد" ظاهراً
                    if (c.hasMore) _buildLoadMoreFooter(c),
                    const SizedBox(height: 12),
                  ],
                );
              }

              // ✅ القائمة المفلترة + فوتر تحميل المزيد
              return RefreshIndicator(
                color: constBlue,
                onRefresh: () => c.fetchRequests(),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.04,
                    vertical: h * 0.01,
                  ),
                  itemCount: c.filteredRequests.length + (c.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    // ✅ فوتر "تحميل المزيد"
                    if (index >= c.filteredRequests.length) {
                      return _buildLoadMoreFooter(c);
                    }
                    final request = c.filteredRequests[index];
                    return OrderCard2(
                      request: request,
                      onTap: () => c.openRequestDetails(request),
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

  // ─── حالة القائمة الفارغة (رسالة ذكية حسب الفلتر والصفحات) ────────
  Widget _buildEmptyState(String currentFilter, bool hasMore) {
    final String message;

    if (currentFilter == 'الكل') {
      message = 'لا توجد طلبات بعد';
    } else if (hasMore) {
      // ✅ لا نتائج ضمن المحمّل، لكن قد توجد في صفحات أخرى
      message =
          'لا توجد نتائج ضمن الطلبات المحمّلة\nاضغط "تحميل المزيد" للبحث في الصفحات التالية';
    } else {
      message = 'لا توجد طلبات تحت فلتر "$currentFilter"';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            message,
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

  // ─── فوتر تحميل المزيد ────────────────────────────────────────────
  Widget _buildLoadMoreFooter(MyRequestsController c) {
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

  // ─── حالة الخطأ + إعادة المحاولة ──────────────────────────────────
  Widget _buildErrorState(MyRequestsController c) {
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
            onPressed: () => c.fetchRequests(),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('إعادة المحاولة'),
            style: TextButton.styleFrom(foregroundColor: constBlue),
          ),
        ],
      ),
    );
  }
}

// // ignore_for_file: file_names

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:stock_mate_project/Constant/Const.dart';
// import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
// import 'package:stock_mate_project/Controller/Service/Get_Requests_Controller.dart';
// import 'package:stock_mate_project/core/router/app_routes.dart';
// import 'package:stock_mate_project/core/utils/New_Customs/RequestCard.dart';
// import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Filter_Bar.dart';
// import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

// class DepartmentOrdersPage extends GetView<FilterController> {
//   const DepartmentOrdersPage({super.key, this.initialFilter = 'الكل'});

//   final String initialFilter;
//   static const String _filterTag = AppRoutes.DepartmentOrdersPage;

//   @override
//   String? get tag => _filterTag;

//   @override
//   Widget build(BuildContext context) {
//     final h = context.screenHeight;
//     final w = context.screenWidth;

//     final bool isFirstBuild = !Get.isRegistered<MyRequestsController>();
//     final c = Get.put(MyRequestsController());

//     if (!Get.isRegistered<FilterController>(tag: _filterTag)) {
//       Get.put<FilterController>(
//         FilterController()
//           ..initFilters([
//             'الكل',
//             'منجز',
//             'طلبات مستلمة',
//             'معلق',
//             'قيد التنفيذ',
//             'الطلبات الدورية',
//             'مرفوض',
//           ])
//           ..setFilter(initialFilter),
//         tag: _filterTag,
//       );
//     }

//     // ✅✅✅ الربط الأساسي المفقود سابقاً: نربط الفلتر بالكونترولر مرة واحدة
//     // فقط (عند أول إنشاء لـ MyRequestsController)، لتفادي تسجيل مستمع ever()
//     // جديد مع كل إعادة بناء لهذه الصفحة (build() قد يُستدعى عدة مرات).
//     if (isFirstBuild) {
//       c.bindToFilter(controller);
//     }

//     return Scaffold(
//       backgroundColor: constBackgroundColor,
//       body: Column(
//         children: [
//           Align(
//             alignment: AlignmentGeometry.centerRight,
//             child: CustomFilterBar(controller: controller),
//           ),
//           Expanded(
//             child: Obx(() {
//               // ✅ حالة التحميل الأول
//               if (c.isLoading.value && c.requests.isEmpty) {
//                 return const Center(child: CustomLoadingIndicator());
//               }

//               // ✅ حالة الخطأ
//               if (c.errorMessage.value.isNotEmpty && c.requests.isEmpty) {
//                 return _buildErrorState(c);
//               }

//               // ✅ حالة القائمة الفارغة
//               if (c.requests.isEmpty) {
//                 return _buildEmptyState();
//               }

//               // ✅ القائمة
//               return RefreshIndicator(
//                 color: constBlue,
//                 onRefresh: () => c.fetchRequests(),
//                 child: ListView.builder(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: w * 0.04,
//                     vertical: h * 0.01,
//                   ),
//                   itemCount: c.requests.length + (c.hasMore ? 1 : 0),
//                   itemBuilder: (context, index) {
//                     // ✅ فوتر "تحميل المزيد"
//                     if (index >= c.requests.length) {
//                       return _buildLoadMoreFooter(c);
//                     }
//                     final request = c.requests[index];
//                     return OrderCard2(
//                       request: request,
//                       onTap: () => c.openRequestDetails(request),
//                     );
//                   },
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade300),
//           const SizedBox(height: 16),
//           Text(
//             'لا توجد طلبات',
//             style: TextStyle(fontSize: 18, color: Colors.grey.shade500),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoadMoreFooter(MyRequestsController c) {
//     return Obx(
//       () => Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         child: c.isLoadingMore.value
//             ? const Center(child: CircularProgressIndicator())
//             : Center(
//                 child: TextButton(
//                   onPressed: c.loadMore,
//                   child: const Text(
//                     'تحميل المزيد',
//                     style: TextStyle(
//                       color: constBlue,
//                       fontFamily: 'Cairo',
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }

//   Widget _buildErrorState(MyRequestsController c) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.cloud_off_outlined, size: 70, color: Colors.grey.shade400),
//           const SizedBox(height: 12),
//           Text(
//             c.errorMessage.value,
//             style: const TextStyle(
//               fontSize: 14,
//               fontFamily: 'Cairo',
//               color: constGray,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 12),
//           TextButton.icon(
//             onPressed: () => c.fetchRequests(),
//             icon: const Icon(Icons.refresh, size: 18),
//             label: const Text('إعادة المحاولة'),
//             style: TextButton.styleFrom(foregroundColor: constBlue),
//           ),
//         ],
//       ),
//     );
//   }
// }