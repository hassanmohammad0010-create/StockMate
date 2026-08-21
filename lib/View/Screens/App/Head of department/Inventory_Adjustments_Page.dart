// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Inventory_Adjustment_Details_Page.dart';
import 'package:stock_mate_project/Controller/Service/Inventory_Adjustments_Controller.dart';
import 'package:stock_mate_project/core/models/Inventory_Adjustments_Model.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/custom_Head_Card.dart';

class InventoryAdjustmentsPage extends StatelessWidget {
  const InventoryAdjustmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    final c = Get.put(InventoryAdjustmentsController(), tag: 'adjustments');

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          const CustomBackContainer(),
          SizedBox(height: h * 0.005),
          CustomHeadContainer(
            title: 'سجل التسويات والإتلاف',
            trailing: Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: constLightBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${c.total.value}',
                  style: const TextStyle(
                    color: constBlue,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: h * 0.015),

          Expanded(
            child: Obx(() {
              if (c.isLoading.value && c.adjustments.isEmpty) {
                return const Center(child: CustomLoadingIndicator());
              }

              if (c.errorMessage.value.isNotEmpty && c.adjustments.isEmpty) {
                return _buildErrorState(c);
              }

              if (c.adjustments.isEmpty) {
                return CustomEmptyState(tital: 'لا يوجد مواد تالفة');
              }

              return RefreshIndicator(
                color: constBlue,
                onRefresh: () => c.fetchAdjustments(),
                child: ListView.builder(
                  // ✅ نفس ScrollController المُدار داخل الكونترولر
                  controller: c.scrollController,
                  padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                  itemCount: c.adjustments.length + (c.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= c.adjustments.length) {
                      return _buildLoadMoreFooter(c);
                    }
                    final adjustment = c.adjustments[index];
                    return _AdjustmentCard(
                      adjustment: adjustment,
                      onTap: () => Get.to(
                        () => InventoryAdjustmentDetailsPage(
                          adjustment: adjustment,
                        ),
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

  Widget _buildLoadMoreFooter(InventoryAdjustmentsController c) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: c.isLoadingMore.value
            ? const Center(child: CustomLoadingIndicator())
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildErrorState(InventoryAdjustmentsController c) {
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
            onPressed: () => c.fetchAdjustments(),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('إعادة المحاولة'),
            style: TextButton.styleFrom(foregroundColor: constBlue),
          ),
        ],
      ),
    );
  }
}

class _AdjustmentCard extends StatelessWidget {
  final InventoryAdjustment adjustment;
  final VoidCallback onTap;

  const _AdjustmentCard({required this.adjustment, required this.onTap});

  Color get _typeColor {
    switch (adjustment.adjustmentType) {
      case AdjustmentType.expired:
        return constRed;
      case AdjustmentType.damaged:
        return constOrange;
      case AdjustmentType.shrinkage:
        return constGray;
      case AdjustmentType.found:
        return constGreen;
    }
  }

  Color get _typeBg {
    switch (adjustment.adjustmentType) {
      case AdjustmentType.expired:
        return constLightRed;
      case AdjustmentType.damaged:
        return constLightOrange;
      case AdjustmentType.shrinkage:
        return const Color(0xFFF3F4F6);
      case AdjustmentType.found:
        return constLightGreen;
    }
  }

  IconData get _typeIcon {
    switch (adjustment.adjustmentType) {
      case AdjustmentType.expired:
        return Icons.event_busy_outlined;
      case AdjustmentType.damaged:
        return Icons.broken_image_outlined;
      case AdjustmentType.shrinkage:
        return Icons.remove_circle_outline;
      case AdjustmentType.found:
        return Icons.add_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: h * 0.005),
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.04,
            vertical: h * 0.015,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
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
              Container(
                width: w * 0.01,
                height: h * 0.08,
                decoration: BoxDecoration(
                  color: _typeColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(width: w * 0.03),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            adjustment.displayName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                              fontFamily: 'Cairo',
                            ),
                            overflow: TextOverflow.ellipsis,
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
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_typeIcon, size: 13, color: _typeColor),
                              const SizedBox(width: 4),
                              Text(
                                adjustment.adjustmentType.label,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _typeColor,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.008),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _typeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _typeColor.withOpacity(0.3),
                            ),
                          ),
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              '${adjustment.quantity} ${adjustment.unitAbbreviation}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: _typeColor,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'دفعة: ${adjustment.batchNumber}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                              fontFamily: 'Cairo',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.008),

                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 13,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          adjustment.formattedDateOnly,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        SizedBox(width: w * 0.3),
                        Icon(
                          Icons.person_outline,
                          size: 13,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            adjustment.reportedByName,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                              fontFamily: 'Cairo',
                            ),
                            overflow: TextOverflow.ellipsis,
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
