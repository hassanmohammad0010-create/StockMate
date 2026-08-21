// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Service/Batch_Deletion_Controller.dart';
import 'package:stock_mate_project/core/models/New_MaterialItem.dart'; 
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Drop_Down/Custom_My_Drop_Down.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Text_Field/Custom_My_TextFormFaild.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/custom_Head_Card.dart';

/// صفحة إتلاف/تسوية كمية من دفعة معينة
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

    // ✅✅✅ الـ tag يستخدم variantId و batchId من الموديل الجديد
    final c = Get.put(
      BatchDeletionController(material: material, batch: batch),
      tag: '${material.variantId}_${batch.batchId}',
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
                    const CustomHeadContainer(title: 'إتلاف كمية من الدفعة'),
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
                        'الكمية المراد إتلافها',
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
                        label: 'الكمية المراد إتلافها *',
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

                    // ── حقل نوع التسوية (عربي → إنكليزي) ────────────
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.005,
                      ),
                      child: Text(
                        'نوع التسوية',
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
                          items:
                              BatchDeletionController.adjustmentReasonsArabic,
                          labelBuilder: (v) => v,
                          label: 'نوع التسوية *',
                          hint: 'اختر نوع التسوية',
                          icon: Icons.remove_circle_outline,
                          searchable: false,
                          value: c.selectedReason.value.isEmpty
                              ? null
                              : c.selectedReason.value,
                          errorBorder: c.reasonError.value,
                          errorText: c.reasonError.value
                              ? 'يرجى اختيار نوع التسوية'
                              : null,
                          onChanged: c.selectReason,
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.02),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.005,
                      ),
                      child: Text(
                        'اضافة ملاحظة',
                        style: TextStyle(
                          fontSize: h * 0.017,
                          fontFamily: cairo,
                          fontWeight: FontWeight.w600,
                          color: constGray,
                        ),
                      ),
                    ),
                    // ── حقل الملاحظات (اختياري) ─────────────────────
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                      child: CustomMyTextFormField(
                        prefixIcon: Icons.edit_note_outlined,
                        label: 'ملاحظات (اختياري)',
                        hint: 'مثال: تلف أثناء النقل، نقص من الرف...',
                        controller: c.notesController,
                      ),
                    ),

                    SizedBox(height: h * 0.03),
                  ],
                ),
              ),
            ),
          ),

          // ── زر التأكيد ────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.04),
            child: Obx(() {
              final submitting = c.isSubmitting.value;
              return CustomMainButtom(
                title: submitting ? 'جارٍ الإتلاف...' : 'تأكيد الإتلاف',
                color: submitting ? constLightRed : constRed,
                fontcolor: submitting ? constRed : Colors.white,
                onPressed: submitting ? null : c.confirmDeletion,
              );
            }),
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
