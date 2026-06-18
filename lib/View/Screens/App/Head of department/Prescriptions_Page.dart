// ignore_for_file: avoid_unnecessary_containers, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/PrescriptionsController2.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Prescription_Card.dart';

class PrescriptionsPage extends StatelessWidget {
  const PrescriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = PrescriptionsController.to;

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          CustomBackContainer(),
          SizedBox(height: context.screenHeight * 0.01),
          CustomHeadContainer(title: 'الوصفات الطبية الجديدة'),
          Expanded(
            child: Obx(() {
              if (controller.prescriptions.isEmpty) {
                return Center(
                  child: Text(
                    'لا توجد وصفات طبية',
                    style: TextStyle(
                      fontFamily: cairo,
                      color: Colors.grey,
                    ),
                  ),
                );
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.screenWidth * 0.03,
                    vertical: context.screenHeight * 0.01,
                  ),
                  child: Column(
                    children: controller.prescriptions
                        .map((rx) => PrescriptionCard(
                              prescription: rx,
                              onTap: () => controller.goToDetails(rx),
                            ))
                        .toList(),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}