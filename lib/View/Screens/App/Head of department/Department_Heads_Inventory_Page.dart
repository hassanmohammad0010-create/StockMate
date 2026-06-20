// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Cart_Controller.dart';
import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Inventory_Details_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Material_Card.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Filter_Bar.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Search_Field.dart';

class DepartmentHeadsInventoryPage extends StatefulWidget {
  const DepartmentHeadsInventoryPage({super.key});

  @override
  State<DepartmentHeadsInventoryPage> createState() =>
      _DepartmentHeadsInventoryPageState();
}

class _DepartmentHeadsInventoryPageState
    extends State<DepartmentHeadsInventoryPage> {
  final FilterController filterController = Get.put(
    FilterController(),
    tag: AppRoutes.DepartmentHeadsInventoryPage,
  );

  @override
  void initState() {
    super.initState();
    filterController.initFilters(['الكل', 'ثابتة', 'مستهلكة', 'ادوية']);
  }

  @override
  void dispose() {
    Get.delete<FilterController>(tag: AppRoutes.DepartmentHeadsInventoryPage);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentGeometry.centerRight,
            child: CustomFilterBar(
              tag: AppRoutes.DepartmentHeadsInventoryPage,
              filters: const ['الكل', 'ثابتة', 'مستهلكة', 'ادوية'],
            ),
          ),
          CustomSearchField(),
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
                          CustomSearchField()
                              .normalizeArabic(o.name)
                              .toLowerCase()
                              .contains(query) ||
                          CustomSearchField()
                              .normalizeArabic(o.id)
                              .toLowerCase()
                              .contains(query),
                    )
                    .toList();
              }

              return material.isEmpty
                  ? CustomSearchField().buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 0, bottom: 12),
                      itemCount: material.length,
                      itemBuilder: (context, index) {
                        return MaterialCard(
                          onTap: () {
                            Get.to(
                              () => InventoryDetailsPage(
                                item: material[index],
                              ),
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
