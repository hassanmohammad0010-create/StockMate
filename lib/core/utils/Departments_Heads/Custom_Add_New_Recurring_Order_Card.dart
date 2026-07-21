// // ignore_for_file: sized_box_for_whitespace, file_names, deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:stock_mate_project/Constant/Const.dart';
// import 'package:stock_mate_project/Controller/Logic/AddRecurringOrder_Controller.dart';
// import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Drop_Down/Custom_My_Drop_Down.dart';
// import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Text_Field/Custom_My_TextFormFaild.dart';
// import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Recurring_Choose_Card.dart';

// class RecurringOrderCard extends StatelessWidget {
//   final AddRecurringOrderController controller;

//   const RecurringOrderCard({super.key, required this.controller});

//   static const List<String> _medicines = [
//     'باراسيتامول',
//     'أموكسيسيلين',
//     'إيبوبروفين',
//     'أزيثروميسين',
//     'فلام-ك',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final h = context.screenHeight;
//     final w = context.screenWidth;

//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: ConstrainedBox(
//             constraints: BoxConstraints(minHeight: constraints.maxHeight),
//             child: IntrinsicHeight(
//               child: Column(
//                 children: [
//                   SizedBox(height: h * 0.008),
//                   Form(
//                     key: controller.formKey,
//                     child: Container(
//                       width: w * 0.95,
//                       child: Card(
//                         color: Colors.white.withOpacity(0.9),
//                         elevation: 3.0,
//                         child: Column(
//                           children: [
//                             Align(
//                               alignment: Alignment.centerRight,
//                               child: Padding(
//                                 padding: EdgeInsets.only(
//                                   right: w * 0.05,
//                                   top: h * 0.015,
//                                 ),
//                                 child: Text(
//                                   'تفاصيل الطلب',
//                                   style: const TextStyle(
//                                     fontSize: 20,
//                                     fontFamily: 'Cairo',
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: w * 0.03,
//                               ),
//                               child: const Divider(),
//                             ),
//                             SizedBox(height: h * 0.01),

//                             // ── اسم الدواء ────────────────────────────────
//                             Obx(() {
//                               // ✅ قراءة المتغير مباشرة قبل أي شرط لضمان عدم حدوث خطأ GetX
//                               final medicineName =
//                                   controller.order.value.medicineName;
//                               final isInvalid = controller.isFieldInvalid(
//                                 'medicineName',
//                               );

//                               return Padding(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: w * 0.03,
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     CustomDropdown<String>(
//                                       items: _medicines,
//                                       labelBuilder: (v) => v,
//                                       label: 'اسم الدواء *',
//                                       hint: 'اختر الدواء المطلوب',
//                                       searchable: true,
//                                       icon: Icons.medication_outlined,
//                                       value: medicineName,
//                                       errorBorder: isInvalid,
//                                       onChanged: (v) =>
//                                           controller.updateMedicineName(v),
//                                     ),
//                                     if (isInvalid)
//                                       Padding(
//                                         padding: EdgeInsets.only(
//                                           right: w * 0.03,
//                                           top: h * 0.005,
//                                         ),
//                                         child: Text(
//                                           'الرجاء اختيار اسم الدواء',
//                                           style: TextStyle(
//                                             color: constRed,
//                                             fontSize: 11,
//                                           ),
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                               );
//                             }),
//                             SizedBox(height: h * 0.015),

//                             // ── الكمية ────────────────────────────────────
//                             Padding(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: w * 0.03,
//                               ),
//                               child: CustomMyTextFormField(
//                                 prefixIcon: Icons.numbers_outlined,
//                                 keyboardType: TextInputType.number,
//                                 label: 'الكمية *',
//                                 hint: 'أدخل الكمية المطلوبة',
//                                 controller: controller.quantityController,
//                                 validator: (value) {
//                                   if (value == null || value.trim().isEmpty) {
//                                     return 'الرجاء إدخال الكمية';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                             SizedBox(height: h * 0.015),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: h * 0.008),
//                   const RecurringChooseCard(),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

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

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
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
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: w * 0.03,
                              ),
                              child: const Divider(),
                            ),
                            SizedBox(height: h * 0.01),

                            // ── اسم الدواء ────────────────────────────────
                            Obx(() {
                              // ✅ قراءة المتغير مباشرة قبل أي شرط لضمان عدم حدوث خطأ GetX
                              final medicineName =
                                  controller.order.value.medicineName;
                              final isInvalid = controller.isFieldInvalid(
                                'medicineName',
                              );

                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: w * 0.03,
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
                                      onChanged: (v) =>
                                          controller.updateMedicineName(v),
                                    ),
                                    if (isInvalid)
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: w * 0.03,
                                          top: h * 0.005,
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
                            SizedBox(height: h * 0.015),

                            // ── الكمية ────────────────────────────────────
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: w * 0.03,
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
                            SizedBox(height: h * 0.015),

                            // ── المدة (عدد التكرارات) ──────────────────────
                            Obx(() {
                              final duration =
                                  controller.selectedDuration.value;
                              final options = controller.durationOptions;

                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: w * 0.03,
                                ),
                                child: CustomDropdown<String>(
                                  items: options,
                                  labelBuilder: (v) => v,
                                  label: 'المدة *',
                                  hint: 'اختر عدد مرات التكرار',
                                  searchable: true,
                                  icon: Icons.event_repeat_outlined,
                                  value: duration,
                                  errorBorder: false,
                                  onChanged: (v) {
                                    if (v != null) {
                                      controller.updateDuration(v);
                                    }
                                  },
                                ),
                              );
                            }),
                            SizedBox(height: h * 0.015),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.008),
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