// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Live_Stock_Material_Controller.dart';
import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Display_Material_Info_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Material_Card.dart';
import 'package:stock_mate_project/core/models/New_MaterialItem.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Search_Field.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Filter_Bar.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

class DepartmentHeadsInventoryPage extends StatelessWidget {
  DepartmentHeadsInventoryPage({super.key, required this.departmentId}) {
    filterController.initFilters(['الكل', 'ثابتة', 'مستهلكة']);
  }

  final String departmentId;

  final FilterController filterController = Get.put(
    FilterController(),
    tag: 'DisplayStockPage',
  );

  late final LiveStockController controller = Get.put(
    LiveStockController(departmentId: departmentId),
    tag:
        departmentId, // ✅ tag فريد لكل قسم، عشان كل قسم ياخد Controller خاص بيه
  );

  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Get.delete<FilterController>(tag: 'DisplayStockPage');
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
                              (o) => o.category == MaterialCategory.consumable,
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
