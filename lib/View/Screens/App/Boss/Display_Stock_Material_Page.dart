import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Display_Material_Info_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Material_Card.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Filter_Bar.dart';

class DisplayStockMaterialPage extends StatelessWidget {
  DisplayStockMaterialPage({super.key}) {
    // ✅ تسجيل واحد فقط مع tag
    filterController.initFilters(['الكل', 'ثابتة', 'مستهلكة', 'ادوية']);
  }

  // ✅ Controller واحد مع tag موحد
  final FilterController filterController = Get.put(
    FilterController(),
    tag: 'DisplayStockPage',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomBackContainer(),

          Align(
            alignment: AlignmentGeometry.centerRight,
            child: CustomFilterBar(
              tag: 'DisplayStockPage',
              filters: const ['الكل', 'ثابتة', 'مستهلكة', 'ادوية'],
            ),
          ),
          Expanded(
            child: Obx(() {
              // ✅ selectedFilter.value داخل Obx مباشرة = reactive
              final String selected = filterController.selectedFilter.value;

              final List<MaterialItem> material = switch (selected) {
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

              return material.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.only(top: 0, bottom: 12),
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
                    );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'لا توجد طلبات',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
