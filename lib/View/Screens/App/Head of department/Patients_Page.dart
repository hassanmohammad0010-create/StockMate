// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Toggle_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/In_Consultation_Patients_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Waiting_Patients_Page.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Toggle_Buttom.dart';

class PatientsPage extends StatelessWidget {
  PatientsPage({super.key});

  final ToggleController controller = Get.put(
    ToggleController(),
    tag: AppRoutes.PatientsPage,
  );

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Get.delete<ToggleController>(tag: AppRoutes.PatientsPage);
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
                  horizontal: w * 0.03,
                  vertical: h * 0.02,
                ),
                child: Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: CustomToggleButtom(
                    first: 'انتظار',
                    second: 'معاينة',
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
                    WaitingPatientsPage(),
                    InConsultationPatientsPage(),
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
