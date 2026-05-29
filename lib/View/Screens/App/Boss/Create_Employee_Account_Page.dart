import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Visible_Controller.dart';
import 'package:stock_mate_project/Function/Shared/Validation.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Text_Failed.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Drop_Down_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/custom_Head_Card.dart';

// ignore: must_be_immutable
class CreateEmployeeAccountPage extends StatelessWidget {
  CreateEmployeeAccountPage({super.key});
  final String pageName = '/CreateEmployeeAccountPage';
  VisibleController visibleController = Get.put(VisibleController());
  String? email, name, identity, departmentName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<VisibleController>(
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomBackContainer(),
              CustomHeadContainer(
                empName: 'انشاء حساب جديد',
                title: 'انشاء حساب جديد',
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'الرجاء اكمال المعلومات التالية لانشاء موظف جديد',
                  style: TextStyle(
                    color: constGray,
                    fontFamily: lateef,
                    fontSize: 26,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              CustomDropDown(
                itemList: ['مدير المستودع', 'رئيس لجنة الشراء', 'رئيس قسم'],
                hintText: 'الهوية',
                icon: Icon(Icons.person),
                onChanched: (data) {
                  data == 'رئيس قسم'
                      ? controller.isVisible()
                      : controller.isntVisible();
                },
              ),
              Visibility(
                visible: controller.isVisib,
                child: CustomDropDown(
                  itemList: [],
                  hintText: 'القسم',
                  icon: Icon(Icons.person),
                  onChanched: (data) {},
                ),
              ),
              CustomTextFormFaild(
                labelText: 'الاسم',
                icon: Icon(Icons.person),
                onChange: (data) {},
                validator: (data) {
                  return Validation().generalValidation(data!);
                },
              ),
              CustomTextFormFaild(
                labelText: 'البريد الالكتروني',
                icon: Icon(Icons.email_outlined),
                onChange: (data) {},
                validator: (data) {
                  return Validation().emailValidate(data!);
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Align(
                alignment: AlignmentGeometry.center,
                child: CustomButtom(tital: 'تسجيل الدخول', onTap: () {}),
              ),
            ],
          );
        },
      ),
    );
  }
}
