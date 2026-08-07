import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Get_Departments_Controller.dart';
import 'package:stock_mate_project/Controller/Logic/Toggle_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Display_Consunble_Inventory_Materials_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Display_Fixed_Inventory_Materials_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Display_Medicine_Inventory_Materials_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Display_Stock_Material_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_ListTile.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Toggle_Buttom.dart';

class InventoryPage extends StatelessWidget {
  InventoryPage({super.key});

  final ToggleController controller = Get.put(
    ToggleController(),
    tag: 'InventoryPage',
  );
  GetDepartmentsController getDepartmentsController = Get.put(
    GetDepartmentsController(),
  );
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.pageController.jumpToPage(controller.selectedIndex.value);
    });
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Get.delete<ToggleController>(tag: 'InventoryPage');
        }
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.screenWidth * 0.02, // ← بدل 8
                vertical: context.screenHeight * 0.01, // ← بدل 8
              ),
              child: Align(
                alignment: AlignmentGeometry.topRight,
                child: CustomToggleButtom(
                  first: 'المستودع',
                  second: 'المخازن',
                  controller: controller,
                ),
              ),
            ),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller.pageController,
                children: [
                  Column(
                    children: [
                      CustomListTile(
                        backgroundColor: constLightBlue,
                        description: 'عرض المواد الطبية المتوفرة',
                        icon: Icons.medical_services_rounded,
                        iconColor: constBlue,
                        onTap: () {
                          Get.to(() => DisplayConsunbleInventoryMaterials());
                        },
                        title: 'مستهلكة',
                      ),
                      CustomListTile(
                        backgroundColor: constLightBlue,
                        description: 'عرض الاجهزة المتوفرة ',
                        icon: Icons.devices_rounded,
                        iconColor: constBlue,
                        onTap: () {
                          Get.to(() => DisplayFixedInventoryMaterials());
                        },
                        title: 'ثابتة',
                      ),
                      CustomListTile(
                        backgroundColor: constLightBlue,
                        description: 'عرض الادوية المتوفرة ',
                        icon: Icons.medication_liquid_rounded,
                        iconColor: constBlue,
                        onTap: () {
                          Get.to(() => DisplayMedicineInventoryMaterials());
                        },
                        title: 'الادوية',
                      ),
                    ],
                  ),
                  GetBuilder<GetDepartmentsController>(
                    builder: (controller) {
                      return controller.department == null
                          ? CustomLoadingIndicator()
                          : controller.department!.isEmpty
                          ? CustomEmptyState(tital: 'لا يوجد اقسام لعرضها')
                          : ListView.builder(
                              padding: EdgeInsets.only(
                                top: 0,
                                bottom: context.screenHeight * 0.01, // ← بدل 8
                              ),
                              itemCount: controller.department!.length,
                              itemBuilder: (context, index) {
                                return CustomListTile(
                                  backgroundColor: constLightBlue,
                                  description:
                                      controller
                                          .department![index]
                                          .managerName ??
                                      'لا يوجد رئيس للقسم',
                                  icon: Icons.category,
                                  iconColor: constBlue,
                                  onTap: () {
                                    Get.to(() => DisplayStockMaterialPage());
                                  },
                                  title: controller.department![index].name,
                                );
                              },
                            );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
