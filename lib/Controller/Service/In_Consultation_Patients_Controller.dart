// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Service/Get_Name_Roll_Of_User.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Release_Queue_Entry_Service.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/models/Department_Queue_Entry.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Get_Department_Queue_Service.dart';
import 'package:stock_mate_project/core/models/Patient_Model.dart';

/// ✅ كونترولر خاص بالمرضى الذين هم حالياً قيد المعاينة (in_consultation)
class InConsultationPatientsController extends GetxController {
  final GetDepartmentQueueService _queueService = GetDepartmentQueueService();

  late final GetNameRollOfUserController getNameRollOfUserController;

  // ─── Reactive state ───────────────────────────────────────────────
  final RxList<PatientListItem> patients = <PatientListItem>[].obs;
  final RxList<DepartmentQueueEntry> queueEntries = <DepartmentQueueEntry>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;

  // ─── Pagination ───────────────────────────────────────────────────
  final RxInt total = 0.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 0.obs;

  bool get hasMore => currentPage.value < totalPages.value;

  // ─── Infinite scroll ────────────────────────────────────────────
  final ScrollController scrollController = ScrollController();
  static const double _scrollThreshold = 200.0;

  @override
  void onInit() {
    super.onInit();
    getNameRollOfUserController = Get.find<GetNameRollOfUserController>();
    scrollController.addListener(_onScroll);
    fetchPatients();
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;

    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;

    if (currentScroll >= maxScroll - _scrollThreshold) {
      loadMore();
    }
  }

  String get _departmentId => getNameRollOfUserController.id.value ?? '';

  // ─── جلب الصفحة الأولى ────────────────────────────────────────────
  Future<void> fetchPatients({int page = 1}) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _queueService.getDepartmentQueue(
        departmentId: _departmentId,
        page: page,
        status: 'in_consultation', // ✅ فقط قيد المعاينة
      );

      if (result == null) {
        errorMessage.value = 'تعذر تحميل قائمة المرضى';
        patients.clear();
        queueEntries.clear();
      } else {
        _applyResult(result, replace: true);
        print('✅ تم جلب ${result.items.length} مريض قيد المعاينة');
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
      final result = await _queueService.getDepartmentQueue(
        departmentId: _departmentId,
        page: currentPage.value + 1,
        status: 'in_consultation',
      );

      if (result != null) {
        _applyResult(result, replace: false);
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// ✅ تطبيق النتيجة: تحويل + ترتيب (الأحدث حجزاً أو الأقدم إضافةً أولاً)
  void _applyResult(DepartmentQueuePageData result, {required bool replace}) {
    if (replace) {
      queueEntries.assignAll(result.items);
    } else {
      queueEntries.addAll(result.items);
    }

    final sorted = List<DepartmentQueueEntry>.from(queueEntries)
      ..sort((a, b) => a.addedAt.compareTo(b.addedAt));

    patients.assignAll(sorted.map((e) => e.toPatientListItem()).toList());

    total.value = result.total;
    currentPage.value = result.page;
    totalPages.value = result.totalPages;
  }
    final ReleaseQueueEntryService _releaseService = ReleaseQueueEntryService();

  /// ✅ إلغاء حجز مريض (تحرير من الطابور) — يعيده لحالة waiting
  /// يُزيل الكارد من القائمة فوراً (optimistic)، ويعيده إن فشل الطلب
  Future<void> releaseFromQueue(PatientListItem patient) async {
    final entryId = patient.queueEntryId;
    if (entryId == null || entryId.isEmpty) {
      customSnackBar(
        title: 'خطأ',
        message: 'لا يمكن إلغاء الحجز: معرف الطابور غير متوفر',
        color: constRed,
        messageColor: Colors.white,
      );
      return;
    }

    // ✅ إزالة فورية من الواجهة
    final removedIndex = patients.indexWhere((p) => p.id == patient.id);
    if (removedIndex == -1) return;

    final removedPatient = patients[removedIndex];
    patients.removeAt(removedIndex);
    queueEntries.removeWhere(
      (e) => (e.patient?.id ?? e.patientId) == patient.id,
    );

    final success = await _releaseService.releaseQueueEntry(
      queueEntryId: entryId,
    );

    if (success) {
      customSnackBar(
        title: 'تم إلغاء الحجز',
        message: 'أُعيد ${removedPatient.name} إلى قائمة الانتظار',
        color: constOrange,
        messageColor: Colors.white,
      );
      total.value = total.value > 0 ? total.value - 1 : 0;
    } else {
      // ❌ فشل الطلب — نعيد المريض إلى مكانه
      patients.insert(removedIndex, removedPatient);
      customSnackBar(
        title: 'فشل إلغاء الحجز',
        message: 'تعذر إلغاء حجز ${removedPatient.name}، حاول مرة أخرى',
        color: constRed,
        messageColor: Colors.white,
      );
      // إعادة جلب البيانات لضمان تطابق queueEntries مع الواقع
      fetchPatients(page: currentPage.value);
    }
  }
}