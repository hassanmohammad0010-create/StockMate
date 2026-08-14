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
        print('🔄 الفلتر الآن: $newFilter | النتائج: ${filteredRequests.length}');
      }
    });

    _applyFilter();
    print('🔗 تم ربط الفلتر بنجاح');
  }

  String get _departmentId => getNameRollOfUserController.id ?? '';

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
            .where(
              (r) =>
                  r.status == OrderStatus.draft ||
                  r.status == OrderStatus.pending_hospital_approval,
            )
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
// // ─── getters للأعداد (استناداً إلى كل الطلبات المحمّلة) ─────────────

// int get completedCount => allRequests
//     .where((r) => r.status == OrderStatus.partially_complete)
//     .length;

// int get deliveredCount => allRequests
//     .where((r) => r.status == OrderStatus.complete)
//     .length;

// int get inProgressCount => allRequests
//     .where(
//       (r) =>
//           r.status == OrderStatus.pending_manager_approval ||
//           r.status == OrderStatus.preparing,
//     )
//     .length;

// int get suspendedCount => allRequests
//     .where(
//       (r) =>
//           r.status == OrderStatus.draft ||
//           r.status == OrderStatus.pending_hospital_approval,
//     )
//     .length;

// int get rejectedCount => allRequests
//     .where(
//       (r) =>
//           r.status == OrderStatus.hospital_rejected ||
//           r.status == OrderStatus.manager_rejected ||
//           r.status == OrderStatus.cancelled,
//     )
//     .length;

// int get recurringCount => allRequests.where((r) => r.isRecurring).length;

// ─── التبديل إلى تبويب الطلبات مع ضبط الفلتر ─────────────────────
/// يُستدعى من الصفحة الرئيسية عند الضغط على الكاردات
// void goToRequestsTabWithFilter(
//   TabController tabController,
//   String filterName,
//   int tabIndex,
// ) {
//   // ✅ 1) ضبط الفلتر في FilterController مباشرة
//   if (Get.isRegistered<FilterController>(tag: filterTag)) {
//     final filterCtrl = Get.find<FilterController>(tag: filterTag!);
//     filterCtrl.setFilter(filterName);
//   }

//   // ✅ 2) الانتقال إلى التبويب
//   tabController.animateTo(tabIndex);
// }
  // ─── فتح التفاصيل ─────────────────────────────────────────────────
  void openRequestDetails(OrdertItem request) {
    Get.to(
      () => RequestDetailsPage(requestId: request.id),
      transition: Transition.rightToLeft,
    );
  }
}

// // ignore_for_file: file_names

// import 'package:get/get.dart';
// import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
// import 'package:stock_mate_project/Controller/Service/Get_Name_Roll_Of_User.dart';
// import 'package:stock_mate_project/Service/Head%20of%20department/Get_Refill_Requests_List_Service.dart';
// import 'package:stock_mate_project/core/models/Order_Item.dart';

// class MyRequestsController extends GetxController {
//   final GetRefillRequestsListService _requestsService =
//       GetRefillRequestsListService();

//   late final GetNameRollOfUserController getNameRollOfUserController;

//   // ─── Reactive state ───────────────────────────────────────────────
//   final RxList<OrdertItem> requests = <OrdertItem>[].obs;
//   final RxBool isLoading = false.obs;
//   final RxBool isLoadingMore = false.obs;
//   final RxString errorMessage = ''.obs;

//   // ─── Pagination ───────────────────────────────────────────────────
//   final RxInt total = 0.obs;
//   final RxInt currentPage = 1.obs;
//   final RxInt totalPages = 0.obs;

//   bool get hasMore => currentPage.value < totalPages.value;

//   // ─── الفلتر الحالي (النص العربي كما يظهر في CustomFilterBar) ────────
//   final RxString currentFilter = 'الكل'.obs;

//   // ✅ خريطة: الفلتر العربي -> قيم status في الباك اند (قد تكون أكثر من قيمة)
//   // مبنية حسب statusLabel الموجود في RefillRequestItem2 وتأكيدك بخصوص الدمج.
//   static const Map<String, List<String>> _filterToStatuses = {
//     'معلق': ['draft', 'pending_hospital_approval'],
//     'قيد التنفيذ': ['pending_manager_approval', 'preparing'],
//     'مرفوض': ['hospital_rejected', 'manager_rejected', 'cancelled'],
//     'منجز': ['partially_complete'],
//     'طلبات مستلمة': ['complete'],
//   };

//   // ✅ فلتر "الطلبات الدورية" يعتمد على requestType وليس status
//   static const List<String> _recurringRequestTypes = [
//     'daily',
//     'weekly',
//     'monthly',
//   ];

//   // ✅ نتتبع هل تم بالفعل ربط الفلتر وجلب أول دفعة، لتفادي طلب "الكل" الأولي
//   // غير الضروري قبل معرفة الفلتر الفعلي من FilterController.
//   bool _boundToFilter = false;

//   @override
//   void onInit() {
//     super.onInit();
//     getNameRollOfUserController = Get.find<GetNameRollOfUserController>();
//     // ملاحظة: أول جلب فعلي يحدث داخل bindToFilter() وليس هنا، حتى نجلب
//     // بالفلتر الصحيح من أول مرة بدل جلب "الكل" ثم إعادة الجلب فوراً.
//   }

//   /// ✅ يُستدعى مرة واحدة من الصفحة (بعد التأكد من تسجيل FilterController)
//   /// لربط تغييرات الفلتر بإعادة الجلب، دون تكرار تسجيل المستمع مع كل build().
//   void bindToFilter(FilterController filterController) {
//     if (_boundToFilter) return;
//     _boundToFilter = true;

//     // أول جلب فعلي للصفحة، بالفلتر الصحيح من البداية
//     currentFilter.value = filterController.selectedFilter.value;
//     fetchRequests(page: 1);

//     // الاستماع لأي تغيير لاحق في الفلتر
//     ever<String>(filterController.selectedFilter, (filterLabel) {
//       applyFilter(filterLabel);
//     });
//   }

//   String get _departmentId => getNameRollOfUserController.id ?? '';

//   // ✅✅✅ مصدر التوكن: عدّل السطر التالي ليطابق مشروعك
//   // (مثلاً: GetStorage().read('token') أو من كنترولر تسجيل الدخول ...)

//   // ─── ✅ يُستدعى من الصفحة عند تغيير الفلتر (CustomFilterBar) ──────────
//   // اربط هذه الدالة بأي مكان يُغيّر فيه المستخدم الفلتر، مثال:
//   //   onFilterChanged: (label) => myRequestsController.applyFilter(label)
//   // أو عبر ever() على FilterController.selectedFilter إن وُجد (انظر الشرح أسفل الملف)
//   void applyFilter(String filterLabel) {
//     if (currentFilter.value == filterLabel) return;
//     currentFilter.value = filterLabel;
//     fetchRequests(page: 1);
//   }

//   // ─── جلب القائمة (تحديث كامل) — الآن يراعي currentFilter ──────────────
//   Future<void> fetchRequests({int page = 1}) async {
//     isLoading.value = true;
//     errorMessage.value = '';

//     try {
//       final result = await _fetchForCurrentFilter(page: page);

//       if (result == null) {
//         errorMessage.value = 'تعذر تحميل قائمة الطلبات';
//         requests.clear();
//       } else {
//         requests.assignAll(result.items);
//         total.value = result.total;
//         currentPage.value = result.page;
//         totalPages.value = result.totalPages;
//         print(
//           '✅ [${currentFilter.value}] تم جلب ${result.items.length} طلب من أصل ${result.total}',
//         );
//       }
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // ─── تحميل المزيد (Pagination) ────────────────────────────────────
//   Future<void> loadMore() async {
//     if (isLoadingMore.value || isLoading.value || !hasMore) return;

//     isLoadingMore.value = true;
//     try {
//       final result = await _fetchForCurrentFilter(page: currentPage.value + 1);

//       if (result != null) {
//         requests.addAll(result.items);
//         currentPage.value = result.page;
//         totalPages.value = result.totalPages;
//       }
//     } finally {
//       isLoadingMore.value = false;
//     }
//   }

//   // ─── ✅ يقرر شكل الطلب المناسب حسب الفلتر الحالي ───────────────────────
//   Future<RefillRequestsPageData?> _fetchForCurrentFilter({
//     required int page,
//   }) async {
//     final filter = currentFilter.value;

//     // "الكل" -> بدون أي فلتر
//     if (filter == 'الكل') {
//       return _requestsService.getRequests(
//         departmentId: _departmentId,
//         page: page,
//       );
//     }

//     // "الطلبات الدورية" -> يعتمد على requestType (3 قيم مدموجة)
//     if (filter == 'الطلبات الدورية') {
//       return _requestsService.getRequestsMerged(
//         departmentId: _departmentId,
//         page: page,
//         requestTypeValues: _recurringRequestTypes,
//       );
//     }

//     // باقي الفلاتر -> تعتمد على status (قيمة واحدة أو أكثر مدموجة)
//     final statuses = _filterToStatuses[filter];
//     if (statuses == null || statuses.isEmpty) {
//       // فلتر غير معروف -> رجوع آمن لجلب الكل بدل كسر الشاشة
//       print('⚠️ فلتر غير معروف: "$filter"، سيتم جلب الكل بدلاً منه');
//       return _requestsService.getRequests(
//         departmentId: _departmentId,
//         page: page,
//       );
//     }

//     if (statuses.length == 1) {
//       // قيمة واحدة فقط -> طلب عادي (أفضل أداءً، pagination دقيقة)
//       return _requestsService.getRequests(
//         departmentId: _departmentId,
//         page: page,
//         status: statuses.first,
//       );
//     }

//     // أكثر من قيمة -> دمج عدة طلبات
//     return _requestsService.getRequestsMerged(
//       departmentId: _departmentId,
//       page: page,
//       statusValues: statuses,
//     );
//   }

//   // ─── عند الضغط على الكارد ─────────────────────────────────────────
//   // ✅ STEP 2 لاحقاً: نجلب التفاصيل من Get Refill Request By Id ثم ننتقل لصفحة التفاصيل
//   void openRequestDetails(OrdertItem request) {
//     print('🔎 فتح تفاصيل الطلب: ${request.id} | ${request.requestNumber}');
//     // TODO: ربط الإند بوينت الثاني هنا
//   }
// }