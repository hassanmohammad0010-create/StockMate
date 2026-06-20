// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/AddOrdinaryOrder_Controller.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Name_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Ordienary_Bottom.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Build_Row.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Confirm_Section.dart';

class OrdinaryConfirmPage extends GetView<AddOrdinaryOrderController> {
  const OrdinaryConfirmPage({super.key});


  static const String _doctorName = 'د. محمد علي';
  static const String _departmentName = 'قسم الداخلية';

  @override
  Widget build(BuildContext context) {

    final orders = controller.orders;
    final now = DateTime.now();

    final String formattedDate =
        '${now.day}/${now.month}/${now.year}  '
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          CustomBackContainer(),
          CustomNameContainer(
            specializationName: 'الرجاء تأكيد بيانات الطلبات قبل الإرسال',
            empName: _doctorName,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: context.screenWidth * 0.04,
                vertical: context.screenHeight * 0.01,
              ),
              child: Column(
                children: [
                  BuildSection(
                    title: 'بيانات المُرسِل',
                    icon: Icons.person_outline_rounded,
                    children: [
                      BuildRow(label: 'الطبيب المُرسِل', value: _doctorName),
                      BuildRow(label: 'القسم', value: _departmentName),
                      BuildRow(label: 'نوع الطلب', value: 'اعتيادي'),
                      BuildRow(label: 'عدد الطلبات', value: '${orders.length}'),
                      BuildRow(label: 'تاريخ الإرسال', value: formattedDate),
                    ],
                  ),
                  SizedBox(height: context.screenHeight * 0.01),
                  ...List.generate(orders.length, (i) {
                    final o = orders[i];
                    final qtyCtrl = controller.quantityCtrl(i);
                    final priority = o.priority;
                    return Padding(
                      padding: EdgeInsets.only(bottom: context.screenHeight * 0.015),
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
                  SizedBox(height: context.screenHeight * 0.01),
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
