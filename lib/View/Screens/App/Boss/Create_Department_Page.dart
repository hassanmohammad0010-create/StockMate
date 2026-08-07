import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Create_Department_Page_Controller.dart';
import 'package:stock_mate_project/Controller/Loading%20Indecator%20Controller/Loading_Indicator_Controller.dart';
import 'package:stock_mate_project/Service/App/Create_Department_Service.dart';
import 'package:stock_mate_project/core/Function/Validation.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Drop_Down/Custom_My_Drop_Down.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Text_Field/Custom_My_TextFormFaild.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';

class CreateDepartmentPage extends StatelessWidget {
  CreateDepartmentPage({super.key});
  final String pageName = '/CreateDepartmentPage';
  final GlobalKey<FormState> createDepartmentPageKey = GlobalKey();
  final LoadingIndicatorController loadingIndicatorController = Get.put(
    LoadingIndicatorController(),
  );
  final TextEditingController nameController = TextEditingController();
  List<String> departmentType = ['مخزن مركزي', 'صيدلية', 'قسم اعتيادي'];
  Map<String, String> depType = {
    'مخزن مركزي': ' central_warehouse',
    'صيدلية': 'pharmacy',
    'قسم اعتيادي': 'standard',
  };
  String? name, type;
  CreateDepartmentPageController createDepartmentPageController = Get.put(
    CreateDepartmentPageController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: createDepartmentPageKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            CustomBackContainer(),
            CustomHeadContainer(title: 'انشاء قسم جديد '),
            Padding(
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
                        vertical: context.screenHeight * 0.01, // ← بدل 8
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        width: context.screenWidth * 0.32,
                        height: context.screenHeight * 0.05,
                        decoration: BoxDecoration(
                          color: constLightBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'ادخل المعلومات',
                          style: TextStyle(
                            color: constBlue,
                            fontFamily: lateef,
                            fontSize: context.screenHeight * 0.026, // ← بدل 22
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: context.screenHeight * 0.01),

                    CustomMyTextFormField(
                      controller: nameController,
                      label: 'الاسم',
                      hint: '',
                      prefixIcon: Icons.person,
                      onChanged: (data) {
                        name = data;
                      },
                      validator: (data) =>
                          Validation().generalValidation(data!),
                    ),

                    SizedBox(height: context.screenHeight * 0.01),
                    Obx(
                      () => CustomDropdown<String>(
                        items: departmentType,
                        labelBuilder: (v) => v,
                        label: 'النوع الخاص بالقسم',
                        hint: '',
                        validator: (data) =>
                            data == null ? 'الحقل ضروري' : null,
                        icon: Icons.rule_outlined,
                        value:
                            createDepartmentPageController.selectedType.value,
                        onChanged: (data) {
                          createDepartmentPageController.selectedType.value =
                              data;
                        },
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
                        child: GetBuilder<LoadingIndicatorController>(
                          builder: (controller) {
                            return CustomMainButtom(
                              widget: loadingIndicatorController.load
                                  ? CustomLoadingIndicator(
                                      color: constLightBlue,
                                    )
                                  : null,
                              title: 'تأكيد',
                              color: constBlue,
                              fontcolor: Colors.white,
                              onPressed: () async {
                                if (createDepartmentPageKey.currentState!
                                    .validate()) {
                                  loadingIndicatorController.isLoad();
                                  type =
                                      depType[createDepartmentPageController
                                          .selectedType
                                          .value];
                                  bool response =
                                      await DepartmentService.createDepartment(
                                        name: name!,
                                        type: type!,
                                        hasQueue: true,
                                      );
                                  if (response) {
                                    nameController.clear();
                                    createDepartmentPageController
                                            .selectedType
                                            .value =
                                        null;

                                    name = null;
                                    type = null;
                                  }
                                  loadingIndicatorController.isntLoad();
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
            ),
          ],
        ),
      ),
    );
  }
}
