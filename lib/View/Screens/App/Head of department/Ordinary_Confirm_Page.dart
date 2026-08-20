// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/AddOrdinaryOrder_Controller.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Name_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Build_Row.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Confirm_Section.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';

class OrdinaryConfirmPage extends GetView<AddOrdinaryOrderController> {
  const OrdinaryConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Obx(() {
        final request = controller.createdRequest.value;

        if (request == null) {
          return const Center(child: CustomLoadingIndicator());
        }

        final now = request.createdAt;
        final formattedDate =
            '${now.day}/${now.month}/${now.year}  '
            '${now.hour.toString().padLeft(2, '0')}:'
            '${now.minute.toString().padLeft(2, '0')}';

        return Column(
          children: [
            CustomBackContainer(),
            CustomNameContainer(
              specializationName: 'الرجاء تأكيد بيانات الطلب قبل الإرسال',
              empName: request.requestedBy?.fullName ?? '—',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.04,
                  vertical: h * 0.01,
                ),
                child: Column(
                  children: [
                    BuildSection(
                      title: 'بيانات المُرسِل',
                      icon: Icons.person_outline_rounded,
                      children: [
                        BuildRow(
                          label: 'الطبيب المُرسِل',
                          value: request.requestedBy?.fullName ?? '—',
                        ),
                        BuildRow(
                          label: 'القسم',
                          value: request.department?.name ?? '—',
                        ),
                        BuildRow(
                          label: 'نوع الطلب',
                          value: request.requestType,
                        ),
                        BuildRow(label: 'الأولوية', value: request.priority),
                        BuildRow(
                          label: 'عدد الأصناف',
                          value: '${request.items.length}',
                        ),
                        BuildRow(label: 'تاريخ الإنشاء', value: formattedDate),
                        BuildRow(
                          label: 'الحالة الحالية',
                          value: request.status.displayName,
                        ),
                        if (request.notes != null && request.notes!.isNotEmpty)
                          BuildRow(label: 'الملاحظات', value: request.notes!),
                      ],
                    ),
                    SizedBox(height: h * 0.01),
                    ...List.generate(request.items.length, (i) {
                      final item = request.items[i];
                      return Padding(
                        padding: EdgeInsets.only(bottom: h * 0.015),
                        child: BuildSection(
                          title: request.items.length == 1
                              ? 'تفاصيل الصنف'
                              : 'تفاصيل الصنف ${i + 1}',
                          icon: Icons.medical_services_outlined,
                          children: [
                            BuildRow(
                              label: 'اسم المادة',
                              value: item.variant?.variantName ?? '—',
                            ),
                            BuildRow(
                              label: 'الكمية المطلوبة',
                              value: '${item.requestedQuantity}',
                            ),
                            BuildRow(
                              label: 'الSKU',
                              value: item.variant?.sku ?? '—',
                            ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: h * 0.01),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: h * 0.02, top: h * 0.01),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Obx(() {
                return CustomMainButtom(
                  title: controller.isLoading.value
                      ? 'جاري الإرسال...'
                      : 'تأكيد وإرسال للمشفى',
                  color: constBlue,
                  fontcolor: Colors.white,
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.confirmRequest,
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}