// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Service/Get_Name_Roll_Of_User.dart';
import 'package:stock_mate_project/Test/GetRefillRequestsListService.dart';
import 'package:stock_mate_project/Test/RefillRequestsPageData.dart';

class MyRequestsController extends GetxController {
  final GetRefillRequestsListService _requestsService =
      GetRefillRequestsListService();

  late final GetNameRollOfUserController getNameRollOfUserController;

  // ─── Reactive state ───────────────────────────────────────────────
  final RxList<RefillRequestItem2> requests = <RefillRequestItem2>[].obs;
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
    fetchRequests();
  }

  String get _departmentId => getNameRollOfUserController.id ?? '';

  // ✅✅✅ مصدر التوكن: عدّل السطر التالي ليطابق مشروعك
  // (مثلاً: GetStorage().read('token') أو من كنترولر تسجيل الدخول ...)

  // ─── جلب القائمة (تحديث كامل) ─────────────────────────────────────
  Future<void> fetchRequests({int page = 1}) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _requestsService.getRequests(
        departmentId: _departmentId,
        page: page,
      );

      if (result == null) {
        errorMessage.value = 'تعذر تحميل قائمة الطلبات';
        requests.clear();
      } else {
        requests.assignAll(result.items);
        total.value = result.total;
        currentPage.value = result.page;
        totalPages.value = result.totalPages;
        print('✅ تم جلب ${result.items.length} طلب من أصل ${result.total}');
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ─── تحميل المزيد (Pagination) ────────────────────────────────────
  Future<void> loadMore() async {
    if (isLoadingMore.value || isLoading.value || !hasMore) return;

    isLoadingMore.value = true;
    try {
      final result = await _requestsService.getRequests(
        departmentId: _departmentId,
        page: currentPage.value + 1,
      );

      if (result != null) {
        requests.addAll(result.items);
        currentPage.value = result.page;
        totalPages.value = result.totalPages;
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  // ─── عند الضغط على الكارد ─────────────────────────────────────────
  // ✅ STEP 2 لاحقاً: نجلب التفاصيل من Get Refill Request By Id ثم ننتقل لصفحة التفاصيل
  void openRequestDetails(RefillRequestItem2 request) {
    print('🔎 فتح تفاصيل الطلب: ${request.id} | ${request.requestNumber}');
    // TODO: ربط الإند بوينت الثاني هنا
  }
}