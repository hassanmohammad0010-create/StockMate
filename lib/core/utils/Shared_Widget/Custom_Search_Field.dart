// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';

class CustomSearchField extends StatelessWidget {
  CustomSearchField({super.key});

  final FilterController filterController = Get.find(
    tag: 'DepartmentHeadsInventoryPage',
  );

  final TextEditingController _searchController = TextEditingController();
  String normalizeArabic(String text) {
    return text
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 12),
      child: TextField(
        controller: _searchController,
        textDirection: TextDirection.rtl,
        onChanged: (value) => filterController.updateSearch(value),
        style: TextStyle(fontFamily: cairo, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'ابحث بالاسم أو الرقم  .....',
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
            () => filterController.searchQuery.value.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      filterController.updateSearch('');
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
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
    );
  }

  Widget buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'لا توجد نتائج',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade500,
              fontFamily: cairo,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'جرّب كلمة بحث مختلفة',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade400,
              fontFamily: cairo,
            ),
          ),
        ],
      ),
    );
  }
}
