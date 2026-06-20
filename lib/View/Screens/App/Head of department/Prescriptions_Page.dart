// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/PrescriptionController.dart';
import 'package:stock_mate_project/Controller/Logic/Toggle_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/New_Prescription_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Processed_Prescriptions_Page.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Toggle_Buttom.dart';

class PrescriptionsPage extends StatelessWidget {
  PrescriptionsPage({super.key});

  final ToggleController controller = Get.put(
    ToggleController(),
    tag: AppRoutes.PrescriptionsPage,
  );

  final PrescriptionController prescriptionController = Get.put(
    PrescriptionController(),
  );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Get.delete<ToggleController>(tag: AppRoutes.PrescriptionsPage);
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: constBackgroundColor,
          body: Column(
            children: [
              CustomBackContainer(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.screenWidth * 0.03,
                  vertical: context.screenHeight * 0.02,
                ),
                child: Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: CustomToggleButtom(
                    first: 'جديدة',
                    second: 'مصروفة',
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
                  children: [
                    NewPrescriptionPage(),
                    ProcessedPrescriptionsPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
