// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Cart_Controller.dart';
import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
import 'package:stock_mate_project/core/Bindings/App/Inventory_Details_Binding.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Inventory_Details_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Material_Card.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Filter_Bar.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Search_Field.dart';

class DepartmentHeadsInventoryPage extends GetView<FilterController> {
  const DepartmentHeadsInventoryPage({super.key});

  static const String _filterTag = AppRoutes.DepartmentHeadsInventoryPage;

  // تعريف الـ Tag ليتعرف GetView على الكونترولر الصحيح
  @override
  String? get tag => _filterTag;

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    // تسجيل الكونترولر مع الفلاتر المطلوبة لهذه الصفحة فقط
    if (!Get.isRegistered<FilterController>(tag: _filterTag)) {
      Get.put<FilterController>(
        FilterController()..initFilters(['الكل', 'ثابتة', 'مستهلكة']),
        tag: _filterTag,
      );
    }

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentGeometry.centerRight,
            child: CustomFilterBar(controller: controller),
          ),
          CustomSearchField(
            controller: controller.searchController,
            onChanged: (value) => controller.updateSearch(value),
          ),
          Expanded(
            child: Obx(() {
              // لتحديث القائمة عند تغيير نسخة المخزون
              CartController.to.inventoryVersion.value;

              final String selected = controller.selectedFilter.value;
              final String query = controller.searchQuery.value
                  .trim()
                  .toLowerCase();

              // === منطق الفلترة حسب النوع (خاص بهذه الصفحة فقط) ===
              List<MaterialItem> filteredMaterial = switch (selected) {
                'ثابتة' =>
                  allMaterial
                      .where((o) => o.category == MaterialCategory.fixed)
                      .toList(),
                'مستهلكة' =>
                  allMaterial
                      .where(
                        (o) =>
                            o.category == MaterialCategory.consumable ||
                            o.category == MaterialCategory.medicine,
                      )
                      .toList(),
                // 'الكل' أو أي قيمة أخرى
                _ => allMaterial,
              };

              // === منطق البحث النصي ===
              if (query.isNotEmpty) {
                filteredMaterial = filteredMaterial
                    .where(
                      (o) =>
                          normalizeArabic(
                            o.name,
                          ).toLowerCase().contains(query) ||
                          normalizeArabic(o.id).toLowerCase().contains(query),
                    )
                    .toList();
              }

              // === عرض النتائج ===
              return filteredMaterial.isEmpty
                  ? const SearchEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        vertical: h * 0.005,
                        horizontal: w * 0.01,
                      ),
                      itemCount: filteredMaterial.length,
                      itemBuilder: (context, index) {
                        final item = filteredMaterial[index];
                        return MaterialCard(
                          onTap: () {
                            Get.to(
                              () => InventoryDetailsPage(item: item),
                              binding: InventoryDetailsBinding(),
                            );
                          },
                          materialItem: item,
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
