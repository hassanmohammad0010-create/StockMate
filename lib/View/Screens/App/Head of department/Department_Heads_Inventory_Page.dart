// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Live_Stock_Material_Controller.dart';
import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Display_Material_Info_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Material_Card.dart';
import 'package:stock_mate_project/core/models/New_MaterialItem.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Search_Field.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Filter_Bar.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

class DepartmentHeadsInventoryPage extends StatelessWidget {
  // ✅ الكونستركتور فارغ تمامًا الآن — لا شيء ينفذ هنا.
  // كل منطق Get.put وتهيئة الفلاتر انتقل إلى build() (بنفس نمط DepartmentOrdersPage)
  // عشان ما يصطدم بقاعدة "ممنوع تعديل حالة GetX أثناء بناء شجرة الأب"
  // عند فتح هذه الصفحة من داخل Obx (مثل صفحة الإشعارات).
   DepartmentHeadsInventoryPage({super.key, required this.departmentId});

  final String departmentId;

  final RxString searchQuery =  RxString('');

  static const String _filterTag = AppRoutes.DepartmentHeadsInventoryPage;

  @override
  Widget build(BuildContext context) {
    // ✅ 1) الفلتر: أنشئه فقط لو مو مسجل مسبقاً
    if (!Get.isRegistered<FilterController>(tag: _filterTag)) {
      Get.put<FilterController>(
        FilterController()..initFilters(['الكل', 'ثابتة', 'مستهلكة']),
        tag: _filterTag,
      );
    }
    final FilterController filterController = Get.find<FilterController>(
      tag: _filterTag,
    );

    // ✅ 2) كونترولر المخزون: tag فريد لكل قسم
    if (!Get.isRegistered<LiveStockController>(tag: departmentId)) {
      Get.put(
        LiveStockController(departmentId: departmentId),
        tag: departmentId,
      );
    }
    final LiveStockController controller = Get.find<LiveStockController>(
      tag: departmentId,
    );

    final TextEditingController searchController = TextEditingController();

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Get.delete<FilterController>(tag: _filterTag);
          Get.delete<LiveStockController>(tag: departmentId);
        }
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: AlignmentGeometry.centerRight,
              child: CustomFilterBar(controller: filterController),
            ),
            CustomSearchField(
              controller: searchController,
              onChanged: (value) {
                searchQuery.value = normalizeArabic(value.trim());
              },
              onClear: () {
                searchQuery.value = '';
              },
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CustomLoadingIndicator());
                }

                final String selected = filterController.selectedFilter.value;
                final String query = searchQuery.value;

                final List<MaterialItem> filteredByCategory =
                    switch (selected) {
                      'الكل' => controller.allMaterials,
                      'ثابتة' =>
                        controller.allMaterials
                            .where((o) => o.category == MaterialCategory.fixed)
                            .toList(),
                      'مستهلكة' =>
                        controller.allMaterials
                            .where(
                              (o) =>
                                  o.category == MaterialCategory.consumable ||
                                  o.category == MaterialCategory.medicine,
                            )
                            .toList(),
                      _ => controller.allMaterials,
                    };

                final List<MaterialItem> material = query.isEmpty
                    ? filteredByCategory
                    : filteredByCategory
                          .where((o) => normalizeArabic(o.name).contains(query))
                          .toList();

                return material.isEmpty
                    ? CustomEmptyState(tital: 'لا يوجد مواد لعرضها')
                    : RefreshIndicator(
                        onRefresh: controller.refreshMaterials,
                        child: ListView.builder(
                          padding: EdgeInsets.only(
                            top: 0,
                            bottom: context.screenHeight * 0.015,
                          ),
                          itemCount: material.length,
                          itemBuilder: (context, index) {
                            return MaterialCard(
                              onTap: () {
                                Get.to(
                                  () => DisplayMaterialInfoPage(
                                    item: material[index],
                                  ),
                                );
                              },
                              materialItem: material[index],
                            );
                          },
                        ),
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }
}