// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/ArchiveController.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Cart_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';

class CartArchivePage extends StatelessWidget {
  const CartArchivePage({super.key});


  @override
  Widget build(BuildContext context) {
    final ArchiveController controller = Get.put(ArchiveController());

    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          CustomBackContainer(),
          SizedBox(height: h * 0.01),
          CustomHeadContainer(title: 'أرشيف السلة'),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                child: Column(
                  children: [
                    SizedBox(height: h * 0.01),
                    ...controller.archiveList.map((item) {
                      return CustomCartContainer(
                        buttonText: 'عرض التفاصيل',
                        title: 'السلة',
                        subtitle: 'التاريخ: ${item.date}',
                        onTap: () => controller.goToDetails(item),
                        buttonColor: constLightBlue,
                        buttonTextColor: constBlue,
                      );
                    }),
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
