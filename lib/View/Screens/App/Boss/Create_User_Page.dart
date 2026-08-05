import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/CreateUserPageController.dart';
import 'package:stock_mate_project/Controller/Loading%20Indecator%20Controller/Loading_Indicator_Controller.dart';
import 'package:stock_mate_project/core/Function/Validation.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Drop_Down/Custom_My_Drop_Down.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Text_Field/Custom_My_TextFormFaild.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';

class CreateUserPage extends StatelessWidget {
  CreateUserPage({super.key});
  final String pageName = '/CreateUserPage';
  final GlobalKey<FormState> createUserPageKey = GlobalKey();
  final LoadingIndicatorController loadingIndicatorController = Get.put(
    LoadingIndicatorController(),
  );
  Createuserpagecontroller createuserpagecontroller = Get.put(
    Createuserpagecontroller(),
  );
  @override
  Widget build(BuildContext context) {
    print(createuserpagecontroller.roleNames.isEmpty);
    print(createuserpagecontroller.rolesModel.isEmpty);

    return Scaffold(
      body: Form(
        key: createUserPageKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            CustomBackContainer(),
            CustomHeadContainer(title: 'انشاء موظف جديد '),
            GetBuilder<Createuserpagecontroller>(
              builder: (createuserpagecontroller) {
                return createuserpagecontroller.rolesModel.isEmpty
                    ? Expanded(
                        child: Align(
                          alignment: AlignmentGeometry.center,
                          child: CustomLoadingIndicator(),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.screenWidth * 0.02,
                          vertical: context.screenHeight * 0.005,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: context.screenHeight * 0.015,

                            horizontal: context.screenWidth * 0.03, // ← بدل 16
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
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  // horizontal: context.screenWidth * 0.04, // ← بدل 16
                                  vertical:
                                      context.screenHeight * 0.01, // ← بدل 8
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
                                      fontSize:
                                          context.screenHeight *
                                          0.026, // ← بدل 22
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: context.screenHeight * 0.01),

                              CustomDropdown(
                                items: createuserpagecontroller.roleNames,
                                labelBuilder: (v) => v,
                                label: 'الدور الخاص بالمستخدم',
                                hint: '',
                                icon: Icons.rule_outlined,
                                onChanged: (data) {},
                              ),
                              SizedBox(height: context.screenHeight * 0.01),
                              CustomMyTextFormField(
                                label: 'الاسم',
                                hint: '',
                                prefixIcon: Icons.person,
                                validator: (data) =>
                                    Validation().generalValidation(data!),
                              ),
                              SizedBox(height: context.screenHeight * 0.01),
                              CustomMyTextFormField(
                                label: 'لبريد الالكتروني',
                                hint: '',
                                prefixIcon: Icons.email,
                                validator: (data) =>
                                    Validation().emailValidate(data!),
                              ),
                              SizedBox(height: context.screenHeight * 0.01),
                              CustomMyTextFormField(
                                label: 'الاختصاص',
                                hint: '',
                                prefixIcon: Icons.sports_cricket_sharp,
                                validator: (data) =>
                                    Validation().generalValidation(data!),
                              ),
                              SizedBox(height: context.screenHeight * 0.01),
                              Align(
                                alignment: AlignmentGeometry.center,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        context.screenWidth * 0.04, // ← بدل 16
                                    vertical:
                                        context.screenHeight * 0.02, // ← بدل 16
                                  ),
                                  child: GetBuilder<LoadingIndicatorController>(
                                    builder: (controller) {
                                      return CustomMainButtom(
                                        widget: loadingIndicatorController.load
                                            ? CustomLoadingIndicator(
                                                color: constLightBlue,
                                              )
                                            : null,
                                        title: 'تسجيل الدخول',
                                        color: constBlue,
                                        fontcolor: Colors.white,
                                        onPressed: () async {
                                          if (createUserPageKey.currentState!
                                              .validate()) {
                                            loadingIndicatorController.isLoad();

                                            loadingIndicatorController
                                                .isntLoad();
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
