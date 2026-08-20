// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Service/Refill_Deliveries_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Refill_Delivery_Details_Page.dart';
import 'package:stock_mate_project/core/models/Refill_Delivery_Model.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

class RefillDeliveriesPage extends StatelessWidget {
  const RefillDeliveriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    final c = Get.put(RefillDeliveriesController(), tag: 'deliveries');

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          const CustomBackContainer(),

          // ── الهيدر ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.04),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'سجل التسليمات',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: constColor,
                    ),
                  ),
                ),
                Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: constLightGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${c.total.value}',
                      style: const TextStyle(
                        color: constGreen,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: h * 0.015),

          // ── القائمة ─
          Expanded(
            child: Obx(() {
              if (c.isLoading.value && c.deliveries.isEmpty) {
                return const Center(child: CustomLoadingIndicator());
              }

              if (c.errorMessage.value.isNotEmpty && c.deliveries.isEmpty) {
                return _buildErrorState(c);
              }

              if (c.deliveries.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                color: constBlue,
                onRefresh: () => c.fetchDeliveries(),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                  itemCount: c.deliveries.length + (c.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= c.deliveries.length) {
                      return _buildLoadMoreFooter(c);
                    }
                    final delivery = c.deliveries[index];
                    return _DeliveryCard(
                      delivery: delivery,
                      index: index + 1,
                      onTap: () => Get.to(
                        () =>
                            RefillDeliveryDetailsPage(deliveryId: delivery.id),
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

  Widget _buildLoadMoreFooter(RefillDeliveriesController c) {
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_shipping_outlined,
            size: 70,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 12),
          const Text(
            'لا توجد تسليمات مسجلة',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Cairo',
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(RefillDeliveriesController c) {
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
            onPressed: () => c.fetchDeliveries(),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('إعادة المحاولة'),
            style: TextButton.styleFrom(foregroundColor: constBlue),
          ),
        ],
      ),
    );
  }
}

// ─── كارد تسليم واحد ───────────────────────────────────────────────
class _DeliveryCard extends StatelessWidget {
  final RefillDelivery delivery;
  final int index;
  final VoidCallback onTap;

  const _DeliveryCard({
    required this.delivery,
    required this.index,
    required this.onTap,
  });

  Color get _typeColor => delivery.type.isFinal ? constGreen : constBlue;

  Color get _typeBg => delivery.type.isFinal ? constLightGreen : constLightBlue;

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: h * 0.005),
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.04,
            vertical: h * 0.015,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الشريط الجانبي الملون
              Container(
                width: w * 0.01,
                height: h * 0.07,
                decoration: BoxDecoration(
                  color: _typeColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(width: w * 0.03),

              // أيقونة التسليم
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _typeBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  delivery.type.isFinal
                      ? Icons.done_all_rounded
                      : Icons.local_shipping_outlined,
                  color: _typeColor,
                  size: 22,
                ),
              ),
              SizedBox(width: w * 0.03),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── الصف الأول: العنوان + شارة النوع ──
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'تسليم #$index',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: w * 0.02,
                            vertical: h * 0.004,
                          ),
                          decoration: BoxDecoration(
                            color: _typeBg,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            delivery.type.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _typeColor,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.008),

                    // ── الصف الثاني: تاريخ التسليم ──
                    Row(
                      children: [
                        Icon(
                          Icons.local_shipping_outlined,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'التسليم: ${delivery.formattedDeliveredAt}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.005),

                    // ── الصف الثالث: تاريخ التأكيد + معرف الطلب ──
                    Row(
                      children: [
                        Icon(
                          Icons.verified_outlined,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'التأكيد: ${delivery.formattedConfirmedAt}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const Spacer(),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            '#${delivery.shortRequestId}',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade400,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
