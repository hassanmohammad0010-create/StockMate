// // ignore_for_file: file_names, deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:stock_mate_project/Constant/Const.dart';
// import 'package:stock_mate_project/Controller/Logic/Send_New_Prescription_Controller.dart';
// import 'package:stock_mate_project/core/models/Patient_Model.dart';
// import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Drop_Down/Custom_My_Drop_Down.dart';
// import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Text_Field/Custom_My_TextFormFaild.dart';
// import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
// import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';
// import 'package:stock_mate_project/core/utils/Shared_Widget/custom_Head_Card.dart';

// class SendPrescriptionPage extends StatelessWidget {
//   const SendPrescriptionPage({super.key, required this.patient});

//   final PatientModel patient;

//   @override
//   Widget build(BuildContext context) {
//     final h = context.screenHeight;
//     final w = context.screenWidth;

//     final c = Get.put(
//       SendNewPrescriptionController(patient: patient),
//       tag: patient.id,
//     );

//     return Scaffold(
//       backgroundColor: constBackgroundColor,
//       body: Column(
//         children: [
//           const CustomBackContainer(),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Form(
//                 key: c.formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     SizedBox(height: h * 0.005),
//                     CustomHeadContainer(title: 'إرسال وصفة طبية'),
//                     SizedBox(height: h * 0.02),

//                     // ── بطاقة معلومات المريض ─────────────────────────
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: w * 0.03),
//                       child: Container(
//                         width: double.infinity,
//                         padding: EdgeInsets.symmetric(
//                           horizontal: w * 0.04,
//                           vertical: h * 0.02,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(14),
//                           border: Border.all(
//                             color: Colors.grey.shade200,
//                             width: 0.5,
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.3),
//                               spreadRadius: 3,
//                               blurRadius: 8,
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             _InfoRow(
//                               label: 'اسم المريض',
//                               value: patient.name,
//                               icon: Icons.person_outline_outlined,
//                             ),
//                             SizedBox(height: h * 0.012),
//                             _InfoRow(
//                               label: 'الرقم الوطني',
//                               value: patient.nationalNumber,
//                               icon: Icons.badge_outlined,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     SizedBox(height: h * 0.025),

//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: w * 0.03),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'الأدوية',
//                             style: TextStyle(
//                               fontSize: h * 0.018,
//                               fontFamily: cairo,
//                               fontWeight: FontWeight.w600,
//                               color: constGray,
//                             ),
//                           ),
//                           TextButton.icon(
//                             onPressed: c.addMedicineEntry,
//                             icon: const Icon(
//                               Icons.add_circle_outline,
//                               size: 20,
//                             ),
//                             label: const Text('إضافة دواء آخر'),
//                             style: TextButton.styleFrom(
//                               foregroundColor: constBlue,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: h * 0.01),

//                     // ── قائمة الأدوية الديناميكية ───────────────────
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: w * 0.03),
//                       child: Obx(
//                         () => Column(
//                           children: c.medicineEntries.map((entry) {
//                             final isInvalid = c.invalidEntryIds.contains(
//                               entry.id,
//                             );
//                             final canRemove = c.medicineEntries.length > 1;

//                             return Padding(
//                               padding: EdgeInsets.only(bottom: h * 0.018),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Expanded(
//                                     child: CustomDropdown<String>(
//                                       items: kMedicinesList,
//                                       labelBuilder: (v) => v,
//                                       label: 'اسم الدواء *',
//                                       hint: 'اختر الدواء',
//                                       icon: Icons.medication_outlined,
//                                       searchable: true,
//                                       value: entry.medicineName.value,
//                                       errorBorder: isInvalid,
//                                       errorText: isInvalid
//                                           ? 'يرجى اختيار دواء'
//                                           : null,
//                                       onChanged: (v) =>
//                                           c.selectMedicine(entry.id, v),
//                                     ),
//                                   ),
//                                   if (canRemove) ...[
//                                     SizedBox(width: w * 0.02),
//                                     Padding(
//                                       padding: EdgeInsets.only(top: h * 0.008),
//                                       child: IconButton(
//                                         onPressed: () =>
//                                             c.removeMedicineEntry(entry.id),
//                                         icon: const Icon(
//                                           Icons.remove_circle_outline,
//                                           color: constRed,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ],
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ),

//                     SizedBox(height: h * 0.015),

//                     // ── حقل الملاحظات ────────────────────────────────
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: w * 0.03),
//                       child: CustomMyTextFormField(
//                         prefixIcon: Icons.edit_note_outlined,
//                         label: 'ملاحظات',
//                         hint: 'أضف أي ملاحظات على الوصفة (اختياري)',
//                         maxLines: 5,
//                         controller: c.notesController,
//                       ),
//                     ),

//                     SizedBox(height: h * 0.03),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // ── زر الإرسال ────────────────────────────────────────
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: w * 0.04),
//             child: CustomMainButtom(
//               title: 'إرسال الوصفة',
//               color: constBlue,
//               fontcolor: Colors.white,
//               onPressed: c.sendPrescription,
//             ),
//           ),
//           SizedBox(height: h * 0.02),
//         ],
//       ),
//     );
//   }
// }

// class _InfoRow extends StatelessWidget {
//   const _InfoRow({
//     required this.label,
//     required this.value,
//     required this.icon,
//   });

//   final String label;
//   final String value;
//   final IconData icon;

//   @override
//   Widget build(BuildContext context) {
//     final h = context.screenHeight;

//     return Row(
//       children: [
//         Icon(icon, size: 20, color: Colors.grey.shade600),
//         const SizedBox(width: 10),
//         Text(
//           '$label: ',
//           style: TextStyle(
//             fontSize: h * 0.015,
//             color: Colors.grey,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         Expanded(
//           child: Text(
//             value,
//             style: const TextStyle(
//               fontSize: 15,
//               color: constColor,
//               fontWeight: FontWeight.bold,
//             ),
//             textAlign: TextAlign.right,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
// }

// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Send_New_Prescription_Controller.dart';
import 'package:stock_mate_project/core/models/Patient_Model.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Drop_Down/Custom_My_Drop_Down.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Text_Field/Custom_My_TextFormFaild.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/custom_Head_Card.dart';

class SendPrescriptionPage extends StatelessWidget {
  const SendPrescriptionPage({super.key, required this.patient});

  final PatientModel patient;

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    final c = Get.put(
      SendNewPrescriptionController(patient: patient),
      tag: patient.id,
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: constBackgroundColor,
        body: Column(
          children: [
            const CustomBackContainer(),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: c.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: h * 0.005),
                      CustomHeadContainer(title: 'إرسال وصفة طبية'),
                      SizedBox(height: h * 0.02),

                      // ── بطاقة معلومات المريض ─────────────────────────
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: w * 0.04,
                            vertical: h * 0.02,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 0.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _InfoRow(
                                label: 'اسم المريض',
                                value: patient.name,
                                icon: Icons.person_outline_outlined,
                              ),
                              SizedBox(height: h * 0.012),
                              _InfoRow(
                                label: 'الرقم الوطني',
                                value: patient.nationalNumber,
                                icon: Icons.badge_outlined,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: h * 0.025),

                      // ── عنوان الأدوية + العداد + زر الإضافة ──────────
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                        child: Obx(() {
                          final count = c.medicineEntries.length;
                          final isMax = c.isMaxReached;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'الأدوية',
                                    style: TextStyle(
                                      fontSize: h * 0.018,
                                      fontFamily: cairo,
                                      fontWeight: FontWeight.w600,
                                      color: constGray,
                                    ),
                                  ),
                                  SizedBox(width: w * 0.02),
                                  // ── شارة العدد ──
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: w * 0.02,
                                      vertical: h * 0.003,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isMax
                                          ? constRed.withOpacity(0.1)
                                          : constBlue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '$count / ${SendNewPrescriptionController.maxMedicines}',
                                      style: TextStyle(
                                        fontSize: h * 0.013,
                                        fontWeight: FontWeight.w700,
                                        color: isMax ? constRed : constBlue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // ── زر الإضافة (يختفي عند الحد الأقصى) ──
                              if (!isMax)
                                TextButton.icon(
                                  onPressed: c.addMedicineEntry,
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    size: 20,
                                  ),
                                  label: const Text('إضافة دواء'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: constBlue,
                                  ),
                                ),
                            ],
                          );
                        }),
                      ),
                      SizedBox(height: h * 0.01),

                      // ── قائمة الأدوية الديناميكية ───────────────────
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                        child: Obx(
                          () => Column(
                            children: c.medicineEntries.map((entry) {
                              final isInvalid = c.invalidEntryIds.contains(
                                entry.id,
                              );
                              final canRemove = c.medicineEntries.length > 1;

                              return Padding(
                                padding: EdgeInsets.only(bottom: h * 0.018),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: CustomDropdown<String>(
                                        items: kMedicinesList,
                                        labelBuilder: (v) => v,
                                        label: 'اسم الدواء *',
                                        hint: 'اختر الدواء',
                                        icon: Icons.medication_outlined,
                                        searchable: true,
                                        value: entry.medicineName.value,
                                        errorBorder: isInvalid,
                                        errorText: isInvalid
                                            ? 'يرجى اختيار دواء'
                                            : null,
                                        onChanged: (v) =>
                                            c.selectMedicine(entry.id, v),
                                      ),
                                    ),
                                    if (canRemove) ...[
                                      SizedBox(width: w * 0.02),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: h * 0.008,
                                        ),
                                        child: IconButton(
                                          onPressed: () =>
                                              c.removeMedicineEntry(entry.id),
                                          icon: const Icon(
                                            Icons.remove_circle_outline,
                                            color: constRed,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      SizedBox(height: h * 0.015),

                      // ── حقل الملاحظات ────────────────────────────────
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                        child: CustomMyTextFormField(
                          prefixIcon: Icons.edit_note_outlined,
                          label: 'ملاحظات',
                          hint: 'أضف أي ملاحظات على الوصفة (اختياري)',
                          maxLines: 5,
                          controller: c.notesController,
                        ),
                      ),

                      SizedBox(height: h * 0.03),
                    ],
                  ),
                ),
              ),
            ),

            // ── زر الإرسال ────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              child: CustomMainButtom(
                title: 'إرسال الوصفة',
                color: constBlue,
                fontcolor: Colors.white,
                onPressed: () {
                  c.sendPrescription();
                  Get.offAllNamed(AppRoutes.DepartmentHeadsMainPage);
                },
              ),
            ),
            SizedBox(height: h * 0.02),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;

    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: h * 0.015,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: constColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
