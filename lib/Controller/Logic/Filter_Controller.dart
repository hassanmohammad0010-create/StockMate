// ignore_for_file: file_names
import 'package:get/get.dart';

class FilterController extends GetxController {
  final RxString selectedFilter = ''.obs;
  final RxList<String> filters = <String>[].obs;
  final RxString searchQuery = ''.obs; 

  void initFilters(List<String> newFilters) {
    filters.assignAll(newFilters);
    selectedFilter.value = newFilters.first;
  }

  void selectFilter(String filter) => selectedFilter.value = filter;
  bool isSelected(String filter) => selectedFilter.value == filter;
  void updateSearch(String query) => searchQuery.value = query; 
}
