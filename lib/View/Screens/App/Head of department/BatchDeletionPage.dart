// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Batch_Deletion_Controller.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Drop_Down/Custom_My_Drop_Down.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Text_Field/Custom_My_TextFormFaild.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/custom_Head_Card.dart';

/// صفحة بسيطة لطلب حذف كمية من دفعة معينة (بأي حالة صلاحية).
/// لا تقوم هذه الصفحة أو الكنترولر بإنقاص الكمية فعلياً من المخزون؛
/// فقط تسجّل الطلب (المادة، الدفعة، الكمية، السبب) تمهيداً لإرساله للباك اند لاحقاً.
class BatchDeletionPage extends StatelessWidget {
  const BatchDeletionPage({
    super.key,
    required this.material,
    required this.batch,
  });

  final MaterialItem material;
  final MaterialBatch batch;

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    final c = Get.put(
      BatchDeletionController(material: material, batch: batch),
      tag: '${material.id}_${batch.id}',
    );

    return Scaffold(
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
                    CustomHeadContainer(title: 'حذف كمية من الدفعة'),
                    SizedBox(height: h * 0.02),

                    // ── بطاقة معلومات الدفعة ─────────────────────────
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
                            Text(
                              material.name,
                              style: TextStyle(
                                fontSize: h * 0.02,
                                fontFamily: cairo,
                                fontWeight: FontWeight.w600,
                                color: constGray,
                              ),
                            ),
                            SizedBox(height: h * 0.015),
                            _InfoRow(
                              label: 'الكمية الكلية في الدفعة',
                              value: c.formattedBatchQuantity,
                            ),
                            SizedBox(height: h * 0.01),
                            _InfoRow(label: 'تاريخ الانتهاء', value: c.dateStr),
                            SizedBox(height: h * 0.01),
                            _InfoRow(label: 'الحالة', value: batch.statusLabel),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.025),

                    // ── حقل الكمية ─────────────────────────────────
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.005,
                      ),
                      child: Text(
                        'الكمية المراد حذفها',
                        style: TextStyle(
                          fontSize: h * 0.017,
                          fontFamily: cairo,
                          fontWeight: FontWeight.w600,
                          color: constGray,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                      child: CustomMyTextFormField(
                        prefixIcon: Icons.numbers_outlined,
                        keyboardType: TextInputType.number,
                        label: 'الكمية المراد حذفها *',
                        hint: 'أدخل الكمية',
                        controller: c.quantityController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى إدخال الكمية';
                          }
                          final n = int.tryParse(value.trim());
                          if (n == null) return 'يرجى إدخال رقم صحيح';
                          if (n <= 0) return 'الكمية يجب ان تكون اكبر من صفر';
                          if (n > batch.quantity) {
                            return 'الكمية المدخلة أكبر من كمية الدفعة (${c.formattedBatchQuantity})';
                          }
                          return null;
                        },
                      ),
                    ),

                    SizedBox(height: h * 0.02),

                    // ── حقل السبب (Dropdown) ────────────────────────
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.005,
                      ),
                      child: Text(
                        'سبب الحذف',
                        style: TextStyle(
                          fontSize: h * 0.017,
                          fontFamily: cairo,
                          fontWeight: FontWeight.w600,
                          color: constGray,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                      child: Obx(
                        () => CustomDropdown<String>(
                          items: kBatchDeletionReasons,
                          labelBuilder: (v) => v,
                          label: 'سبب الحذف *',
                          hint: 'اختر سبب حذف هذه الكمية',
                          icon: Icons.remove_circle_outline,
                          value: c.selectedReason.value,
                          errorBorder: c.reasonError.value,
                          errorText: c.reasonError.value
                              ? 'يرجى اختيار سبب الحذف'
                              : null,
                          onChanged: c.selectReason,
                        ),
                      ),
                    ),

                    // ── حقل نصي إضافي عند اختيار "أخرى" ─────────────
                    Obx(() {
                      if (!c.isOtherSelected) return const SizedBox.shrink();
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: w * 0.03,
                          vertical: h * 0.02,
                        ),
                        child: CustomMyTextFormField(
                          prefixIcon: Icons.edit_note_outlined,
                          label: 'اكتب السبب *',
                          hint: 'اكتب سبب حذف هذه الكمية',
                          controller: c.otherReasonController,
                          validator: (value) {
                            if (!c.isOtherSelected) return null;
                            if (value == null || value.trim().isEmpty) {
                              return 'يرجى إدخال سبب الحذف';
                            }
                            return null;
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

          // ── زر التأكيد ────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.04),
            child: CustomMainButtom(
              title: 'تأكيد الحذف',
              color: constRed,
              fontcolor: Colors.white,
              onPressed: c.confirmDeletion,
            ),
          ),
          SizedBox(height: h * 0.02),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: h * 0.015, color: Colors.grey),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: h * 0.015,
            fontWeight: FontWeight.w600,
            color: constGray,
          ),
        ),
      ],
    );
  }
}
