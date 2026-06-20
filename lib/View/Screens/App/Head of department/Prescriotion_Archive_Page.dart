// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/SendPrescriptionController.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Patient_Search_Field.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/PrescriptionArchiveCard.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/showPrescriptionArchiveDetails.dart';

class PrescriptionArchivePage extends StatelessWidget {
  PrescriptionArchivePage({super.key});

  final TextEditingController _searchController = TextEditingController();

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
            CustomHeadContainer(title: 'أرشيف الوصفات الطبية'),
            PatientSearchField(
              controller: _searchController,
              onChanged: controller.updateSearch,
              onClear: () {
                controller.updateSearch('');
              },
            ),
            Expanded(
              child: Obx(() {
                final list = controller.filteredPrescriptions;
                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          controller.searchQuery.value.isEmpty
                              ? 'لا توجد وصفات في الأرشيف بعد'
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
                    padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.02),
                    child: Column(
                      children: list
                          .map(
                            (p) => PrescriptionArchiveCard(
                              prescription: p,
                              onTap: () =>
                                  showPrescriptionArchiveDetails(context, p),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
