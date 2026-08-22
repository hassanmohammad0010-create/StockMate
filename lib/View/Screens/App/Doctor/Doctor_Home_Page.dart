// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/DepartmentHeadsMainTabController.dart';
import 'package:stock_mate_project/Controller/Service/Get_Name_Roll_Of_User.dart';
import 'package:stock_mate_project/Controller/Service/Patients_Controller.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Name_Container.dart';
import 'package:stock_mate_project/View/Widget/App/WaitingPatientsList.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

class DoctorHomePage extends StatelessWidget {
  DoctorHomePage({super.key});

  final GetNameRollOfUserController getNameRollOfUserController = Get.put(
    GetNameRollOfUserController(),
  );

  final DepartmentHeadsMainTabController mainTabController =
      Get.find<DepartmentHeadsMainTabController>();

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Obx(() {
        final String? name = getNameRollOfUserController.name.value;
        final String? departmentName =
            getNameRollOfUserController.departmentName.value;

        return (name == null || departmentName == null)
            ? const CustomLoadingIndicator()
            : RefreshIndicator(
                color: constBlue,
                onRefresh: () async {
                  if (Get.isRegistered<PatientsController>()) {
                    await Get.find<PatientsController>().fetchPatients();
                  }
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      CustomNameContainer(
                        empName: 'د. $name',
                        specializationName: 'قسم $departmentName',
                      ),
                      SizedBox(height: h * 0.01),
                      Column(
                        children: [
                          Align(
                            alignment: AlignmentGeometry.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: w * 0.05),
                              child: Text(
                                'المرضى',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: cairo,
                                  fontSize: 28,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: h * 0.005),
                          const WaitingPatientsList(),
                        ],
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }
}
