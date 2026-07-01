// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/ArchiveController.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';

class ArchiveDetailsPage extends StatelessWidget {
  const ArchiveDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ArchiveItem item = Get.arguments as ArchiveItem;

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          CustomBackContainer(),
          SizedBox(height: context.screenHeight * 0.01),
          CustomHeadContainer(
            title: 'تفاصيل السلة',
            trailing: 'التاريخ: ${item.date}',
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.screenWidth * 0.02,
                ),
                child: Column(
                  children: [
                    if (item.medicines.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(
                          top: context.screenHeight * 0.3,
                        ),
                        child: Text(
                          'لا توجد أدوية مسجلة لهذا التاريخ',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    else
                      ...item.medicines.map((med) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                            vertical: context.screenHeight * 0.005,
                            horizontal: context.screenWidth * 0.01,
                          ),
                          width: context.screenWidth * 0.95,
                          height: context.screenHeight * 0.1,
                          padding: EdgeInsets.symmetric(
                            horizontal: context.screenWidth * 0.05,
                            vertical: context.screenHeight * 0.01,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    med.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: context.screenHeight * 0.005,
                                  ),
                                  Text('الكمية: ${med.quantity}'),
                                  SizedBox(
                                    height: context.screenHeight * 0.003,
                                  ),
                                  Text('الشركة المصنعة: ${med.company}'),
                                ],
                              ),
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: constLightBlue,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.inventory_rounded,
                                  color: constBlue,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    SizedBox(height: context.screenHeight * 0.01),
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
