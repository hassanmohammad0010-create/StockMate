// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Get_Refill_Deliveries_Service.dart';
import 'package:stock_mate_project/core/models/Refill_Delivery_Model.dart';

class RefillDeliveriesController extends GetxController {
  final GetRefillDeliveriesService _deliveriesService =
      GetRefillDeliveriesService();

  // ─── Reactive state ───────────────────────────────────────────────
  final RxList<RefillDelivery> deliveries = <RefillDelivery>[].obs;
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
    fetchDeliveries();
  }

  // ─── جلب الصفحة الأولى ────────────────────────────────────────────
  Future<void> fetchDeliveries({int page = 1}) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _deliveriesService.getDeliveries(page: page);

      if (result == null) {
        errorMessage.value = 'تعذر تحميل سجل التسليمات';
        deliveries.clear();
      } else {
        deliveries.assignAll(result.items);
        total.value = result.total;
        currentPage.value = result.page;
        totalPages.value = result.totalPages;
        print('✅ تم جلب ${result.items.length} تسليم (الإجمالي: ${result.total})');
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
      final result = await _deliveriesService.getDeliveries(
        page: currentPage.value + 1,
      );

      if (result != null) {
        deliveries.addAll(result.items);
        currentPage.value = result.page;
        totalPages.value = result.totalPages;
      }
    } finally {
      isLoadingMore.value = false;
    }
  }
}