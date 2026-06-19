// import 'package:get/get.dart';
// import 'package:stock_mate_project/core/models/PrescriptionModel.dart';

// /// الكونترولر المسؤول عن إدارة كل الوصفات الطبية:
// /// - تخزين القائمة الكاملة (مصدر الحقيقة الوحيد)
// /// - فلترة الوصفات الجديدة / المعالجة بناءً على status
// /// - البحث باسم المريض لكل صفحة على حدة (حقلا بحث منفصلان)
// /// - تحويل حالة الوصفة من newRx إلى processed
// class PrescriptionController extends GetxController {
//   // القائمة الكاملة لكل الوصفات (مصدر الحقيقة)
//   final RxList<PrescriptionModel> _allPrescriptions = <PrescriptionModel>[].obs;

//   // نصوص البحث منفصلة لكل صفحة حتى لا يؤثر بحث صفحة على الأخرى
//   final RxString newRxSearchQuery = ''.obs;
//   final RxString processedSearchQuery = ''.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _loadDummyData();
//   }

//   void _loadDummyData() {
//     _allPrescriptions.addAll([
//       PrescriptionModel(
//         id: '1',
//         patientName: 'أحمد محمد العتيبي',
//         doctorName: 'د. سارة الحربي',
//         condition: 'التهاب الجيوب الأنفية',
//         medications: 'Amoxicillin 500mg - 3 مرات يومياً لمدة 7 أيام',
//         notes: 'يفضل تناول الدواء بعد الأكل',
//         date: DateTime(2025, 1, 10),
//         status: PrescriptionStatus.newRx,
//       ),
//       PrescriptionModel(
//         id: '2',
//         patientName: 'فاطمة عبدالله القحطاني',
//         doctorName: 'د. خالد المطيري',
//         condition: 'ارتفاع ضغط الدم',
//         medications: 'Amlodipine 5mg - مرة واحدة يومياً',
//         notes: null,
//         date: DateTime(2025, 1, 12),
//         status: PrescriptionStatus.processed,
//       ),
//       PrescriptionModel(
//         id: '3',
//         patientName: 'عبدالرحمن سعيد الزهراني',
//         doctorName: 'د. منى الشمري',
//         condition: 'السكري من النوع الثاني',
//         medications: 'Metformin 850mg - مرتين يومياً',
//         notes: 'مراجعة بعد شهر لمتابعة مستوى السكر',
//         date: DateTime(2025, 1, 15),
//         status: PrescriptionStatus.newRx,
//       ),
//       PrescriptionModel(
//         id: '4',
//         patientName: 'نورة إبراهيم العنزي',
//         doctorName: 'د. يوسف الدوسري',
//         condition: 'حساسية موسمية',
//         medications: 'Cetirizine 10mg - مرة واحدة يومياً عند الحاجة',
//         notes: null,
//         date: DateTime(2025, 1, 18),
//         status: PrescriptionStatus.processed,
//       ),
//       PrescriptionModel(
//         id: '5',
//         patientName: 'سلطان فهد الغامدي',
//         doctorName: 'د. ريم العتيبي',
//         condition: 'التهاب الحلق البكتيري',
//         medications: 'Azithromycin 250mg - مرة واحدة يومياً لمدة 5 أيام',
//         notes: 'تجنب الحليب قبل وبعد الجرعة بساعتين',
//         date: DateTime(2025, 1, 20),
//         status: PrescriptionStatus.newRx,
//       ),
//       PrescriptionModel(
//         id: '6',
//         patientName: 'هند عبدالعزيز السبيعي',
//         doctorName: 'د. ماجد القرني',
//         condition: 'صداع نصفي مزمن',
//         medications: 'Sumatriptan 50mg - عند بدء النوبة',
//         notes: 'لا تتجاوز جرعتين خلال 24 ساعة',
//         date: DateTime(2025, 1, 22),
//         status: PrescriptionStatus.processed,
//       ),
//     ]);
//   }

//   // ===== Getters محسوبة (تتحدث تلقائيًا بفضل Rx) =====

//   /// كل الوصفات الجديدة، مفلترة حسب نص البحث الخاص بصفحة الوصفات الجديدة
//   List<PrescriptionModel> get newPrescriptions {
//     final query = newRxSearchQuery.value.trim().toLowerCase();
//     final list = _allPrescriptions
//         .where((p) => p.status == PrescriptionStatus.newRx)
//         .toList();

//     if (query.isEmpty) return list;
//     return list
//         .where((p) => p.patientName.toLowerCase().contains(query))
//         .toList();
//   }

//   /// كل الوصفات المعالجة، مفلترة حسب نص البحث الخاص بصفحة الوصفات المعالجة
//   List<PrescriptionModel> get processedPrescriptions {
//     final query = processedSearchQuery.value.trim().toLowerCase();
//     final list = _allPrescriptions
//         .where((p) => p.status == PrescriptionStatus.processed)
//         .toList();

//     if (query.isEmpty) return list;
//     return list
//         .where((p) => p.patientName.toLowerCase().contains(query))
//         .toList();
//   }

//   // ===== تحديث البحث =====

//   void updateNewRxSearch(String value) => newRxSearchQuery.value = value;

//   void updateProcessedSearch(String value) =>
//       processedSearchQuery.value = value;

//   // ===== البحث عن وصفة بمعرّفها (يُستخدم لربط الـ sheet بالحالة الحيّة) =====

//   PrescriptionModel? findById(String id) {
//     final index = _allPrescriptions.indexWhere((p) => p.id == id);
//     if (index == -1) return null;
//     return _allPrescriptions[index];
//   }

//   // ===== تحويل حالة الوصفة =====

//   /// يحوّل الوصفة من newRx إلى processed.
//   /// بما أن _allPrescriptions هي RxList، فإن تعديل عنصر بداخلها
//   /// والمناداة على refresh() (أو إعادة تعيين بـ [index] = ...) كافٍ
//   /// لإعادة بناء أي Obx/GetX مرتبط بها — فينتقل الكونتينر تلقائيًا
//   /// من صفحة الوصفات الجديدة إلى صفحة الوصفات المعالجة.
//   void markAsProcessed(String prescriptionId) {
//     final index = _allPrescriptions.indexWhere((p) => p.id == prescriptionId);
//     if (index == -1) return;

//     _allPrescriptions[index] = _allPrescriptions[index].copyWith(
//       status: PrescriptionStatus.processed,
//     );
//   }
// }

import 'package:get/get.dart';
import 'package:stock_mate_project/core/models/PrescriptionModel.dart';

/// الكونترولر المسؤول عن إدارة كل الوصفات الطبية:
/// - تخزين القائمة الكاملة (مصدر الحقيقة الوحيد)
/// - فلترة الوصفات الجديدة / المعالجة بناءً على status
/// - البحث باسم المريض لكل صفحة على حدة (حقلا بحث منفصلان)
/// - تحويل حالة الوصفة من newRx إلى processed
class PrescriptionController extends GetxController {
  // القائمة الكاملة لكل الوصفات (مصدر الحقيقة)
  final RxList<PrescriptionModel> _allPrescriptions = <PrescriptionModel>[].obs;

  // نصوص البحث منفصلة لكل صفحة حتى لا يؤثر بحث صفحة على الأخرى
  final RxString newRxSearchQuery = ''.obs;
  final RxString processedSearchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
  }

  void _loadDummyData() {
    _allPrescriptions.addAll([
      PrescriptionModel(
        id: '1',
        patientName: 'أحمد محمد العتيبي',
        doctorName: 'د. سارة الحربي',
        condition: 'التهاب الجيوب الأنفية',
        medications: 'Amoxicillin 500mg - 3 مرات يومياً لمدة 7 أيام',
        notes: 'يفضل تناول الدواء بعد الأكل',
        date: DateTime(2025, 1, 10),
        status: PrescriptionStatus.newRx,
      ),
      PrescriptionModel(
        id: '2',
        patientName: 'فاطمة عبدالله القحطاني',
        doctorName: 'د. خالد المطيري',
        condition: 'ارتفاع ضغط الدم',
        medications: 'Amlodipine 5mg - مرة واحدة يومياً',
        notes: null,
        date: DateTime(2025, 1, 12),
        status: PrescriptionStatus.processed,
      ),
      PrescriptionModel(
        id: '3',
        patientName: 'عبدالرحمن سعيد الزهراني',
        doctorName: 'د. منى الشمري',
        condition: 'السكري من النوع الثاني',
        medications: 'Metformin 850mg - مرتين يومياً',
        notes: 'مراجعة بعد شهر لمتابعة مستوى السكر',
        date: DateTime(2025, 1, 15),
        status: PrescriptionStatus.newRx,
      ),
      PrescriptionModel(
        id: '4',
        patientName: 'نورة إبراهيم العنزي',
        doctorName: 'د. يوسف الدوسري',
        condition: 'حساسية موسمية',
        medications: 'Cetirizine 10mg - مرة واحدة يومياً عند الحاجة',
        notes: null,
        date: DateTime(2025, 1, 18),
        status: PrescriptionStatus.processed,
      ),
      PrescriptionModel(
        id: '5',
        patientName: 'سلطان فهد الغامدي',
        doctorName: 'د. ريم العتيبي',
        condition: 'التهاب الحلق البكتيري',
        medications: 'Azithromycin 250mg - مرة واحدة يومياً لمدة 5 أيام',
        notes: 'تجنب الحليب قبل وبعد الجرعة بساعتين',
        date: DateTime(2025, 1, 20),
        status: PrescriptionStatus.newRx,
      ),
      PrescriptionModel(
        id: '6',
        patientName: 'هند عبدالعزيز السبيعي',
        doctorName: 'د. ماجد القرني',
        condition: 'صداع نصفي مزمن',
        medications: 'Sumatriptan 50mg - عند بدء النوبة',
        notes: 'لا تتجاوز جرعتين خلال 24 ساعة',
        date: DateTime(2025, 1, 22),
        status: PrescriptionStatus.processed,
      ),
    ]);
  }

  // ===== تطبيع النص العربي لتجاهل فروق الهمزات والتاء المربوطة =====

  String _normalizeArabic(String text) {
    return text
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي');
  }

  // ===== Getters محسوبة (تتحدث تلقائيًا بفضل Rx) =====

  /// كل الوصفات الجديدة، مفلترة حسب نص البحث الخاص بصفحة الوصفات الجديدة
  List<PrescriptionModel> get newPrescriptions {
    final list = _allPrescriptions
        .where((p) => p.status == PrescriptionStatus.newRx)
        .toList();

    if (newRxSearchQuery.value.trim().isEmpty) return list;

    final query = _normalizeArabic(newRxSearchQuery.value.trim().toLowerCase());
    return list
        .where((p) => _normalizeArabic(p.patientName.toLowerCase()).contains(query))
        .toList();
  }

  /// كل الوصفات المعالجة، مفلترة حسب نص البحث الخاص بصفحة الوصفات المعالجة
  List<PrescriptionModel> get processedPrescriptions {
    final list = _allPrescriptions
        .where((p) => p.status == PrescriptionStatus.processed)
        .toList();

    if (processedSearchQuery.value.trim().isEmpty) return list;

    final query = _normalizeArabic(processedSearchQuery.value.trim().toLowerCase());
    return list
        .where((p) => _normalizeArabic(p.patientName.toLowerCase()).contains(query))
        .toList();
  }

  // ===== تحديث البحث =====

  void updateNewRxSearch(String value) => newRxSearchQuery.value = value;

  void updateProcessedSearch(String value) =>
      processedSearchQuery.value = value;

  // ===== البحث عن وصفة بمعرّفها (يُستخدم لربط الـ sheet بالحالة الحيّة) =====

  PrescriptionModel? findById(String id) {
    final index = _allPrescriptions.indexWhere((p) => p.id == id);
    if (index == -1) return null;
    return _allPrescriptions[index];
  }

  // ===== تحويل حالة الوصفة =====

  /// يحوّل الوصفة من newRx إلى processed.
  /// بما أن _allPrescriptions هي RxList، فإن تعديل عنصر بداخلها
  /// والمناداة على refresh() (أو إعادة تعيين بـ [index] = ...) كافٍ
  /// لإعادة بناء أي Obx/GetX مرتبط بها — فينتقل الكونتينر تلقائيًا
  /// من صفحة الوصفات الجديدة إلى صفحة الوصفات المعالجة.
  void markAsProcessed(String prescriptionId) {
    final index = _allPrescriptions.indexWhere((p) => p.id == prescriptionId);
    if (index == -1) return;

    _allPrescriptions[index] = _allPrescriptions[index].copyWith(
      status: PrescriptionStatus.processed,
    );
  }
}