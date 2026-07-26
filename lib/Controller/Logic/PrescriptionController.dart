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
            'Amoxicillin 500mg\nOmeprazole 20mg\nParacetamol 1g\nVitamin D3 5000IU\nAzithromycin 250mg',
        notes: 'يفضل تناول الدواء بعد الأكل',
        date: DateTime(2025, 1, 10),
        status: PrescriptionStatus.newRx,
      ),
      PrescriptionModel(
        id: '2',
        patientName: 'حامد احمد زاهر',
        doctorName: 'د. خالد المطيري',
        medications:
            'Amlodipine 5mg\nMetformin 850mg\nAtorvastatin 20mg\nAspirin 81mg\nLosartan 50mg\nFurosemide 40mg',
        notes: null,
        date: DateTime(2025, 1, 12),
        status: PrescriptionStatus.processed,
      ),
      PrescriptionModel(
        id: '3',
        patientName: 'محمد عبيدة نتوف',
        doctorName: 'د. محمد علي',
        medications: 'Metformin 850mg\nGlimepiride 2mg',
        notes: 'مراجعة بعد شهر لمتابعة مستوى السكر',
        date: DateTime(2025, 1, 15),
        status: PrescriptionStatus.newRx,
      ),
      PrescriptionModel(
        id: '4',
        patientName: 'مايا محمد',
        doctorName: 'د. يوسف الدوسري',
        medications:
            'Cetirizine 10mg\nMontelukast 10mg\nFluticasone Nasal Spray\nSalbutamol Inhaler\nPrednisolone 5mg',
        notes: null,
        date: DateTime(2025, 1, 18),
        status: PrescriptionStatus.processed,
      ),
      PrescriptionModel(
        id: '5',
        patientName: 'سلطان فهد الحسين',
        doctorName: 'د. ريم العتيبي',
        medications:
            'Azithromycin 250mg\nIbuprofen 400mg\nOmeprazole 20mg\nVitamin C 1000mg\nZinc 50mg\nParacetamol 1g\nORS Sachets',
        notes: 'تجنب الحليب قبل وبعد الجرعة بساعتين',
        date: DateTime(2025, 1, 20),
        status: PrescriptionStatus.newRx,
      ),
      PrescriptionModel(
        id: '6',
        patientName: 'حمزة احمد مطر',
        doctorName: 'د. ماجد القرني',
        medications: 'Sumatriptan 50mg\nNaproxen 550mg',
        notes: 'لا تتجاوز جرعتين خلال 24 ساعة',
        date: DateTime(2025, 1, 22),
        status: PrescriptionStatus.processed,
      ),
      PrescriptionModel(
        id: '7',
        patientName: 'محمود احمد',
        doctorName: 'د. محمد علي',
        medications:
            'Amoxicillin 500mg\nClavulanic Acid 125mg\nIbuprofen 400mg\nOmeprazole 20mg\nVitamin B Complex',
        date: DateTime(2025, 1, 22),
        status: PrescriptionStatus.newRx,
      ),
      PrescriptionModel(
        id: '8',
        patientName: 'حمزة احمد',
        doctorName: 'د. مجد الشيخ',
        medications: 'Sumatriptan 50mg',
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
}