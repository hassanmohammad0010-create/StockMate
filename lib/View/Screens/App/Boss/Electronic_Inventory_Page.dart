import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/DatePicker_Controller.dart';
import 'package:stock_mate_project/Function/Shared/Validation.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Text_Failed.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Drop_Down_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';

class ElectronicInventoryPage extends StatelessWidget {
  const ElectronicInventoryPage({super.key});
  final String pageName = '/ElectronicInventoryPage';

  @override
  Widget build(BuildContext context) {
    final DatePickerController controller = Get.put(DatePickerController());

    return Scaffold(
      body: Column(
        children: [
          CustomBackContainer(),
          CustomHeadContainer(title: 'تقرير جرد الكتروني'),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.screenWidth * 0.03, // ← بدل 12
              vertical: context.screenHeight * 0.005, // ← بدل 4
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: context.screenHeight * 0.015, // ← بدل 12
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 8,
                    offset: Offset(0, 0),
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── المستودع ─────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.screenWidth * 0.04, // ← بدل 16
                      vertical: context.screenHeight * 0.01, // ← بدل 8
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: context.screenWidth * 0.25,
                      height: context.screenHeight * 0.05,
                      decoration: BoxDecoration(
                        color: constLightBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'المستودع',
                        style: TextStyle(
                          color: constBlue,
                          fontFamily: lateef,
                          fontSize: context.screenHeight * 0.026, // ← بدل 22
                        ),
                      ),
                    ),
                  ),
                  CustomDropDown(
                    itemList: [],
                    hintText: 'ادخل المستودع',
                    icon: Icon(Icons.inventory, color: constGray),
                    onChanched: (data) {},
                  ),
                  // ─── من تاريخ ─────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.screenWidth * 0.04,
                      vertical: context.screenHeight * 0.01,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: context.screenWidth * 0.25,
                      height: context.screenHeight * 0.05,
                      decoration: BoxDecoration(
                        color: constLightBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'من تاريخ',
                        style: TextStyle(
                          color: constBlue,
                          fontFamily: lateef,
                          fontSize: context.screenHeight * 0.026,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => CustomTextFormFaild(
                      labelText: 'اختيار تاريخ',
                      textEditingController: controller.fromDateTextController,
                      onChange: (data) {},
                      icon: Icon(Icons.date_range, color: constGray),
                      validator: (data) {
                        return Validation().generalValidation(data!);
                      },
                      readOnly: true,
                      onTap: () => controller.pickFromDate(context),
                      suffixIcon: controller.hasFromDate
                          ? IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.grey,
                                size: context.screenHeight * 0.024, // ← بدل 20
                              ),
                              onPressed: controller.clearFromDate,
                            )
                          : null,
                    ),
                  ),
                  // ─── الى تاريخ ────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.screenWidth * 0.04,
                      vertical: context.screenHeight * 0.01,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: context.screenWidth * 0.25,
                      height: context.screenHeight * 0.05,
                      decoration: BoxDecoration(
                        color: constLightBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'الى تاريخ',
                        style: TextStyle(
                          color: constBlue,
                          fontFamily: lateef,
                          fontSize: context.screenHeight * 0.028, // ← بدل 24
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => CustomTextFormFaild(
                      labelText: 'اختيار تاريخ',
                      textEditingController: controller.toDateTextController,
                      onChange: (data) {},
                      icon: Icon(Icons.date_range, color: constGray),
                      validator: (data) {
                        return Validation().generalValidation(data!);
                      },
                      readOnly: true,
                      onTap: () => controller.pickToDate(context),
                      suffixIcon: controller.hasToDate
                          ? IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.grey,
                                size: context.screenHeight * 0.024,
                              ),
                              onPressed: controller.clearToDate,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(height: context.screenHeight * 0.01),
                  Align(
                    alignment: AlignmentGeometry.center,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.screenWidth * 0.04, // ← بدل 16
                        vertical: context.screenHeight * 0.02, // ← بدل 16
                      ),
                      child: CustomButtom(tital: 'تأكيد', onTap: () {}),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
