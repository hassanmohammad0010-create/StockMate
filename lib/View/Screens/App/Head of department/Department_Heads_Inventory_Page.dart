// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Cart_Controller.dart';
import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
import 'package:stock_mate_project/Routes/Bindings/App/Inventory_Details_Binding.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Inventory_Details_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Material_Card.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Filter_Bar.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Search_Field.dart';

class DepartmentHeadsInventoryPage extends StatelessWidget {
  const DepartmentHeadsInventoryPage({super.key});

  static const String _filterTag = AppRoutes.DepartmentHeadsInventoryPage;

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    if (!Get.isRegistered<FilterController>(tag: _filterTag)) {
      Get.lazyPut<FilterController>(
        () =>
            FilterController()
              ..initFilters(['الكل', 'ثابتة', 'مستهلكة', 'ادوية']),
        tag: _filterTag,
      );
    }
    final FilterController filterController = Get.find<FilterController>(
      tag: _filterTag,
    );

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentGeometry.centerRight,
            child: CustomFilterBar(
              tag: _filterTag,
              controller: filterController,
              filters: const ['الكل', 'ثابتة', 'مستهلكة', 'ادوية'],
            ),
          ),
          CustomSearchField(
            controller: filterController.searchController,
            onChanged: (value) => filterController.updateSearch(value),
          ),
          Expanded(
            child: Obx(() {
              CartController.to.inventoryVersion.value;
              final String selected = filterController.selectedFilter.value;
              final String query = filterController.searchQuery.value
                  .trim()
                  .toLowerCase();

              List<MaterialItem> material = switch (selected) {
                'الكل' => allMaterial,
                'ثابتة' =>
                  allMaterial
                      .where((o) => o.category == MaterialCategory.fixed)
                      .toList(),
                'مستهلكة' =>
                  allMaterial
                      .where((o) => o.category == MaterialCategory.consumable)
                      .toList(),
                'ادوية' =>
                  allMaterial
                      .where((o) => o.category == MaterialCategory.medicine)
                      .toList(),
                _ => allMaterial,
              };

              if (query.isNotEmpty) {
                material = material
                    .where(
                      (o) =>
                          normalizeArabic(
                            o.name,
                          ).toLowerCase().contains(query) ||
                          normalizeArabic(o.id).toLowerCase().contains(query),
                    )
                    .toList();
              }

              return material.isEmpty
                  ? const SearchEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        vertical: h * 0.005,
                        horizontal: w * 0.01,
                      ),
                      itemCount: material.length,
                      itemBuilder: (context, index) {
                        return MaterialCard(
                          onTap: () {
                            Get.to(
                              () => InventoryDetailsPage(item: material[index]),
                              binding: InventoryDetailsBinding(),
                            );
                          },
                          materialItem: material[index],
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
