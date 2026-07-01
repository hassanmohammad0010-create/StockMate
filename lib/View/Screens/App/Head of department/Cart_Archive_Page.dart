// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/ArchiveController.dart';
import 'package:stock_mate_project/Controller/Logic/DatePicker_Controller.dart';
import 'package:stock_mate_project/Function/Shared/Validation.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Cart_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Text_Form_Faild_For_Date.dart';

class CartArchivePage extends StatelessWidget {
  const CartArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ArchiveController controller = ArchiveController.to;

    final DatePickerController datePickerController = Get.put(
      DatePickerController(),
    );

    void applyDateFilter() {
      controller.filterByDate(datePickerController.fromDateTextController.text);
    }

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          CustomBackContainer(),
          SizedBox(height: context.screenHeight * 0.01),
          CustomHeadContainer(title: 'أرشيف السلة'),
          Obx(
            () => TextFormFaildForDate(
              labelText: 'اختيار تاريخ',
              textEditingController:
                  datePickerController.fromDateTextController,
              onChange: (data) {
                controller.filterByDate(data);
              },
              icon: Icon(
                Icons.edit_calendar_rounded,
                color: Colors.grey.shade600,
              ),
              validator: (data) {
                return Validation().generalValidation(data!);
              },
              readOnly: true,
              onTap: () async {
                await datePickerController.pickFromDate(
                  context,
                  onDateSelected: applyDateFilter,
                );
              },
              suffixIcon: datePickerController.hasFromDate
                  ? IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: context.screenHeight * 0.024,
                      ),
                      onPressed: () {
                        datePickerController.clearFromDate();
                        controller.filterByDate(null);
                      },
                    )
                  : null,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.filteredArchiveList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 64,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(height: context.screenHeight * 0.02),
                      Text(
                        controller.filteredArchiveList.isEmpty
                            ? 'لا توجد سلات في الأرشيف بعد'
                            : 'لا توجد نتائج',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade500,
                          fontFamily: cairo,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.screenWidth * 0.02,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: context.screenHeight * 0.01),
                      ...controller.filteredArchiveList.map((item) {
                        return CustomCartContainer(
                          buttonText: 'عرض التفاصيل',
                          title: 'السلة',
                          subtitle: 'التاريخ: ${item.date}',
                          onTap: () => controller.goToDetails(item),
                          buttonColor: constLightBlue,
                          buttonTextColor: constBlue,
                        );
                      }),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
