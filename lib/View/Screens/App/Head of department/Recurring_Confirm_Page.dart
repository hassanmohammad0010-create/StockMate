// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/AddRecurringOrder_Controller.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Name_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Build_Row.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Confirm_Section.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Recurring_Bottom.dart';

class RecurringConfirmPage extends GetView<AddRecurringOrderController> {
  const RecurringConfirmPage({super.key});


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
      body: Column(
        children: [
          CustomBackContainer(),
          CustomNameContainer(
            specializationName: 'الرجاء تأكيد بيانات الطلب الدوري قبل الإرسال',
            empName: _doctorName,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04,
                vertical: size.height * 0.01,
              ),
              child: Column(
                children: [
                  BuildSection(
                    title: 'بيانات المُرسِل',
                    icon: Icons.person_outline_rounded,
                    children: [
                      BuildRow(label: 'الطبيب المُرسِل', value: _doctorName),
                      BuildRow(label: 'القسم', value: _departmentName),
                      BuildRow(label: 'نوع الطلب', value: 'دوري'),
                      BuildRow(label: 'تاريخ الإرسال', value: formattedDate),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  BuildSection(
                    title: 'تفاصيل الطلب',
                    icon: Icons.medical_services_outlined,
                    children: [
                      BuildRow(
                        label: 'اسم المادة',
                        value: order.medicineName ?? '—',
                      ),
                      BuildRow(
                        label: 'الكمية',
                        value: controller.quantityController.text.isEmpty
                            ? '—'
                            : controller.quantityController.text,
                      ),
                      BuildRow(label: 'الوحدة', value: order.unit ?? '—'),
                      BuildRow(
                        label: 'الوكيل / الماركة',
                        value: order.brand ?? '—',
                      ),
                      BuildRow(label: 'التكرار', value: recurringLabel),
                    ],
                  ),
                ],
              ),
            ),
          ),
          CustomRecurringBottom(),
        ],
      ),
    );
  }
}
