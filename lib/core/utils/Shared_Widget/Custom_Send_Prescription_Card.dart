// ignore_for_file: file_names, sized_box_for_whitespace, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Logic/SendPrescriptionController.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_My_TextFormFaild.dart';

class CustomPrescriptionCard extends StatelessWidget {
  const CustomPrescriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final SendPrescriptionController controller =
        Get.find<SendPrescriptionController>();

    final h = MediaQuery.of(context).size.height;

    return Form(
      key: controller.formKey,
      child: Card(
        elevation: 3.0,
        color: Colors.white.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: h * 0.01),
                child: CustomMyTextFormField(
                  controller: controller.patientNameController,
                  prefixIcon: Icons.title_outlined,
                  keyboardType: TextInputType.text,
                  label: 'اسم  المريض *',
                  hint: 'أدخل اسم المريض الثلاثي',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال اسم المريض الثلاثي';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: h * 0.01),
              Padding(
                padding: EdgeInsets.only(top: h * 0.01),
                child: CustomMyTextFormField(
                  controller: controller.doctorNameController,
                  prefixIcon: Icons.person_outline,
                  keyboardType: TextInputType.text,
                  label: 'الطبيب المسؤل *',
                  hint: 'أدخل اسم الطبيب المسؤل',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال اسم الطبيب المسؤل';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: h * 0.01),
              Padding(
                padding: EdgeInsets.only(top: h * 0.01),
                child: CustomMyTextFormField(
                  controller: controller.conditionController,
                  prefixIcon: Icons.healing,
                  keyboardType: TextInputType.text,
                  label: 'الحالة *',
                  hint: 'أدخل حالة المريض الطبية',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال حالة المريض الطبية';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: h * 0.01),
              Padding(
                padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.005),
                child: CustomMyTextFormField(
                  controller: controller.medicationsController,
                  maxLines: 4,
                  prefixIcon: Icons.medication_outlined,
                  keyboardType: TextInputType.text,
                  label: 'الأدوية *',
                  hint: 'أدخل الأدوية الموصوفة',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال الأدوية الموصوفة';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: h * 0.01),

              Padding(
                padding: EdgeInsets.only(top: h * 0.01),
                child: CustomMyTextFormField(
                  controller: controller.notesController,
                  prefixIcon: Icons.notes_outlined,
                  keyboardType: TextInputType.text,
                  label: 'ملاحظات *',
                  hint: 'أدخل ملاحظات الوصفة',
                  validator: (value) {
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
