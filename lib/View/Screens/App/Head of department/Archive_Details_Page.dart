// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/ArchiveController.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';

class ArchiveDetailsPage extends StatelessWidget {
  const ArchiveDetailsPage({super.key});

  final String pageName = '/ArchiveDetailsPage';

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    final ArchiveItem item = Get.arguments as ArchiveItem;

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          CustomBackContainer(),
          SizedBox(height: h * 0.01),
          CustomHeadContainer(
            title: 'تفاصيل السلة',
            trailing: 'التاريخ: ${item.date}',
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                child: Column(
                  children: [
                    if (item.medicines.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: h * 0.3),
                        child: Text(
                          'لا توجد أدوية مسجلة لهذا التاريخ',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    else
                      ...item.medicines.map((med) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                            vertical: h * 0.005,
                            horizontal: w * 0.01,
                          ),
                          width: w * 0.95,
                          height: h * 0.1,
                          padding: EdgeInsets.all(8),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                med.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: h * 0.005),
                              Text('الكمية: ${med.quantity}'),
                              SizedBox(height: h * 0.003),
                              Text('الشركة المصنعة: ${med.company}'),
                            ],
                          ),
                        );
                      }),

                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   physics: NeverScrollableScrollPhysics(),
                    //   itemCount: item.medicines.length,
                    //   itemBuilder: (context, index) {
                    //     final med = item.medicines[index];
                    //     return Container(
                    //       margin: EdgeInsets.symmetric(
                    //         vertical: h * 0.005,
                    //         horizontal: w * 0.01,
                    //       ),
                    //       padding: EdgeInsets.all(12),
                    //       decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.circular(12),
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: Colors.black.withOpacity(0.1),
                    //             blurRadius: 6,
                    //             offset: Offset(0, 2),
                    //           ),
                    //         ],
                    //       ),
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             med.name,
                    //             style: TextStyle(
                    //               fontWeight: FontWeight.bold,
                    //               fontSize: 16,
                    //             ),
                    //           ),
                    //           SizedBox(height: h * 0.005),
                    //           Text('الكمية: ${med.quantity}'),
                    //           SizedBox(height: h * 0.003),
                    //           Text('الشركة المصنعة: ${med.company}'),
                    //         ],
                    //       ),
                    //     );
                    //   },
                    // ),
                    SizedBox(height: h * 0.01),
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
