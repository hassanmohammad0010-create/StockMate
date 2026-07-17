// //  ignore_for_file: file_names

// import 'package:get/get.dart';

// class FilterController extends GetxController {
//   final RxString selectedFilter = ''.obs;
//   final RxList<String> filters = <String>[].obs;
//   final RxString searchQuery = ''.obs;

//   void initFilters(List<String> newFilters) {
//     filters.assignAll(newFilters);
//     selectedFilter.value = newFilters.first;
//   }

//   void selectFilter(String filter) => selectedFilter.value = filter;
//   bool isSelected(String filter) => selectedFilter.value == filter;
//   void updateSearch(String query) => searchQuery.value = query;

//   @override
//   void onClose() {
//     // يُستدعى تلقائيًا عند حذف الكونترولر من الذاكرة (مغادرة الصفحة)
//     super.onClose();
//   }
// }
//  ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {
  final RxString selectedFilter = ''.obs;
  final RxList<String> filters = <String>[].obs;
  final RxString searchQuery = ''.obs;

  /// كونترولر حقل البحث بات يعيش هنا، تحت إدارة GetX نفسها.
  /// يُنشأ في onInit ويُتخلص منه في onClose تلقائياً مع الكونترولر،
  /// فما تحتاج StatefulWidget ولا dispose يدوي بالصفحة.
  late final TextEditingController searchController;

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
  }

  void initFilters(List<String> newFilters) {
    filters.assignAll(newFilters);
    selectedFilter.value = newFilters.first;
  }

  void selectFilter(String filter) => selectedFilter.value = filter;
  bool isSelected(String filter) => selectedFilter.value == filter;
  void updateSearch(String query) => searchQuery.value = query;

  /// يمسح النص من الحقل نفسه ومن قيمة البحث بنفس الوقت.
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  @override
  void onClose() {
    // يُستدعى تلقائيًا عند حذف الكونترولر من الذاكرة (مغادرة الصفحة)
    searchController.dispose();
    super.onClose();
  }
}