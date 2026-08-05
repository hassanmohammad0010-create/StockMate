// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {
  final RxString selectedFilter = ''.obs;
  final RxList<String> filters = <String>[].obs;
  final RxString searchQuery = ''.obs;

  late final TextEditingController searchController;

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
  }

  void initFilters(List<String> newFilters) {
    filters.assignAll(newFilters);
    if (newFilters.isNotEmpty && selectedFilter.value.isEmpty) {
      selectedFilter.value = newFilters.first;
    }
  }

  void selectFilter(String filter) => selectedFilter.value = filter;
  void setFilter(String filter) => selectedFilter.value = filter;
  bool isSelected(String filter) => selectedFilter.value == filter;
  void updateSearch(String query) => searchQuery.value = query;

  void resetFilter() => selectedFilter.value = filters.isNotEmpty ? filters.first : '';

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}