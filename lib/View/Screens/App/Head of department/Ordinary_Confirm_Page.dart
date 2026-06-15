// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/AddOrdinaryOrder_Controller.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Ordienary_Bottom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Build_Row.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Confirm_Section.dart';

class OrdinaryConfirmPage extends GetView<AddOrdinaryOrderController> {
  const OrdinaryConfirmPage({super.key});

  final String pageName = '/OrdinaryConfirmPage';


  static const String _doctorName = 'د. محمد علي';
  static const String _departmentName = 'قسم الداخلية';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orders = controller.orders;
    final now = DateTime.now();

    final String formattedDate =
        '${now.day}/${now.month}/${now.year}  '
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';

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
                  SizedBox(height: size.height * 0.01),
                  Text(
                    'يرجى مراجعة تفاصيل الطلبات قبل الإرسال',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: cairo,
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  BuildSection(
                    title: 'بيانات المُرسِل',
                    icon: Icons.person_outline_rounded,
                    children: [
                      // _buildRow('الطبيب المُرسِل', _doctorName),
                      BuildRow(label: 'الطبيب المُرسِل', value: _doctorName),
                      BuildRow(label: 'القسم', value: _departmentName),
                      BuildRow(label: 'نوع الطلب', value: 'اعتيادي'),
                      BuildRow(label: 'عدد الطلبات', value: '${orders.length}'),
                      BuildRow(label: 'تاريخ الإرسال', value: formattedDate),
                    ],
                  ),
                  SizedBox(height: size.height * 0.02),
                  ...List.generate(orders.length, (i) {
                    final o = orders[i];
                    final qtyCtrl = controller.quantityCtrl(i);
                    final priority = o.priority;
                    return Padding(
                      padding: EdgeInsets.only(bottom: size.height * 0.015),
                      child: BuildSection(
                        title: orders.length == 1
                            ? 'تفاصيل الطلب'
                            : 'تفاصيل الطلب ${i + 1}',
                        icon: Icons.medical_services_outlined,
                        children: [
                          BuildRow(
                            label: 'اسم المادة',
                            value: o.medicineName ?? '—',
                          ),
                          BuildRow(
                            label: 'الكمية',
                            value: qtyCtrl.text.isEmpty ? '—' : qtyCtrl.text,
                          ),
                          BuildRow(label: 'الوحدة', value: o.unit ?? '—'),
                          BuildRow(label: 'الماركة', value: o.brand ?? '—'),
                          BuildRow(label: 'الأولوية', value: priority),
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: size.height * 0.01),
                ],
              ),
            ),
          ),
          CustomOrdinaryBottom(),
        ],
      ),
    );
  }
}
