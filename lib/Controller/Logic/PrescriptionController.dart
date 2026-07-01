// ignore_for_file: file_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:stock_mate_project/core/models/PrescriptionModel.dart';
import 'package:stock_mate_project/main.dart';

/// الكونترولر المسؤول عن إدارة كل الوصفات الطبية:
/// - تخزين القائمة الكاملة (مصدر الحقيقة الوحيد)
/// - فلترة الوصفات الجديدة / المعالجة بناءً على status
/// - البحث باسم المريض لكل صفحة على حدة (حقلا بحث منفصلان)
/// - تحويل حالة الوصفة من newRx إلى processed
/// - حفظ/استرجاع القائمة محليًا عبر SharedPreferences (المتغير shareprefs
///   المُعرّف في main.dart) حتى تبقى التغييرات بعد إغلاق التطبيق
class PrescriptionController extends GetxController {
  // المفتاح المستخدم لتخزين/قراءة قائمة الوصفات في SharedPreferences
  static const String _storageKey = 'prescriptions_data';

  // القائمة الكاملة لكل الوصفات (مصدر الحقيقة)
  final RxList<PrescriptionModel> _allPrescriptions = <PrescriptionModel>[].obs;

  // نصوص البحث منفصلة لكل صفحة حتى لا يؤثر بحث صفحة على الأخرى
  final RxString newRxSearchQuery = ''.obs;
  final RxString processedSearchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromPrefs();
  }

  /// يحاول تحميل القائمة المحفوظة من SharedPreferences.
  /// إن لم توجد بيانات محفوظة (أول تشغيل للتطبيق)، يتم تحميل
  /// بيانات تجريبية ثم حفظها مباشرة لتكون نقطة بداية.
  void _loadFromPrefs() {
    final String? rawData = shareprefs?.getString(_storageKey);

    if (rawData == null || rawData.isEmpty) {
      _loadDummyData();
      _saveToPrefs();
      return;
    }

    try {
      final List<dynamic> decoded = jsonDecode(rawData) as List<dynamic>;
      final List<PrescriptionModel> loaded = decoded
          .map(
            (item) => PrescriptionModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
      _allPrescriptions.assignAll(loaded);
    } catch (_) {
      // في حال تلف البيانات المحفوظة لأي سبب، نرجع لبيانات تجريبية آمنة
      _loadDummyData();
      _saveToPrefs();
    }
  }

  /// يحوّل القائمة الحالية إلى JSON ويحفظها في SharedPreferences.
  /// يُستدعى تلقائيًا بعد أي تعديل على حالة وصفة.
  Future<void> _saveToPrefs() async {
    final String encoded = jsonEncode(
      _allPrescriptions.map((p) => p.toJson()).toList(),
    );
    await shareprefs?.setString(_storageKey, encoded);
  }

  void _loadDummyData() {
    _allPrescriptions.addAll([
      PrescriptionModel(
        id: '1',
        patientName: 'حسن نضال محمد',
        doctorName: 'د. سارة الحربي',
        condition: 'التهاب الجيوب الأنفية',
        medications: 'Amoxicillin 500mg - 3 مرات يومياً لمدة 7 أيام',
        notes: 'يفضل تناول الدواء بعد الأكل',
        date: DateTime(2025, 1, 10),
        status: PrescriptionStatus.newRx,
      ),
      PrescriptionModel(
        id: '2',
        patientName: 'حامد احمد زاهر',
        doctorName: 'د. خالد المطيري',
        condition: 'ارتفاع ضغط الدم',
        medications: 'Amlodipine 5mg - مرة واحدة يومياً',
        notes: null,
        date: DateTime(2025, 1, 12),
        status: PrescriptionStatus.processed,
      ),
      PrescriptionModel(
        id: '3',
        patientName: 'محمد عبيدة نتوف',
        doctorName: 'د. محمد علي',
        condition: 'السكري من النوع الثاني',
        medications: 'Metformin 850mg - مرتين يومياً',
        notes: 'مراجعة بعد شهر لمتابعة مستوى السكر',
        date: DateTime(2025, 1, 15),
        status: PrescriptionStatus.newRx,
      ),
      PrescriptionModel(
        id: '4',
        patientName: 'مايا محمد',
        doctorName: 'د. يوسف الدوسري',
        condition: 'حساسية موسمية',
        medications: 'Cetirizine 10mg - مرة واحدة يومياً عند الحاجة',
        notes: null,
        date: DateTime(2025, 1, 18),
        status: PrescriptionStatus.processed,
      ),
      PrescriptionModel(
        id: '5',
        patientName: 'سلطان فهد الحسين',
        doctorName: 'د. ريم العتيبي',
        condition: 'التهاب الحلق البكتيري',
        medications: 'Azithromycin 250mg - مرة واحدة يومياً لمدة 5 أيام',
        notes: 'تجنب الحليب قبل وبعد الجرعة بساعتين',
        date: DateTime(2025, 1, 20),
        status: PrescriptionStatus.newRx,
      ),
      PrescriptionModel(
        id: '6',
        patientName: 'حمزة احمد مطر',
        doctorName: 'د. ماجد القرني',
        condition: 'صداع نصفي مزمن',
        medications: 'Sumatriptan 50mg - عند بدء النوبة',
        notes: 'لا تتجاوز جرعتين خلال 24 ساعة',
        date: DateTime(2025, 1, 22),
        status: PrescriptionStatus.processed,
      ),
      PrescriptionModel(
        id: '7',
        patientName: 'محمود احمد',
        doctorName: 'د. محمد علي',
        condition: 'صداع نصفي مزمن',
        medications: 'Sumatriptan 50mg - عند بدء النوبة',
        date: DateTime(2025, 1, 22),
        status: PrescriptionStatus.newRx,
      ),
      PrescriptionModel(
        id: '8',
        patientName: 'حمزة احمد',
        doctorName: 'د. مجد الشيخ',
        condition: 'صداع نصفي مزمن',
        medications: 'Sumatriptan 50mg - عند بدء النوبة',
        notes: 'لا تتجاوز جرعتين خلال 24 ساعة',
        date: DateTime(2025, 1, 22),
        status: PrescriptionStatus.newRx,
      ),
    ]);
  }

  // ===== Getters محسوبة (تتحدث تلقائيًا بفضل Rx) =====

  /// كل الوصفات الجديدة، مفلترة حسب نص البحث الخاص بصفحة الوصفات الجديدة
  List<PrescriptionModel> get newPrescriptions {
    final query = newRxSearchQuery.value.trim().toLowerCase();
    final list = _allPrescriptions
        .where((p) => p.status == PrescriptionStatus.newRx)
        .toList();

    if (query.isEmpty) return list;
    return list
        .where((p) => p.patientName.toLowerCase().contains(query))
        .toList();
  }

  /// كل الوصفات المعالجة، مفلترة حسب نص البحث الخاص بصفحة الوصفات المعالجة
  List<PrescriptionModel> get processedPrescriptions {
    final query = processedSearchQuery.value.trim().toLowerCase();
    final list = _allPrescriptions
        .where((p) => p.status == PrescriptionStatus.processed)
        .toList();

    if (query.isEmpty) return list;
    return list
        .where((p) => p.patientName.toLowerCase().contains(query))
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

  /// يحوّل الوصفة من newRx إلى processed، ثم يحفظ القائمة كاملة في
  /// SharedPreferences فورًا حتى يبقى التغيير محفوظًا بعد إغلاق
  /// التطبيق أو الخروج من الصفحة والعودة إليها.
  void markAsProcessed(String prescriptionId) {
    final index = _allPrescriptions.indexWhere((p) => p.id == prescriptionId);
    if (index == -1) return;

    _allPrescriptions[index] = _allPrescriptions[index].copyWith(
      status: PrescriptionStatus.processed,
    );

    _saveToPrefs();
  }
}
