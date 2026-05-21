import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Logic/Toggle_Controller.dart';
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
          children: [
            CustomToggleButtom(
              first: 'first',
              second: 'second',
              controller: controller,
            ),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller.pageController,
                onPageChanged: (index) =>
                    controller.selectedIndex.value = index,
                children: [
                  // الصفحة الأولى - Option 1
                  Center(
                    child: Text(
                      'محتوى Option 1',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),

                  // الصفحة الثانية - Option 2
                  Center(
                    child: Text(
                      'محتوى Option 2',
                      style: TextStyle(fontSize: 24),
                    ),
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
