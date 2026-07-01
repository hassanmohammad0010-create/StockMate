// ignore_for_file: avoid_unnecessary_containers, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/SendPrescriptionController.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/Custom_Dialog.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/DialogType.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Send_Prescription_Card.dart';

class SendPrescriptionPage extends StatelessWidget {
  const SendPrescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SendPrescriptionController controller =
        Get.isRegistered<SendPrescriptionController>()
        ? Get.find<SendPrescriptionController>()
        : Get.put(SendPrescriptionController(), permanent: true);

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            CustomBackContainer(),
            SizedBox(height: context.screenHeight * 0.01),
            CustomHeadContainer(title: 'إرسال وصفة طبية'),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.screenWidth * 0.02,
                  ),
                  child: Column(
                    children: [
                      CustomPrescriptionCard(),
                      SizedBox(height: context.screenHeight * 0.02),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.screenWidth * 0.05,
                vertical: context.screenHeight * 0.01,
              ),
              child: Divider(),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: context.screenHeight * 0.02),
              child: CustomMainButtom(
                title: 'تأكيد الارسال',
                color: constBlue,
                fontcolor: Colors.white,
                onPressed: () {
                  if (controller.formKey.currentState!.validate()) {
                    controller.addPrescriptionToArchive();

                    CustomDialog.show(
                      type: DialogType.success,
                      title: 'تم الإرسال',
                      message: 'تم إرسال الوصفة بنجاح',
                      showCancel: false,
                    );
                    controller.clearFields();
                    FocusScope.of(context).unfocus();
                  } else {
                    Get.snackbar(
                      'خطأ',
                      'الرجاء ملء جميع الحقول المطلوبة',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red.shade600,
                      colorText: Colors.white,
                    );
                  }
                },
                icon: Icons.telegram,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
