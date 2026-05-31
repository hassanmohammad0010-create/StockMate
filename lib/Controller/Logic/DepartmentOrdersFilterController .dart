// ignore_for_file: file_names

import 'package:get/get.dart';

class DepartmentOrdersFilterController extends GetxController {
  final RxString selectedFilter = 'الكل'.obs;

  final List<String> filters = [
    'الكل',
    'الطلبات الدورية',
    'معلق',
    'قيد التنفيذ',
    'منجز',
    'مرفوض',
  ];

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  void resetFilter() {
    selectedFilter.value = 'الكل';
  }
}