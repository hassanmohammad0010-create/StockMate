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

  static const List<String> _medicines = [
    'باراسيتامول',
    'أموكسيسيلين',
    'إيبوبروفين',
    'أزيثروميسين',
    'فلام-ك',
  ];

  static const List<String> _units = ['قطعة', 'لتر', 'كيلوغرام', 'كيت (دزينة)'];

  static const List<String> _brands = [
    'شركة تاميكو',
    'شركة فارما',
    'الشركة الطبية السورية',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.008),
                  Form(
                    key: controller.formKey,
                    child: Container(
                      width: size.width * 0.95,
                      child: Card(
                        color: Colors.white.withOpacity(0.9),
                        elevation: 3.0,
                        child: Column(
                          children: [
                            // ── عنوان الكارد ──────────────────────────────
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 16,
                                  top: 12,
                                ),
                                child: Text(
                                  'تفاصيل الطلب',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.03,
                              ),
                              child: const Divider(),
                            ),
                            SizedBox(height: size.height * 0.01),

                            // ── اسم الدواء ────────────────────────────────
                            Obx(() {
                              // ✅ قراءة المتغير مباشرة قبل أي شرط لضمان عدم حدوث خطأ GetX
                              final medicineName = controller.order.value.medicineName;
                              final isInvalid = controller.isFieldInvalid('medicineName');

                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.03,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomDropdown<String>(
                                      items: _medicines,
                                      labelBuilder: (v) => v,
                                      label: 'اسم الدواء *',
                                      hint: 'اختر الدواء المطلوب',
                                      searchable: true,
                                      icon: Icons.medication_outlined,
                                      value: medicineName,
                                      errorBorder: isInvalid,
                                      onChanged: (v) => controller.updateMedicineName(v),
                                    ),
                                    if (isInvalid)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 12,
                                          top: 4,
                                        ),
                                        child: Text(
                                          'الرجاء اختيار اسم الدواء',
                                          style: TextStyle(
                                            color: constRed,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }),
                            SizedBox(height: size.height * 0.015),

                            // ── الكمية ────────────────────────────────────
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.03,
                              ),
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
                            SizedBox(height: size.height * 0.015),

                            // ── الوحدة ────────────────────────────────────
                            Obx(() {
                              final unit = controller.order.value.unit;
                              final isInvalid = controller.isFieldInvalid('unit');

                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.03,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomDropdown<String>(
                                      items: _units,
                                      labelBuilder: (v) => v,
                                      label: 'الوحدة *',
                                      hint: 'اختر الوحدة',
                                      icon: Icons.category_outlined,
                                      searchable: false,
                                      value: unit,
                                      errorBorder: isInvalid,
                                      onChanged: (v) => controller.updateUnit(v),
                                    ),
                                    if (isInvalid)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 12,
                                          top: 4,
                                        ),
                                        child: Text(
                                          'الرجاء اختيار الوحدة',
                                          style: TextStyle(
                                            color: constRed,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }),
                            SizedBox(height: size.height * 0.015),

                            // ── الوكيل / الماركة ──────────────────────────
                            Obx(() {
                              final brand = controller.order.value.brand;
                              final isInvalid = controller.isFieldInvalid('brand');

                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.03,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomDropdown<String>(
                                      items: _brands,
                                      labelBuilder: (v) => v,
                                      label: 'الوكيل / الماركة *',
                                      hint: 'اختر الوكيل / الماركة',
                                      icon: Icons.store_mall_directory_outlined,
                                      searchable: true,
                                      value: brand,
                                      errorBorder: isInvalid,
                                      onChanged: (v) => controller.updateBrand(v),
                                    ),
                                    if (isInvalid)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 12,
                                          top: 4,
                                        ),
                                        child: Text(
                                          'الرجاء اختيار الوكيل / الماركة',
                                          style: TextStyle(
                                            color: constRed,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }),
                            SizedBox(height: size.height * 0.015),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.008),

                  const RecurringChooseCard(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}