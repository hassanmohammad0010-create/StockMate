// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Patients_Controller.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Name_Container.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Patient_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';

class PatientsPage extends StatelessWidget {
  const PatientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PatientsController controller = Get.put(PatientsController());

    final h = context.screenHeight;

    return Scaffold(
      backgroundColor: constBackgroundColor,

      body: Column(
        children: [
          CustomBackContainer(),
          CustomNameContainer(
            empName: 'قائمة المرضى',
            specializationName: 'المرضى الحاليين في الانتظار',
          ),
          Obx(() {
            if (controller.patients.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(top: h * 0.3),
                  child: Text(
                    'لا يوجد مرضى في الانتظار',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                      fontFamily: cairo,
                    ),
                  ),
                ),
              );
            }

            return Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: h * 0.015),
                itemCount: controller.patients.length,
                itemBuilder: (context, index) {
                  final patient = controller.patients[index];
                  return PatientCard(patient: patient, queueNumber: index + 1);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
