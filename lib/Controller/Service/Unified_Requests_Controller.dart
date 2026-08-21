// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
import 'package:stock_mate_project/Controller/Service/Get_Name_Roll_Of_User.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Get_Refill_Requests_List_Service.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Get_Refill_Deliveries_Service.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Request_Details_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Refill_Delivery_Details_Page.dart';
import 'package:stock_mate_project/core/models/Order_Item.dart';
import 'package:stock_mate_project/core/models/Refill_Delivery_Model.dart';

class UnifiedRequestsController extends GetxController {
  UnifiedRequestsController({this.filterTag});

  final String? filterTag;

  final GetRefillRequestsListService _requestsService =
      GetRefillRequestsListService();
  final GetRefillDeliveriesService _deliveriesService =
      GetRefillDeliveriesService();

  late final GetNameRollOfUserController getNameRollOfUserController;

  // ─── Reactive state ───────────────────────────────────────────────
  final RxList<OrdertItem> allRequests = <OrdertItem>[].obs;
  final RxList<RefillDelivery> allDeliveries = <RefillDelivery>[].obs;
  final RxList<OrdertItem> filteredRequests = <OrdertItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString currentFilter = 'الكل'.obs;

  // ✅ ScrollController للتحميل التلقائي
  final ScrollController scrollController = ScrollController();

  // ✅ عداد المحاولات التلقائية (لمنع الـ infinite loop)
  int _autoLoadAttempts = 0;
  static const int _maxAutoLoadAttempts = 3;

  // ✅ لتتبع نسخة الـ FilterController المرتبطة حالياً
  Worker? _filterWorker;
  FilterController? _boundFilter;

  // ─── Pagination Requests ──────────────────────────────────────────
  final RxInt totalRequests = 0.obs;
  final RxInt currentRequestPage = 1.obs;
  final RxInt totalRequestPages = 0.obs;

  // ─── Pagination Deliveries ────────────────────────────────────────
  final RxInt totalDeliveries = 0.obs;
  final RxInt currentDeliveryPage = 1.obs;
  final RxInt totalDeliveryPages = 0.obs;

  bool get hasMore => currentRequestPage.value < totalRequestPages.value;
  bool get isDisplayedEmpty => filteredRequests.isEmpty;

  // ─── Deliveries helpers ───────────────────────────────────────────

  /// خريطة: requestId → قائمة التسليمات الواردة غير المؤكدة
  Map<String, List<RefillDelivery>> get pendingDeliveriesMap {
    final map = <String, List<RefillDelivery>>{};
    for (final d in allDeliveries) {
      if (d.confirmedAt == null) {
        map.putIfAbsent(d.refillRequestId, () => []).add(d);
      }
    }
    return map;
  }

  /// هل يوجد تسليمات واردة غير مؤكدة لهذا الطلب؟
  bool hasPendingDeliveries(String requestId) =>
      pendingDeliveriesMap.containsKey(requestId);

  /// قائمة التسليمات الواردة غير المؤكدة لهذا الطلب
  List<RefillDelivery> getPendingDeliveries(String requestId) =>
      pendingDeliveriesMap[requestId] ?? [];

  /// أول تسليم وارد غير مؤكد (للانتقال المباشر)
  RefillDelivery? getFirstPendingDelivery(String requestId) {
    final list = pendingDeliveriesMap[requestId];
    return list?.isNotEmpty == true ? list!.first : null;
  }

  /// عدد الطلبات التي بانتظار التأكيد
  int get pendingConfirmationCount => pendingDeliveriesMap.length;

  // ─── Counters (من allRequests) ────────────────────────────────────
  int get completedCount =>
      allRequests.where((r) => r.status == OrderStatus.complete).length;

  int get inProgressCount =>
      allRequests.where((r) => r.status == OrderStatus.preparing).length;

  int get pendingApprovalCount => allRequests
      .where((r) => r.status == OrderStatus.pending_hospital_approval)
      .length;

  int get rejectedCount => allRequests
      .where(
        (r) =>
            r.status == OrderStatus.hospital_rejected ||
            r.status == OrderStatus.manager_rejected,
      )
      .length;

  @override
  void onInit() {
    super.onInit();
    getNameRollOfUserController = Get.find<GetNameRollOfUserController>();
    bindFilter();
    fetchAll();
    // ✅ ربط ScrollController
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    _filterWorker?.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // ─── ✅ Scroll Listener — تحميل تلقائي عند الوصول للنهاية ─────────
  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (!isLoadingMore.value && !isLoading.value && hasMore) {
        loadMore();
      }
    }
  }

  /// ✅ (إعادة) الربط مع الـ FilterController المسجّل حالياً
  void bindFilter() {
    if (filterTag == null) return;

    if (!Get.isRegistered<FilterController>(tag: filterTag)) {
      print('⚠️ FilterController غير مسجل بعد!');
      return;
    }

    final filterCtrl = Get.find<FilterController>(tag: filterTag);

    if (identical(_boundFilter, filterCtrl) && _filterWorker != null) {
      return;
    }

    _boundFilter = filterCtrl;
    _filterWorker?.dispose();

    if (currentFilter.value != filterCtrl.selectedFilter.value) {
      currentFilter.value = filterCtrl.selectedFilter.value;
    }

    _filterWorker = ever<String>(filterCtrl.selectedFilter, (newFilter) {
      if (newFilter != currentFilter.value) {
        currentFilter.value = newFilter;
        _autoLoadAttempts = 0; // ✅ إعادة العداد عند تغيير الفلتر
        _applyFilter();
        print(
          '🔄 الفلتر الآن: $newFilter | النتائج: ${filteredRequests.length}',
        );
      }
    });

    _applyFilter();
    print('🔗 تم ربط الفلتر بنجاح');
  }

  String get _departmentId => getNameRollOfUserController.id.value ?? '';

  // ─── جلب الكل (طلبات + تسليمات) ─────────────────────────────────
  Future<void> fetchAll() async {
    isLoading.value = true;
    errorMessage.value = '';
    _autoLoadAttempts = 0;

    try {
      final results = await Future.wait([
        _requestsService.getRequests(departmentId: _departmentId, page: 1),
        _deliveriesService.getDeliveries(page: 1),
      ]);

      final requestsResult = results[0] as RefillRequestsPageData?;
      final deliveriesResult = results[1] as RefillDeliveryPageData?;

      if (requestsResult != null) {
        allRequests.assignAll(requestsResult.items);
        totalRequests.value = requestsResult.total;
        currentRequestPage.value = requestsResult.page;
        totalRequestPages.value = requestsResult.totalPages;
      } else {
        errorMessage.value = 'تعذر تحميل قائمة الطلبات';
        allRequests.clear();
      }

      if (deliveriesResult != null) {
        allDeliveries.assignAll(deliveriesResult.items);
        totalDeliveries.value = deliveriesResult.total;
        currentDeliveryPage.value = deliveriesResult.page;
        totalDeliveryPages.value = deliveriesResult.totalPages;
      }

      _applyFilter();
      print(
        '✅ تم جلب ${allRequests.length} طلب و ${allDeliveries.length} تسليم',
      );
    } catch (e) {
      errorMessage.value = 'تعذر تحميل البيانات: ${e.toString()}';
      print('❌ خطأ في fetchAll: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── تحميل المزيد من الطلبات ─────────────────────────────────────
  Future<void> loadMore() async {
    if (isLoadingMore.value || isLoading.value || !hasMore) return;

    isLoadingMore.value = true;

    try {
      final result = await _requestsService.getRequests(
        departmentId: _departmentId,
        page: currentRequestPage.value + 1,
      );

      if (result != null) {
        allRequests.addAll(result.items);
        _applyFilter();
        currentRequestPage.value = result.page;
        totalRequestPages.value = result.totalPages;
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  // ─── ✅ الفلترة المحلية — كل حالة enum لوحدها ────────────────────
  void _applyFilter() {
    List<OrdertItem> result;

    switch (currentFilter.value) {
      // ✅ فلتر جديد: بانتظار التأكيد (الطلبات التي لديها تسليمات واردة غير مؤكدة)
      case 'بانتظار التأكيد':
        final pendingIds = pendingDeliveriesMap.keys.toSet();
        result = allRequests.where((r) => pendingIds.contains(r.id)).toList();
        break;

      case 'بانتظار موافقة المشفى':
        result = allRequests
            .where((r) => r.status == OrderStatus.pending_hospital_approval)
            .toList();
        break;

      case 'بانتظار موافقة المدير':
        result = allRequests
            .where((r) => r.status == OrderStatus.pending_manager_approval)
            .toList();
        break;

      case 'قيد التحضير':
        result = allRequests
            .where((r) => r.status == OrderStatus.preparing)
            .toList();
        break;

      case 'منجز جزئي':
        result = allRequests
            .where((r) => r.status == OrderStatus.partially_complete)
            .toList();
        break;

      case 'منجز':
        result = allRequests
            .where((r) => r.status == OrderStatus.complete)
            .toList();
        break;

      case 'مرفوض':
        result = allRequests
            .where(
              (r) =>
                  r.status == OrderStatus.hospital_rejected ||
                  r.status == OrderStatus.manager_rejected,
            )
            .toList();
        break;

      case 'ملغي':
        result = allRequests
            .where((r) => r.status == OrderStatus.cancelled)
            .toList();
        break;

      case 'الطلبات الدورية':
        result = allRequests.where((r) => r.isRecurring).toList();
        break;

      default: // 'الكل'
        result = allRequests.toList();
    }

    filteredRequests.assignAll(result);

    // ✅ تحميل تلقائي محمي: إذا كانت النتائج فارغة لكن هناك صفحات أخرى
    // نحمّل 3 صفحات كحد أقصى تلقائياً (لمنع الـ infinite loop)
    if (filteredRequests.isEmpty &&
        hasMore &&
        !isLoadingMore.value &&
        !isLoading.value &&
        _autoLoadAttempts < _maxAutoLoadAttempts) {
      _autoLoadAttempts++;
      loadMore();
    }
  }

  // ─── فتح التفاصيل ─────────────────────────────────────────────────
  void openRequestDetails(OrdertItem request) {
    Get.to(
      () => RequestDetailsPage(requestId: request.id),
      transition: Transition.rightToLeft,
    )?.then((_) {
      fetchAll();
    });
  }

  // ─── ✅ فتح تأكيد الاستلام مباشرة ─────────────────────────────────
  void openDeliveryConfirm(String deliveryId) {
    Get.to(
      () => RefillDeliveryDetailsPage(deliveryId: deliveryId),
      transition: Transition.rightToLeft,
    )?.then((_) {
      fetchAll();
    });
  }
}
