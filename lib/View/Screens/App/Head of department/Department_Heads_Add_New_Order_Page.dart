// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Toggle_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Add_Ordinary_Order_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Add_Recurring_Order_Page.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Toggle_Buttom.dart';

class DepartmentHeadsAddNewOrderPage extends StatelessWidget {
  DepartmentHeadsAddNewOrderPage({super.key});

  final String pageName = '/DepartmentHeadsAddNewOrderPage';
  final ToggleController controller = Get.put(
    ToggleController(),
    tag: 'DepartmentHeadsAddNewOrderPage',
  );
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Get.delete<ToggleController>(tag: 'DepartmentHeadsAddNewOrderPage');
        }
      },
      child: Scaffold(
      backgroundColor: constBackgroundColor,
        body: Column(
          children: [
            CustomBackContainer(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03,
                vertical: MediaQuery.of(context).size.width * 0.02,
              ),
              child: Align(
                alignment: AlignmentGeometry.centerRight,
                child: CustomToggleButtom(
                  first: 'اعتيادي',
                  second: 'دوري',
                  controller: controller,
                ),
              ),
            ),
            Expanded(
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: controller.pageController,
                onPageChanged: (index) =>
                    controller.selectedIndex.value = index,
                children: [AddOrdinaryOrderPage(), AddRecurringOrderPage()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
