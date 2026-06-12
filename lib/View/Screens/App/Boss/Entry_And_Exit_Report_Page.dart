import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/DatePicker_Controller.dart';
import 'package:stock_mate_project/Controller/Logic/Toggle_Controller.dart';
import 'package:stock_mate_project/Function/Shared/Validation.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Text_Failed.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Toggle_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Drop_Down_Buttom.dart';

class EntryAndExitReportPage extends StatelessWidget {
  EntryAndExitReportPage({super.key});
  final String pageName = '/EntryAndExitReportPage';
  final ToggleController controller = Get.put(ToggleController());
  final DatePickerController datePickerController = Get.put(
    DatePickerController(),
    tag: 'EntryAndExitReportPage',
  );
  final GlobalKey<FormState> entryAndExitReportPageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: entryAndExitReportPageKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomBackContainer(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.screenWidth * 0.04, // ← بدل 16
                vertical: context.screenHeight * 0.015, // ← بدل 12
              ),
              child: Align(
                alignment: AlignmentGeometry.centerRight,
                child: CustomToggleButtom(
                  first: 'المادة',
                  second: 'اليوم',
                  controller: controller,
                ),
              ),
            ),
            Expanded(
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: controller.pageController,
                onPageChanged: (index) =>
                    controller.selectedIndex.value = index,
                children: [
                  // ─── تبويب المادة ─────────────────────────
                  Align(
                    alignment: AlignmentGeometry.topCenter,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.screenWidth * 0.03, // ← بدل 12
                      ),
                      child: Container(
                        height: context.screenHeight * 0.48,
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
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.screenWidth * 0.04,
                                vertical: context.screenHeight * 0.015,
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
                                    fontSize: context.screenHeight * 0.026,
                                  ),
                                ),
                              ),
                            ),
                            CustomDropDown(
                              itemList: [],
                              hintText: 'ادخل المخزون',
                              icon: Icon(Icons.inventory, color: constGray),
                              onChanched: (data) {},
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.screenWidth * 0.04,
                                vertical: context.screenHeight * 0.015,
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
                                  'الاسم',
                                  style: TextStyle(
                                    color: constBlue,
                                    fontFamily: lateef,
                                    fontSize: context.screenHeight * 0.026,
                                  ),
                                ),
                              ),
                            ),
                            CustomTextFormFaild(
                              labelText: 'ادخل الاسم',
                              onChange: (data) {},
                              validator: (data) {
                                return Validation().generalValidation(data!);
                              },
                            ),
                            SizedBox(height: context.screenHeight * 0.03),
                            Align(
                              alignment: AlignmentGeometry.center,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      context.screenWidth * 0.06, // ← بدل 24
                                ),
                                child: CustomButtom(
                                  tital: 'طلب تقرير',
                                  onTap: () {},
                                ),
                              ),
                            ),
                            SizedBox(height: context.screenHeight * 0.03),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ─── تبويب اليوم ──────────────────────────
                  Align(
                    alignment: AlignmentGeometry.topCenter,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.screenWidth * 0.03,
                      ),
                      child: Container(
                        height: context.screenHeight * 0.48,
                        padding: EdgeInsets.symmetric(
                          vertical: context.screenHeight * 0.015,
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
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.screenWidth * 0.04,
                                vertical: context.screenHeight * 0.015,
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
                                    fontSize: context.screenHeight * 0.026,
                                  ),
                                ),
                              ),
                            ),
                            CustomDropDown(
                              itemList: [],
                              hintText: 'ادخل المخزون',
                              icon: Icon(Icons.inventory, color: constGray),
                              onChanched: (data) {},
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.screenWidth * 0.04,
                                vertical: context.screenHeight * 0.015,
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
                                  'الاسم',
                                  style: TextStyle(
                                    color: constBlue,
                                    fontFamily: lateef,
                                    fontSize: context.screenHeight * 0.026,
                                  ),
                                ),
                              ),
                            ),
                            CustomDropDown(
                              itemList: [],
                              hintText: 'ادخل المخزون',
                              icon: Icon(Icons.inventory, color: constGray),
                              onChanched: (data) {},
                            ),
                            SizedBox(height: context.screenHeight * 0.03),
                            Align(
                              alignment: AlignmentGeometry.center,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.screenWidth * 0.06,
                                ),
                                child: CustomButtom(
                                  tital: 'طلب تقرير',
                                  onTap: () {},
                                ),
                              ),
                            ),
                            SizedBox(height: context.screenHeight * 0.03),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
