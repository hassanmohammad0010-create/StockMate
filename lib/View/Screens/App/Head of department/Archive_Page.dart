// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Archive_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/custom_Head_Card.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});


  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          CustomBackContainer(),
          SizedBox(height: h * 0.01),
          CustomHeadContainer(title: 'الأرشيف'),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                child: Column(
                  children: [
                    SizedBox(height: h * 0.02),
                    ArchiveCard(
                      title: 'أرشيف الوصفات',
                      icon: Icons.menu_book_rounded,
                      height: h,
                      width: w,
                      onTap: () {
                        Get.toNamed('/PrescriptionArchivePage');
                      },
                    ),
                    SizedBox(height: h * 0.02),
                    ArchiveCard(
                      title: 'أرشيف السلة',
                      icon: Icons.shopping_basket_rounded,
                      height: h,
                      width: w,
                      onTap: () {
                        Get.toNamed('/CartArchivePage');
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
