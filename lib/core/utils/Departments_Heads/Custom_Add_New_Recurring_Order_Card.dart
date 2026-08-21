// ignore_for_file: sized_box_for_whitespace, file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/AddRecurringOrder_Controller.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Drop_Down/Custom_My_Drop_Down.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Text_Field/Custom_My_TextFormFaild.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Recurring_Choose_Card.dart';

class RecurringOrderCard extends StatelessWidget {
  final AddRecurringOrderController controller;

  const RecurringOrderCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    // ✅ تم حذف LayoutBuilder + IntrinsicHeight + ConstrainedBox(minHeight)
    // لنفس السبب اللي في OrdinaryOrderCard: كانوا بيعملوا double layout pass
    // بيتكرر كل frame وقت ظهور/اختفاء الكيبورد، وده اللي كان بيسبب الإحساس بالثقل.
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: h * 0.008),
          Form(
            key: controller.formKey,
            child: Container(
              width: w * 0.95,
              child: Card(
                color: Colors.white.withOpacity(0.9),
                elevation: 3.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: w * 0.05,
                          top: h * 0.015,
                        ),
                        child: Text(
                          'تفاصيل الطلب',
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                      child: const Divider(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.006,
                      ),
                      child: Text(
                        'اختر المادة المطلوية:',
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                    // ── اسم الدواء (مرتبط بالـ API) ────────────────
                    Obx(() {
                      final medicineName =
                          controller.selectedMedicineName.value;

                      final hasError =
                          controller.medicinesError.value.isNotEmpty;
                      final errorMsg = controller.medicinesError.value;

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                        child: CustomDropdown<String>(
                          items: controller.medicineNames,
                          isLoading: controller.isMedicinesLoading.value,
                          hasError: hasError,
                          errorMessage: errorMsg,
                          onRetry: () => controller.fetchMedicines(),
                          labelBuilder: (v) => v,
                          label: 'اسم الدواء *',
                          hint: 'اختر الدواء المطلوب',
                          searchable: true,
                          icon: Icons.medication_outlined,
                          value: medicineName,
                          validator: (v) =>
                              v == null ? 'الرجاء اختيار اسم الدواء' : null,
                          onChanged: (v) => controller.updateMedicineName(v),
                        ),
                      );
                    }),
                    SizedBox(height: h * 0.015),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.006,
                      ),
                      child: Text(
                        'ادخل الكمية المطلوية:',
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                    // ── الكمية ────────────────────────────────────
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                      child: CustomMyTextFormField(
                        prefixIcon: Icons.numbers_outlined,
                        keyboardType: TextInputType.number,
                        label: 'الكمية *',
                        hint: 'أدخل الكمية المطلوبة',
                        controller: controller.quantityController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'الرجاء إدخال الكمية';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: h * 0.015),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.006,
                      ),
                      child: Text(
                        'اختر المدة المطلوبة لاستمرار الطلب:',
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                    // ── المدة (عدد التكرارات) — CustomDropdown<int> ────
                    Obx(() {
                      final duration = controller.selectedDuration.value;
                      final options = controller.durationOptions;

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                        child: CustomDropdown<int>(
                          items: options,
                          labelBuilder: (v) => v.toString(),
                          label: 'المدة *',
                          hint: 'اختر عدد مرات التكرار',
                          searchable: true,
                          icon: Icons.event_repeat_outlined,
                          value: duration,
                          validator: (v) =>
                              v == null ? 'الرجاء اختيار المدة' : null,
                          onChanged: (v) {
                            if (v != null) {
                              controller.updateDuration(v);
                            }
                          },
                        ),
                      );
                    }),
                    SizedBox(height: h * 0.03),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: h * 0.008),
          const RecurringChooseCard(),
        ],
      ),
    );
  }
}
