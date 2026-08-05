// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/core/models/PrescriptionModel.dart';

class PrescriptionController extends GetxController {
  final RxList<PrescriptionModel> _allPrescriptions = <PrescriptionModel>[].obs;

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
        patientName: 'حسن نضال محمد',
        doctorName: 'د. سارة الحربي',
        medications:
            'Amoxicillin 500mg (3 قطع)\nOmeprazole 20mg (2 قطع)\nParacetamol 1g (6 قطع)\nVitamin D3 5000IU (1 قطع)\nAzithromycin 250mg (5 قطع)',
        notes: 'يفضل تناول الدواء بعد الأكل',
        date: DateTime(2025, 1, 10),
        status: PrescriptionStatus.newRx,
      ),
      PrescriptionModel(
        id: '2',
        patientName: 'حامد احمد زاهر',
        doctorName: 'د. خالد المطيري',
        medications:
            'Amlodipine 5mg (2 قطع)\nMetformin 850mg (4 قطع)\nAtorvastatin 20mg (3 قطع)\nAspirin 81mg (6 قطع)\nLosartan 50mg (2 قطع)\nFurosemide 40mg (1 قطع)',
        notes: null,
        date: DateTime(2025, 1, 12),
        status: PrescriptionStatus.processed,
      ),
      PrescriptionModel(
        id: '3',
        patientName: 'محمد عبيدة نتوف',
        doctorName: 'د. محمد علي',
        medications: 'Metformin 850mg (4 قطع)\nGlimepiride 2mg (2 قطع)',
        notes: 'مراجعة بعد شهر لمتابعة مستوى السكر',
        date: DateTime(2025, 1, 15),
        status: PrescriptionStatus.newRx,
      ),
      PrescriptionModel(
        id: '4',
        patientName: 'مايا محمد',
        doctorName: 'د. يوسف الدوسري',
        medications:
            'Cetirizine 10mg (3 قطع)\nMontelukast 10mg (2 قطع)\nFluticasone Nasal Spray (1 قطع)\nSalbutamol Inhaler (1 قطع)\nPrednisolone 5mg (5 قطع)',
        notes: null,
        date: DateTime(2025, 1, 18),
        status: PrescriptionStatus.processed,
      ),
      PrescriptionModel(
        id: '5',
        patientName: 'سلطان فهد الحسين',
        doctorName: 'د. ريم العتيبي',
        medications:
            'Azithromycin 250mg (3 قطع)\nIbuprofen 400mg (4 قطع)\nOmeprazole 20mg (2 قطع)\nVitamin C 1000mg (6 قطع)\nZinc 50mg (3 قطع)\nParacetamol 1g (8 قطع)\nORS Sachets (5 قطع)',
        notes: 'تجنب الحليب قبل وبعد الجرعة بساعتين',
        date: DateTime(2025, 1, 20),
        status: PrescriptionStatus.newRx,
      ),
      PrescriptionModel(
        id: '6',
        patientName: 'حمزة احمد مطر',
        doctorName: 'د. ماجد القرني',
        medications: 'Sumatriptan 50mg (2 قطع)\nNaproxen 550mg (4 قطع)',
        notes: 'لا تتجاوز جرعتين خلال 24 ساعة',
        date: DateTime(2025, 1, 22),
        status: PrescriptionStatus.processed,
      ),
      PrescriptionModel(
        id: '7',
        patientName: 'محمود احمد',
        doctorName: 'د. محمد علي',
        medications:
            'Amoxicillin 500mg (6 قطع)\nClavulanic Acid 125mg (3 قطع)\nIbuprofen 400mg (4 قطع)\nOmeprazole 20mg (2 قطع)\nVitamin B Complex (1 قطع)',
        date: DateTime(2025, 1, 22),
        status: PrescriptionStatus.newRx,
      ),
      PrescriptionModel(
        id: '8',
        patientName: 'حمزة احمد',
        doctorName: 'د. مجد الشيخ',
        medications: 'Sumatriptan 50mg (4 قطع)',
        notes: 'لا تتجاوز جرعتين خلال 24 ساعة',
        date: DateTime(2025, 1, 22),
        status: PrescriptionStatus.newRx,
      ),
    ]);
  }

  // ===== Getters =====

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

  void updateNewRxSearch(String value) => newRxSearchQuery.value = value;

  void updateProcessedSearch(String value) =>
      processedSearchQuery.value = value;

  PrescriptionModel? findById(String id) {
    final index = _allPrescriptions.indexWhere((p) => p.id == id);
    if (index == -1) return null;
    return _allPrescriptions[index];
  }

  /// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  /// دالة صرف الوصفة مع تحديث الكميات المُعطاة
  ///
  /// [id] : معرف الوصفة
  /// [givenQuantities] : خريطة من اسم الدواء → الكمية المُعطاة فعلياً
  ///
  /// إذا لم يوجد دواء في الخريطة، يُفترض أن الكمية المطلوبة كاملة تم صرفها.
  /// إذا كانت الكمية المُعطاة مختلفة، يُحفظ النص بصيغة:
  /// "اسم الدواء (X قطعة من أصل Y)"
  /// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  void updatePrescriptionQuantities(
    String id,
    Map<String, int> givenQuantities,
  ) {
    final index = _allPrescriptions.indexWhere((p) => p.id == id);
    if (index == -1) return;

    final prescription = _allPrescriptions[index];

    // بناء نص الأدوية الجديد مع الكميات المعطاة
    final medicationItems = prescription.medicationItems;
    
    final updatedMedicationsText = medicationItems.map((med) {
      final givenQty = givenQuantities[med.name];
      
      // إذا لم يُدخل الصيدلي قيمة → صرف كامل الكمية المطلوبة
      if (givenQty == null || givenQty == med.requestedQuantity) {
        return '${med.name} (${med.requestedQuantity} قطع)';
      }
      
      // إذا أدخل قيمة مختلفة عن المطلوبة → سجل بصيغة "من أصل"
      return '${med.name} ($givenQty قطعة من أصل ${med.requestedQuantity})';
    }).join('\n');

    // تحديث الوصفة وصرفها
    final updatedPrescription = prescription.copyWith(
      medications: updatedMedicationsText,
      status: PrescriptionStatus.processed,
    );

    _allPrescriptions[index] = updatedPrescription;
    _allPrescriptions.refresh();
  }

  /// حذف وصفة من القائمة (اختياري - للاستخدام المستقبلي)
  void deletePrescription(String id) {
    _allPrescriptions.removeWhere((p) => p.id == id);
  }

  /// إضافة وصفة جديدة
  void addPrescription(PrescriptionModel prescription) {
    _allPrescriptions.insert(0, prescription);
  }
}