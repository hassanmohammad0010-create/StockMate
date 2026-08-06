// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/archiveController.dart';
import 'package:stock_mate_project/Controller/Logic/Patients_Controller.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/models/Patient_Model.dart';

/// قائمة الأدوية المتاحة للاختيار.
const List<String> kMedicinesList = [
  'باراسيتامول',
  'إيبوبروفين',
  'أموكسيسيلين',
  'أوميبرازول',
  'سيتريزين',
  'ميتفورمين',
  'أتورفاستاتين',
  'أملوديبين',
  'فيتامين د',
  'حمض الفوليك',
];

/// يمثّل سطر دواء واحد داخل الوصفة.
class PrescriptionMedicineEntry {
  PrescriptionMedicineEntry({String? medicineName})
      : id = UniqueKey().toString(),
        medicineName = Rxn<String>(medicineName),
        quantity = 1.obs;

  final String id;
  final Rxn<String> medicineName;
  final RxInt quantity;
}

class SendNewPrescriptionController extends GetxController {
  SendNewPrescriptionController({required this.patient});

  final PatientModel patient;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// الحد الأقصى لعدد الأدوية في الوصفة الواحدة
  static const int maxMedicines = 10;

  final RxList<PrescriptionMedicineEntry> medicineEntries =
      <PrescriptionMedicineEntry>[].obs;

  final TextEditingController notesController = TextEditingController();

  /// هل تم الوصول للحد الأقصى؟
  bool get isMaxReached => medicineEntries.length >= maxMedicines;

  @override
  void onInit() {
    super.onInit();
    medicineEntries.add(PrescriptionMedicineEntry());
  }

  void addMedicineEntry() {
    if (isMaxReached) {
      customSnackBar(
        title: 'تنبيه',
        message: 'لا يمكن إضافة أكثر من $maxMedicines أدوية في الوصفة الواحدة',
        color: constRed,
        messageColor: Colors.white,
      );
      return;
    }
    medicineEntries.add(PrescriptionMedicineEntry());
  }

  void removeMedicineEntry(String entryId) {
    if (medicineEntries.length <= 1) return;
    medicineEntries.removeWhere((e) => e.id == entryId);
  }

  // ✅ صار فقط يحدّث القيمة؛ التحقق من الصحة أصبح مسؤولية الـ validator بالـ Form
  void selectMedicine(String entryId, String? value) {
    final entry = medicineEntries.firstWhereOrNull((e) => e.id == entryId);
    if (entry == null) return;
    entry.medicineName.value = value;
    medicineEntries.refresh();
  }

  /// دالة لتحديث الكمية
  void updateQuantity(String entryId, int newQuantity) {
    final entry = medicineEntries.firstWhereOrNull((e) => e.id == entryId);
    if (entry == null) return;
    
    if (newQuantity < 1) {
      entry.quantity.value = 1;
    } else if (newQuantity > 99) {
      entry.quantity.value = 99;
    } else {
      entry.quantity.value = newQuantity;
    }
    medicineEntries.refresh();
  }

  // ✅ إرجاع bool لمعرفة ما إذا نجح الإرسال أم لا للتحكم في التنقل
  Future<bool> sendPrescription() async {
    final isFormValid = formKey.currentState?.validate() ?? false;

    if (!isFormValid) {
      customSnackBar(
        title: 'تنبيه',
        message: 'يرجى اختيار جميع الأدوية قبل الإرسال',
        color: constRed,
        messageColor: Colors.white,
      );
      return false;
    }

    final medicines = medicineEntries
        .map((e) => '${e.medicineName.value!} (${e.quantity.value} قطعة)')
        .toList();

    final notes = notesController.text.trim().isEmpty
        ? null
        : notesController.text.trim();

    final medicationsText = medicines.join('\n');

    final archiveController = ArchiveController.to;

    await archiveController.addPrescriptionToArchive(
      patientName: patient.name,
      medications: medicationsText,
      notes: notes,
    );

    // TODO: إرسال الوصفة إلى الباك اند لاحقاً

    if (Get.isRegistered<PatientsController>()) {
      Get.find<PatientsController>().completeConsultation(patient.id);
    }

    customSnackBar(
      title: 'تم الإرسال',
      message: 'تم إرسال الوصفة الطبية لـ ${patient.name}',
      color: constGreen,
      messageColor: Colors.white,
    );

    return true;
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}