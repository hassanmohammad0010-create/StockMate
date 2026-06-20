// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Archive_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/custom_Head_Card.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          CustomBackContainer(),
          SizedBox(height: context.screenHeight * 0.01),
          CustomHeadContainer(title: 'الأرشيف'),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.02),
                child: Column(
                  children: [
                    SizedBox(height: context.screenHeight * 0.02),
                    ArchiveCard(
                      title: 'أرشيف الوصفات',
                      icon: Icons.bar_chart_rounded,
                      height: context.screenHeight,
                      width: context.screenWidth,
                      onTap: () {
                        Get.toNamed(AppRoutes.PrescriptionArchivePage);
                      },
                    ),
                    SizedBox(height: context.screenHeight * 0.02),
                    ArchiveCard(
                      title: 'أرشيف السلة',
                      icon: Icons.shopping_cart,
                      height: context.screenHeight,
                      width: context.screenWidth,
                      onTap: () {
                        Get.toNamed(AppRoutes.CartArchivePage);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
