// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Service/Get_Name_Roll_Of_User.dart';
import 'package:stock_mate_project/core/models/Department_Queue_Entry.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Get_Department_Queue_Service.dart';
import 'package:stock_mate_project/core/models/Patient_Model.dart';

class PatientsController extends GetxController {
  final GetDepartmentQueueService _queueService = GetDepartmentQueueService();

  late final GetNameRollOfUserController getNameRollOfUserController;

  // ─── Reactive state ───────────────────────────────────────────────
  /// ✅ قائمة المرضى المحوّلة — نفس النوع الذي تتوقعه الكاردات وصفحة التفاصيل
  final RxList<PatientListItem> patients = <PatientListItem>[].obs;

  /// ✅ مداخل الطابور الأصلية (نحتفظ بها لاستخدام queueEntryId لاحقاً)
  final RxList<DepartmentQueueEntry> queueEntries = <DepartmentQueueEntry>[].obs;

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
    fetchPatients();
  }

  String get _departmentId => getNameRollOfUserController.id ?? '';

  // ─── جلب الصفحة الأولى ────────────────────────────────────────────
  Future<void> fetchPatients({int page = 1}) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _queueService.getDepartmentQueue(
        departmentId: _departmentId,
        page: page,
      );

      if (result == null) {
        errorMessage.value = 'تعذر تحميل قائمة المرضى';
        patients.clear();
        queueEntries.clear();
      } else {
        _applyResult(result, replace: true);
        print('✅ تم جلب ${result.items.length} مريض من طابور القسم');
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
      );

      if (result != null) {
        _applyResult(result, replace: false);
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// ✅ تطبيق النتيجة: تحويل + ترتيب (الأطول انتظاراً أولاً)
  void _applyResult(DepartmentQueuePageData result, {required bool replace}) {
    if (replace) {
      queueEntries.assignAll(result.items);
    } else {
      queueEntries.addAll(result.items);
    }

    // ✅ ترتيب: الأقدم إضافةً أولاً = الأطول انتظاراً أولاً (رقم الدور #1)
    final sorted = List<DepartmentQueueEntry>.from(queueEntries)
      ..sort((a, b) => a.addedAt.compareTo(b.addedAt));

    patients.assignAll(sorted.map((e) => e.toPatientListItem()).toList());

    total.value = result.total;
    currentPage.value = result.page;
    totalPages.value = result.totalPages;
  }

  // ─── ✅ عند حجز المريض: إزالته من قائمة الانتظار محلياً ────────────
  /// (حالته صارت in_consultation ولم يعد "منتظراً")
  void markInConsultation(String patientId) {
    patients.removeWhere((p) => p.id == patientId);
    queueEntries.removeWhere((e) => (e.patient?.id ?? e.patientId) == patientId);
    patients.refresh();
    print('🔄 تم تحديث قائمة الانتظار بعد الحجز');
  }

  // ─── دوال مستخدمة من صفحات أخرى (الوصفات الطبية) ─────────────────
  // TODO: ربط بالباك اند لاحقاً (POST /department-queue/{entryId}/complete)

  void completeConsultation(String patientId) {
    markInConsultation(patientId);
  }

  void removePatient(String patientId) {
    markInConsultation(patientId);
  }

  /// ✅ جلب id مدخل الطابور لمريض معين (مهم لأزرار lock/complete لاحقاً)
  String? queueEntryIdFor(String patientId) {
    final entry = queueEntries.firstWhereOrNull(
      (e) => (e.patient?.id ?? e.patientId) == patientId,
    );
    return entry?.id;
  }
}