// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/AddRecurringOrder_Controller.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';

class RecurringConfirmPage extends GetView<AddRecurringOrderController> {
  const RecurringConfirmPage({super.key});

  final String pageName = '/RecurringConfirmPage';

  // ─── بيانات ثابتة ترسل مع كل طلب ───────────────────────────────────────
  static const String _doctorName = 'د. محمد علي';
  static const String _departmentName = 'قسم الداخلية';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final order = controller.order.value;
    final now = DateTime.now();

    final String formattedDate =
        '${now.day}/${now.month}/${now.year}  ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final String recurringLabel =
        AddRecurringOrderController.recurringLabels[controller
            .selectedRecurring
            .value] ??
        '';

    return Scaffold(
      backgroundColor: constBackgroundColor,
      appBar: AppBar(
        backgroundColor: constBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'تأكيد الطلب',
          style: TextStyle(
            fontFamily: cairo,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04,
                vertical: size.height * 0.01,
              ),
              child: Column(
                children: [
                  // ── أيقونة التأكيد ────────────────────────────────────
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: constBlue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.fact_check_outlined,
                      size: 40,
                      color: constBlue,
                    ),
                  ),
                  SizedBox(height: size.height * 0.015),
                  Text(
                    'يرجى مراجعة تفاصيل الطلب قبل الإرسال',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: cairo,
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  SizedBox(height: size.height * 0.025),

                  // ── البيانات الثابتة ──────────────────────────────────
                  _buildSection(
                    title: 'بيانات المُرسِل',
                    icon: Icons.person_outline_rounded,
                    children: [
                      _buildRow('الطبيب المُرسِل', _doctorName),
                      _buildRow('القسم', _departmentName),
                      // _buildRow('نوع الطلب', 'دوري'),
                      // _buildRow('تاريخ الإرسال', formattedDate),
                    ],
                  ),
                  SizedBox(height: size.height * 0.015),
                  // ── بيانات الطلب ──────────────────────────────────────
                  _buildSection(
                    title: 'تفاصيل الطلب',
                    icon: Icons.medical_services_outlined,
                    children: [
                      _buildRow('اسم المادة', order.medicineName ?? '—'),
                      _buildRow('الكمية', controller.quantityController.text),
                      _buildRow('الوحدة', order.unit ?? '—'),
                      _buildRow('الوكيل / الماركة', order.brand ?? '—'),
                      _buildRow('نوع الطلب', 'دوري'),

                      _buildRow('التكرار', recurringLabel),
                      _buildRow('تاريخ الإرسال', formattedDate),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── أزرار التحكم ──────────────────────────────────────────────
          _buildBottomActions(size),
        ],
      ),
    );
  }

  // ─── Section Card ─────────────────────────────────────────────────────────
  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان القسم
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(icon, size: 20, color: constBlue),
                const SizedBox(width: 8),

                Text(
                  title,
                  style: TextStyle(
                    fontFamily: cairo,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  // ─── Row واحد ─────────────────────────────────────────────────────────────
  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment:
            CrossAxisAlignment.start, // ✅ محاذاة للأعلى عند تعدد الأسطر
        children: [
          // التسمية على اليمين
          Text(
            label,
            style: TextStyle(
              fontFamily: cairo,
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),

          // ignore: sized_box_for_whitespace
          Container(
            width: 90,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: cairo,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
  // ─── أزرار أسفل الصفحة ───────────────────────────────────────────────────
  Widget _buildBottomActions(Size size) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, size.height * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // زر تأكيد الإرسال
          Obx(() {
            final loading = controller.isLoading.value;
            return CustomMainButtom(
              title: loading ? 'جاري الإرسال ...' : 'تأكيد الإرسال',
              color: constBlue,
              fontcolor: Colors.white,
              onPressed: loading ? () {} : controller.submitOrder,
            );
          }),
          const SizedBox(height: 10),

          // زر العودة والتعديل
          CustomMainButtom(
            title: 'العودة والتعديل',
            color: Colors.grey.shade100,
            fontcolor: Colors.grey.shade700,
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }
}
