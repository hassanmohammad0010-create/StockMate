// // ignore_for_file: file_names

// import 'package:get/get.dart';
// import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
// import 'package:stock_mate_project/Controller/Service/Get_Name_Roll_Of_User.dart';
// import 'package:stock_mate_project/Service/Head%20of%20department/Get_Refill_Requests_List_Service.dart';
// import 'package:stock_mate_project/core/models/Order_Item.dart';
// import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Request_Details_Page.dart';

// class MyRequestsController extends GetxController {
//   MyRequestsController({this.filterTag});

//   final String? filterTag;

//   final GetRefillRequestsListService _requestsService =
//       GetRefillRequestsListService();

//   late final GetNameRollOfUserController getNameRollOfUserController;

//   // ─── Reactive state ───────────────────────────────────────────────
//   final RxList<OrdertItem> allRequests = <OrdertItem>[].obs;
//   final RxList<OrdertItem> filteredRequests = <OrdertItem>[].obs;
//   final RxBool isLoading = false.obs;
//   final RxBool isLoadingMore = false.obs;
//   final RxString errorMessage = ''.obs;
//   final RxString currentFilter = 'الكل'.obs;

//   // ✅ لتتبع نسخة الـ FilterController المرتبطة حالياً
//   Worker? _filterWorker;
//   FilterController? _boundFilter;

//   // ─── Pagination ───────────────────────────────────────────────────
//   final RxInt total = 0.obs;
//   final RxInt currentPage = 1.obs;
//   final RxInt totalPages = 0.obs;

//   bool get hasMore => currentPage.value < totalPages.value;
//   bool get isDisplayedEmpty => filteredRequests.isEmpty;

//   @override
//   void onInit() {
//     super.onInit();
//     getNameRollOfUserController = Get.find<GetNameRollOfUserController>();
//     bindFilter(); // ✅ محاولة الربط الأولى
//     fetchRequests();
//   }

//   @override
//   void onClose() {
//     _filterWorker?.dispose();
//     super.onClose();
//   }

//   /// ✅ (إعادة) الربط مع الـ FilterController المسجّل حالياً.
//   /// آمنة للاستدعاء多次 — لا تعيد الربط إلا إذا تغيّرت النسخة.
//   void bindFilter() {
//     if (filterTag == null) return;

//     if (!Get.isRegistered<FilterController>(tag: filterTag)) {
//       print('⚠️ FilterController غير مسجل بعد!');
//       return;
//     }

//     final filterCtrl = Get.find<FilterController>(tag: filterTag);

//     // ✅ إذا كنا مربوطين بنفس النسخة والـ worker حيّ → لا نفعل شيئاً
//     if (identical(_boundFilter, filterCtrl) && _filterWorker != null) {
//       return;
//     }

//     // ✅ الربط مع النسخة الجديدة (هذا يصلح مشكلة العودة للصفحة)
//     _boundFilter = filterCtrl;
//     _filterWorker?.dispose();

//     // مزامنة الفلتر الحالي مع شريط الفلاتر
//     if (currentFilter.value != filterCtrl.selectedFilter.value) {
//       currentFilter.value = filterCtrl.selectedFilter.value;
//     }

//     _filterWorker = ever<String>(filterCtrl.selectedFilter, (newFilter) {
//       if (newFilter != currentFilter.value) {
//         currentFilter.value = newFilter;
//         _applyFilter();
//         print('🔄 الفلتر الآن: $newFilter | النتائج: ${filteredRequests.length}');
//       }
//     });

//     _applyFilter();
//     print('🔗 تم ربط الفلتر بنجاح');
//   }

//   String get _departmentId => getNameRollOfUserController.id.value ?? '';

//   // ─── الفلترة المحلية ──────────────────────────────────────────────
//   void _applyFilter() {
//     List<OrdertItem> result;

//     switch (currentFilter.value) {
//       case 'منجز':
//         result = allRequests
//             .where((r) => r.status == OrderStatus.partially_complete)
//             .toList();
//         break;

//       case 'طلبات مستلمة':
//         result = allRequests
//             .where((r) => r.status == OrderStatus.complete)
//             .toList();
//         break;

//       case 'معلق':
//         result = allRequests
//             .where(
//               (r) =>
//                   r.status == OrderStatus.draft
//             )
//             .toList();
//         break;

//       case 'بانتظار الموافقة':
//         result = allRequests
//             .where(
//               (r) =>
//                   r.status == OrderStatus.pending_hospital_approval,
//             )
//             .toList();
//         break;

//       case 'قيد التنفيذ':
//         result = allRequests
//             .where(
//               (r) =>
//                   r.status == OrderStatus.pending_manager_approval ||
//                   r.status == OrderStatus.preparing,
//             )
//             .toList();
//         break;

//       case 'مرفوض':
//         result = allRequests
//             .where(
//               (r) =>
//                   r.status == OrderStatus.hospital_rejected ||
//                   r.status == OrderStatus.manager_rejected ||
//                   r.status == OrderStatus.cancelled,
//             )
//             .toList();
//         break;

//       case 'الطلبات الدورية':
//         result = allRequests.where((r) => r.isRecurring).toList();
//         break;

//       default:
//         result = allRequests.toList();
//     }

//     filteredRequests.assignAll(result);
//   }

//   // ─── جلب الصفحة الأولى ────────────────────────────────────────────
//   Future<void> fetchRequests({int page = 1}) async {
//     isLoading.value = true;
//     errorMessage.value = '';

//     try {
//       final result = await _requestsService.getRequests(
//         departmentId: _departmentId,
//         page: page,
//       );

//       if (result == null) {
//         errorMessage.value = 'تعذر تحميل قائمة الطلبات';
//         allRequests.clear();
//         filteredRequests.clear();
//       } else {
//         allRequests.assignAll(result.items);
//         _applyFilter();
//         total.value = result.total;
//         currentPage.value = result.page;
//         totalPages.value = result.totalPages;
//         print('✅ تم جلب ${result.items.length} طلب');
//       }
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // ─── تحميل المزيد ─────────────────────────────────────────────────
//   Future<void> loadMore() async {
//     if (isLoadingMore.value || isLoading.value || !hasMore) return;

//     isLoadingMore.value = true;

//     try {
//       final result = await _requestsService.getRequests(
//         departmentId: _departmentId,
//         page: currentPage.value + 1,
//       );

//       if (result != null) {
//         allRequests.addAll(result.items);
//         _applyFilter();
//         currentPage.value = result.page;
//         totalPages.value = result.totalPages;
//       }
//     } finally {
//       isLoadingMore.value = false;
//     }
//   }
// // // ─── getters للأعداد (استناداً إلى كل الطلبات المحمّلة) ─────────────

// // int get completedCount => allRequests
// //     .where((r) => r.status == OrderStatus.partially_complete)
// //     .length;

// // int get deliveredCount => allRequests
// //     .where((r) => r.status == OrderStatus.complete)
// //     .length;

// // int get inProgressCount => allRequests
// //     .where(
// //       (r) =>
// //           r.status == OrderStatus.pending_manager_approval ||
// //           r.status == OrderStatus.preparing,
// //     )
// //     .length;

// // int get suspendedCount => allRequests
// //     .where(
// //       (r) =>
// //           r.status == OrderStatus.draft ||
// //           r.status == OrderStatus.pending_hospital_approval,
// //     )
// //     .length;

// // int get rejectedCount => allRequests
// //     .where(
// //       (r) =>
// //           r.status == OrderStatus.hospital_rejected ||
// //           r.status == OrderStatus.manager_rejected ||
// //           r.status == OrderStatus.cancelled,
// //     )
// //     .length;

// // int get recurringCount => allRequests.where((r) => r.isRecurring).length;

// // ─── التبديل إلى تبويب الطلبات مع ضبط الفلتر ─────────────────────
// /// يُستدعى من الصفحة الرئيسية عند الضغط على الكاردات
// // void goToRequestsTabWithFilter(
// //   TabController tabController,
// //   String filterName,
// //   int tabIndex,
// // ) {
// //   // ✅ 1) ضبط الفلتر في FilterController مباشرة
// //   if (Get.isRegistered<FilterController>(tag: filterTag)) {
// //     final filterCtrl = Get.find<FilterController>(tag: filterTag!);
// //     filterCtrl.setFilter(filterName);
// //   }

// //   // ✅ 2) الانتقال إلى التبويب
// //   tabController.animateTo(tabIndex);
// // }
//   // ─── فتح التفاصيل ─────────────────────────────────────────────────
//   void openRequestDetails(OrdertItem request) {
//     Get.to(
//       () => RequestDetailsPage(requestId: request.id),
//       transition: Transition.rightToLeft,
//     );
//   }
// }

// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
import 'package:stock_mate_project/Controller/Service/Get_Name_Roll_Of_User.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Get_Refill_Requests_List_Service.dart';
import 'package:stock_mate_project/core/models/Order_Item.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Request_Details_Page.dart';

class MyRequestsController extends GetxController {
  MyRequestsController({this.filterTag});

  final String? filterTag;

  final GetRefillRequestsListService _requestsService =
      GetRefillRequestsListService();

  late final GetNameRollOfUserController getNameRollOfUserController;

  // ─── Reactive state ───────────────────────────────────────────────
  final RxList<OrdertItem> allRequests = <OrdertItem>[].obs;
  final RxList<OrdertItem> filteredRequests = <OrdertItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString currentFilter = 'الكل'.obs;

  // ✅ لتتبع نسخة الـ FilterController المرتبطة حالياً
  Worker? _filterWorker;
  FilterController? _boundFilter;

  // ─── Pagination ───────────────────────────────────────────────────
  final RxInt total = 0.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 0.obs;

  bool get hasMore => currentPage.value < totalPages.value;
  bool get isDisplayedEmpty => filteredRequests.isEmpty;

  // ─── ✅ عدادات الحالات لكاردات الصفحة الرئيسية ─────────────────────
  // ملاحظة: محسوبة من allRequests (كل الطلبات المحمّلة في الصفحة الحالية)
  // وليس من filteredRequests، حتى لا تتأثر بالفلتر النشط في تاب الطلبات.
  int get completedCount => allRequests
      .where((r) => r.status == OrderStatus.partially_complete)
      .length;

  int get inProgressCount => allRequests
      .where(
        (r) =>
            r.status == OrderStatus.pending_manager_approval ||
            r.status == OrderStatus.preparing,
      )
      .length;

  int get pendingApprovalCount => allRequests
      .where((r) => r.status == OrderStatus.pending_hospital_approval)
      .length;

  int get rejectedCount => allRequests
      .where(
        (r) =>
            r.status == OrderStatus.hospital_rejected ||
            r.status == OrderStatus.manager_rejected ||
            r.status == OrderStatus.cancelled,
      )
      .length;

  @override
  void onInit() {
    super.onInit();
    getNameRollOfUserController = Get.find<GetNameRollOfUserController>();
    bindFilter(); // ✅ محاولة الربط الأولى
    fetchRequests();
  }

  @override
  void onClose() {
    _filterWorker?.dispose();
    super.onClose();
  }

  /// ✅ (إعادة) الربط مع الـ FilterController المسجّل حالياً.
  /// آمنة للاستدعاء多次 — لا تعيد الربط إلا إذا تغيّرت النسخة.
  void bindFilter() {
    if (filterTag == null) return;

    if (!Get.isRegistered<FilterController>(tag: filterTag)) {
      print('⚠️ FilterController غير مسجل بعد!');
      return;
    }

    final filterCtrl = Get.find<FilterController>(tag: filterTag);

    // ✅ إذا كنا مربوطين بنفس النسخة والـ worker حيّ → لا نفعل شيئاً
    if (identical(_boundFilter, filterCtrl) && _filterWorker != null) {
      return;
    }

    // ✅ الربط مع النسخة الجديدة (هذا يصلح مشكلة العودة للصفحة)
    _boundFilter = filterCtrl;
    _filterWorker?.dispose();

    // مزامنة الفلتر الحالي مع شريط الفلاتر
    if (currentFilter.value != filterCtrl.selectedFilter.value) {
      currentFilter.value = filterCtrl.selectedFilter.value;
    }

    _filterWorker = ever<String>(filterCtrl.selectedFilter, (newFilter) {
      if (newFilter != currentFilter.value) {
        currentFilter.value = newFilter;
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

  // ─── الفلترة المحلية ──────────────────────────────────────────────
  void _applyFilter() {
    List<OrdertItem> result;

    switch (currentFilter.value) {
      case 'منجز':
        result = allRequests
            .where((r) => r.status == OrderStatus.partially_complete)
            .toList();
        break;

      case 'طلبات مستلمة':
        result = allRequests
            .where((r) => r.status == OrderStatus.complete)
            .toList();
        break;

      case 'معلق':
        result = allRequests
            .where((r) => r.status == OrderStatus.draft)
            .toList();
        break;
      case 'بانتظار الموافقة':
        result = allRequests
            .where((r) => r.status == OrderStatus.pending_hospital_approval)
            .toList();
        break;

      case 'قيد التنفيذ':
        result = allRequests
            .where(
              (r) =>
                  r.status == OrderStatus.pending_manager_approval ||
                  r.status == OrderStatus.preparing,
            )
            .toList();
        break;

      case 'مرفوض':
        result = allRequests
            .where(
              (r) =>
                  r.status == OrderStatus.hospital_rejected ||
                  r.status == OrderStatus.manager_rejected ||
                  r.status == OrderStatus.cancelled,
            )
            .toList();
        break;

      case 'الطلبات الدورية':
        result = allRequests.where((r) => r.isRecurring).toList();
        break;

      default:
        result = allRequests.toList();
    }

    filteredRequests.assignAll(result);
  }

  // ─── جلب الصفحة الأولى ────────────────────────────────────────────
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
        allRequests.clear();
        filteredRequests.clear();
      } else {
        allRequests.assignAll(result.items);
        _applyFilter();
        total.value = result.total;
        currentPage.value = result.page;
        totalPages.value = result.totalPages;
        print('✅ تم جلب ${result.items.length} طلب');
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
      final result = await _requestsService.getRequests(
        departmentId: _departmentId,
        page: currentPage.value + 1,
      );

      if (result != null) {
        allRequests.addAll(result.items);
        _applyFilter();
        currentPage.value = result.page;
        totalPages.value = result.totalPages;
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  // ─── فتح التفاصيل ─────────────────────────────────────────────────
  void openRequestDetails(OrdertItem request) {
    Get.to(
      () => RequestDetailsPage(requestId: request.id),
      transition: Transition.rightToLeft,
    );
  }
}
