import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/DatePicker_Controller.dart';
import 'package:stock_mate_project/Function/Shared/Validation.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Text_Failed.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Drop_Down_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/custom_Head_Card.dart';

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
          CustomHeadContainer(title: 'تقرير جرد الكتروني', empName: ''),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: constLightBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'المستودع',
                        style: TextStyle(
                          color: constBlue,
                          fontFamily: lateef,
                          fontSize: 22,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: constLightBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'من تاريخ',
                        style: TextStyle(
                          color: constBlue,
                          fontFamily: lateef,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => CustomTextFormFaild(
                      labelText: 'اختيار تاريخ',
                      textEditingController:
                          controller.fromDateTextController, // ← أضف هذا
                      onChange: (data) {},
                      icon: Icon(Icons.date_range, color: constGray),
                      validator: (data) {
                        return Validation().generalValidation(data!);
                      },
                      readOnly: true,
                      onTap: () => controller.pickFromDate(context),
                      suffixIcon: controller.hasFromDate
                          ? IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.grey,
                                size: 20,
                              ),
                              onPressed: controller.clearFromDate,
                            )
                          : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: constLightBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'الى تاريخ',
                        style: TextStyle(
                          color: constBlue,
                          fontFamily: lateef,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => CustomTextFormFaild(
                      labelText: 'اختيار تاريخ',
                      textEditingController:
                          controller.toDateTextController, // ← أضف هذا
                      onChange: (data) {},
                      icon: Icon(Icons.date_range, color: constGray),
                      validator: (data) {
                        return Validation().generalValidation(data!);
                      },
                      readOnly: true,
                      onTap: () => controller.pickToDate(context),
                      suffixIcon: controller.hasToDate
                          ? IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.grey,
                                size: 20,
                              ),
                              onPressed: controller.clearToDate,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Align(
                    alignment: AlignmentGeometry.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
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
