import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Toggle_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Dispaly_Consumable_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Display_Fixed_Assets_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Display_Medicine_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_ListTile.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Toggle_Buttom.dart';

class InventoryPage extends StatelessWidget {
  InventoryPage({super.key});

  final ToggleController controller = Get.put(
    ToggleController(),
    tag: 'InventoryPage',
  );

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                onPageChanged: (index) =>
                    controller.selectedIndex.value = index,
                children: [
                  Column(
                    children: [
                      CustomListTile(
                        backgroundColor: constLightBlue,
                        description: 'عرض المواد الطبية المتوفرة',
                        icon: Icons.medical_services_rounded,
                        iconColor: constBlue,
                        onTap: () {
                          Get.to(() => DisplayConsumablePage());
                        },
                        title: 'مستهلكة',
                      ),
                      CustomListTile(
                        backgroundColor: constLightBlue,
                        description: 'عرض الاجهزة المتوفرة ',
                        icon: Icons.devices_rounded,
                        iconColor: constBlue,
                        onTap: () {
                          Get.to(() => DisplayFixedAssetsPage());
                        },
                        title: 'ثابتة',
                      ),
                      CustomListTile(
                        backgroundColor: constLightBlue,
                        description: 'عرض الادوية المتوفرة ',
                        icon: Icons.medication_liquid_rounded,
                        iconColor: constBlue,
                        onTap: () {
                          Get.to(() => DisplayMedicinePage());
                        },
                        title: 'الادوية',
                      ),
                    ],
                  ),
                  ListView.builder(
                    padding: EdgeInsets.only(top: 0, bottom: 8),
                    itemCount: specialties.length,
                    itemBuilder: (context, index) {
                      return CustomListTile(
                        backgroundColor: constLightBlue,
                        description: 'عرض تفاصيل المخزون',
                        icon: Icons.inventory_2_outlined,
                        iconColor: constBlue,
                        onTap: () {},
                        title: specialties[index],
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
