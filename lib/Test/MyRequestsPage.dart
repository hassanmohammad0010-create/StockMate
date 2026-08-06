// ignore_for_file: sized_box_for_whitespace, file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Test/MyRequestsController.dart';
import 'package:stock_mate_project/Test/RequestCard.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/custom_Head_Card.dart';

class MyRequestsPage extends StatelessWidget {
  const MyRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    final c = Get.put(MyRequestsController());

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          const CustomBackContainer(),
          const CustomHeadContainer(title: 'سجل الطلبات'),
          SizedBox(height: h * 0.015),

          Expanded(
            child: Obx(() {
              // ✅ حالة التحميل الأول
              if (c.isLoading.value && c.requests.isEmpty) {
                return const Center(child: CustomLoadingIndicator());
              }

              // ✅ حالة الخطأ
              if (c.errorMessage.value.isNotEmpty && c.requests.isEmpty) {
                return _buildErrorState(c);
              }

              // ✅ حالة القائمة الفارغة
              if (c.requests.isEmpty) {
                return _buildEmptyState();
              }

              // ✅ القائمة
              return RefreshIndicator(
                color: constBlue,
                onRefresh: () => c.fetchRequests(),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.04,
                    vertical: h * 0.01,
                  ),
                  itemCount: c.requests.length + (c.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    // ✅ فوتر "تحميل المزيد"
                    if (index >= c.requests.length) {
                      return _buildLoadMoreFooter(c);
                    }
                    final request = c.requests[index];
                    return OrderCard2(
                      request: request,
                      onTap: () => c.openRequestDetails(request),
                    );
                    // RequestCard(
                    //   request: request,
                    //   onTap: () => c.openRequestDetails(request),
                    // );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ─── قائمة فارغة ──────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text(
            'لا توجد طلبات بعد',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Cairo',
              color: constGray,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'قم بإنشاء طلب جديد وسيظهر هنا',
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Cairo',
              color: constGray,
            ),
          ),
        ],
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
}
