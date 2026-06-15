// ignore_for_file: avoid_unnecessary_containers, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/PrescriptionController.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Prescription_Card.dart';

class SendPrescriptionPage extends StatelessWidget {
  const SendPrescriptionPage({super.key});

  final String pageName = '/SendPrescriptionPage';

  @override
  Widget build(BuildContext context) {
    final PrescriptionController controller = Get.put(PrescriptionController());

    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            CustomBackContainer(),
            SizedBox(height: h * 0.01),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                  child: Column(
                    children: [
                      CustomHeadContainer(title: 'إرسال وصفة طبية'),
                      SizedBox(height: h * 0.01),
                      CustomPrescriptionCard(),
                      SizedBox(height: h * 0.02),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.05,
                vertical: h * 0.01,
              ),
              child: Divider(),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: h * 0.02),
              child: CustomMainButtom(
                title: 'تأكيد الارسال',
                color: constBlue,
                fontcolor: Colors.white,
                onPressed: () {
                  if (controller.formKey.currentState!.validate()) {
                    Get.snackbar(
                      'تم الإرسال ✓',
                      'تم إرسال الوصفة بنجاح',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.green.shade600,
                      colorText: Colors.white,
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
