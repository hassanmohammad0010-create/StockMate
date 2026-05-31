import 'package:get/get.dart';

class FilterController extends GetxController {
  final RxString selectedFilter = ''.obs;
  final RxList<String> filters = <String>[].obs; // ✅ String مباشرة

  void initFilters(List<String> newFilters) {
    filters.assignAll(newFilters);
    selectedFilter.value = newFilters.first;
  }

  void selectFilter(String filter) => selectedFilter.value = filter;
  bool isSelected(String filter) => selectedFilter.value == filter;
}
