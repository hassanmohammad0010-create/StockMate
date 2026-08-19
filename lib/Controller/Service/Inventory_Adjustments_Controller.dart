// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Service/Get_Name_Roll_Of_User.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Get_Inventory_Adjustments_Service.dart';
import 'package:stock_mate_project/core/models/Inventory_Adjustments_Model.dart';

class InventoryAdjustmentsController extends GetxController {
  final GetInventoryAdjustmentsService _adjustmentsService =
      GetInventoryAdjustmentsService();

  late final GetNameRollOfUserController getNameRollOfUserController;

  // ─── Reactive state ───────────────────────────────────────────────
  final RxList<InventoryAdjustment> adjustments = <InventoryAdjustment>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;

  // ─── Pagination ───────────────────────────────────────────────────
  final RxInt total = 0.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 0.obs;

  bool get hasMore => currentPage.value < totalPages.value;

  @override
  void onInit() {
    super.onInit();
    getNameRollOfUserController = Get.find<GetNameRollOfUserController>();
    fetchAdjustments();
  }

  String get _departmentId => getNameRollOfUserController.id.value ?? '';

  // ─── جلب الصفحة الأولى ────────────────────────────────────────────
  Future<void> fetchAdjustments({int page = 1}) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _adjustmentsService.getAdjustments(
        departmentId: _departmentId,
        page: page,
      );

      if (result == null) {
        errorMessage.value = 'تعذر تحميل سجل التسويات';
        adjustments.clear();
      } else {
        adjustments.assignAll(result.items);
        total.value = result.total;
        currentPage.value = result.page;
        totalPages.value = result.totalPages;
        print('✅ تم جلب ${result.items.length} تسوية (الإجمالي: ${result.total})');
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ─── تحميل المزيد ─────────────────────────────────────────────────
  Future<void> loadMore() async {
    if (isLoadingMore.value || isLoading.value || !hasMore) return;

    isLoadingMore.value = true;

    try {
      final result = await _adjustmentsService.getAdjustments(
        departmentId: _departmentId,
        page: currentPage.value + 1,
      );

      if (result != null) {
        adjustments.addAll(result.items);
        currentPage.value = result.page;
        totalPages.value = result.totalPages;
      }
    } finally {
      isLoadingMore.value = false;
    }
  }
}