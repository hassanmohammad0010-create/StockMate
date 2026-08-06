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
                              final canRemove = c.medicineEntries.length > 1;

                              return Padding(
                                padding: EdgeInsets.only(bottom: h * 0.018),
                                child: Container(
                                  padding: EdgeInsets.all(w * 0.03),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      // ── صف اختيار الدواء + زر الحذف ──
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              // ✅ صار validator عادي مرتبط بالـ Form
                                              validator: (v) => v == null
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
                                                    c.removeMedicineEntry(
                                                      entry.id,
                                                    ),
                                                icon: const Icon(
                                                  Icons.remove_circle_outline,
                                                  color: constRed,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),

                                      // ── صف الكمية (يظهر فقط بعد اختيار الدواء) ──
                                      if (entry
                                              .medicineName
                                              .value
                                              ?.isNotEmpty ??
                                          false) ...[
                                        SizedBox(height: h * 0.015),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.inventory_2_outlined,
                                              size: 20,
                                              color: Colors.grey.shade600,
                                            ),
                                            SizedBox(width: w * 0.02),
                                            Text(
                                              'الكمية:',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(width: w * 0.03),

                                            // ── عداد الكمية ──
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // زر التقليل
                                                  IconButton(
                                                    onPressed:
                                                        entry.quantity.value > 1
                                                        ? () => c.updateQuantity(
                                                            entry.id,
                                                            entry
                                                                    .quantity
                                                                    .value -
                                                                1,
                                                          )
                                                        : null,
                                                    icon: Icon(
                                                      Icons.remove,
                                                      size: 20,
                                                      color:
                                                          entry.quantity.value >
                                                              1
                                                          ? constBlue
                                                          : Colors
                                                                .grey
                                                                .shade400,
                                                    ),
                                                    padding: EdgeInsets.all(8),
                                                    constraints:
                                                        BoxConstraints(),
                                                  ),

                                                  // عرض الكمية الحالية
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: w * 0.03,
                                                          vertical: h * 0.008,
                                                        ),
                                                    child: Obx(
                                                      () => Text(
                                                        '${entry.quantity.value}',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: constBlue,
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  // زر الزيادة
                                                  IconButton(
                                                    onPressed:
                                                        entry.quantity.value <
                                                            99
                                                        ? () => c.updateQuantity(
                                                            entry.id,
                                                            entry
                                                                    .quantity
                                                                    .value +
                                                                1,
                                                          )
                                                        : null,
                                                    icon: Icon(
                                                      Icons.add,
                                                      size: 20,
                                                      color:
                                                          entry.quantity.value <
                                                              99
                                                          ? constBlue
                                                          : Colors
                                                                .grey
                                                                .shade400,
                                                    ),
                                                    padding: EdgeInsets.all(8),
                                                    constraints:
                                                        BoxConstraints(),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(width: w * 0.02),

                                            // ── نص توضيحي ──
                                            Obx(
                                              () => Text(
                                                entry.quantity.value == 1
                                                    ? 'قطعة واحدة'
                                                    : '${entry.quantity.value} قطع',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey.shade500,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
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
                onPressed: () async {
                  // ✅ انتظار نتيجة الفاليديشن قبل الانتقال
                  final success = await c.sendPrescription();
                  if (success) {
                    Get.offAllNamed(AppRoutes.DepartmentHeadsMainPage);
                  }
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
