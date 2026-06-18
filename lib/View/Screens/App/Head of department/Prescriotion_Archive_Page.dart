// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/PrescriptionController.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/CustomArchivePrescriptionCard.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';

class PrescriptionArchivePage extends StatelessWidget {
  PrescriptionArchivePage({super.key});


  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final PrescriptionController controller =
        Get.isRegistered<PrescriptionController>()
            ? Get.find<PrescriptionController>()
            : Get.put(PrescriptionController(), permanent: true);

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
            CustomHeadContainer(title: 'أرشيف الوصفات الطبية'),
            Padding(
              padding: EdgeInsets.fromLTRB(w * 0.04, h * 0.015, w * 0.04, h * 0.01),
              child: TextField(
                controller: _searchController,
                textDirection: TextDirection.rtl,
                onChanged: controller.updateSearch,
                style: TextStyle(fontFamily: cairo, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'ابحث باسم المريض .....',
                  hintStyle: TextStyle(
                    fontFamily: cairo,
                    fontSize: 14,
                    color: Colors.grey.shade400,
                  ),
                  hintTextDirection: TextDirection.rtl,
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.grey.shade400,
                    size: 22,
                  ),
                  suffixIcon: Obx(
                    () => controller.searchQuery.value.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              controller.updateSearch('');
                            },
                            child: Icon(
                              Icons.close_rounded,
                              color: Colors.grey.shade400,
                              size: 20,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: constBlue, width: 1.5),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                final list = controller.filteredPrescriptions;

                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          controller.searchQuery.value.isEmpty
                              ? 'لا توجد وصفات في الأرشيف بعد'
                              : 'لا توجد نتائج',
                          style: TextStyle(fontSize: 16, color: Colors.grey.shade500, fontFamily: cairo),
                        ),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                    child: Column(
                      children: list
                          .map((p) => CustomArchivePrescriptionCard(prescription: p))
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