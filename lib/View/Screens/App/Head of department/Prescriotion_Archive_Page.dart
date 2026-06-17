// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';

class PrescriotionArchivePage extends StatelessWidget {
  const PrescriotionArchivePage({super.key});

  final String pageName = '/PrescriptionArchivePage';

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
          CustomHeadContainer(title: 'أرشيف الوصفات الطبية'),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                child: Column(
                  children: [
              
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
