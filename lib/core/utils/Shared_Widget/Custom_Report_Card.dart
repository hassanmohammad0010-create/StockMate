// ignore_for_file: file_names, sized_box_for_whitespace, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Logic/ReportController.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Text_Field/Custom_My_TextFormFaild.dart';

class CustomReportCard extends StatelessWidget {
  const CustomReportCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ReportController controller = Get.find<ReportController>();

    final h = MediaQuery.of(context).size.height;

    return Form(
      key: controller.formKey,
      child: Card(
        color: Colors.white.withOpacity(0.9),
        elevation: 3.0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'تفاصيل الابلاغ / الاقتراح',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(top: h * 0.01),
                child: CustomMyTextFormField(
                  controller: controller.reportTitle,
                  prefixIcon: Icons.title_outlined,
                  keyboardType: TextInputType.text,
                  label: 'العنوان *',
                  hint: 'أدخل عنوان التقرير',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال العنوان';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: h * 0.01),
              Padding(
                padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.005),
                child: CustomMyTextFormField(
                  controller: controller.description,
                  maxLines: 5,
                  prefixIcon: Icons.description_outlined,
                  keyboardType: TextInputType.text,
                  label: 'التفاصيل *',
                  hint: 'أدخل  تفاصيل التقرير',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال التفاصيل';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
