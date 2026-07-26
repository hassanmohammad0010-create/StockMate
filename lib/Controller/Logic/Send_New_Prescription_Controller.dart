// // ignore_for_file: file_names

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:stock_mate_project/Constant/Const.dart';
// import 'package:stock_mate_project/Controller/Logic/ArchiveController.dart';
// import 'package:stock_mate_project/Controller/Logic/Patients_Controller.dart';
// import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
// import 'package:stock_mate_project/core/models/Patient_Model.dart';

// /// قائمة الأدوية المتاحة للاختيار.
// const List<String> kMedicinesList = [
//   'باراسيتامول',
//   'إيبوبروفين',
//   'أموكسيسيلين',
//   'أوميبرازول',
//   'سيتريزين',
//   'ميتفورمين',
//   'أتورفاستاتين',
//   'أملوديبين',
//   'فيتامين د',
//   'حمض الفوليك',
// ];

// /// يمثّل سطر دواء واحد داخل الوصفة.
// class PrescriptionMedicineEntry {
//   PrescriptionMedicineEntry({String? medicineName})
//       : id = UniqueKey().toString(),
//         medicineName = Rxn<String>(medicineName);

//   final String id;
//   final Rxn<String> medicineName;
// }

// class SendNewPrescriptionController extends GetxController {
//   SendNewPrescriptionController({required this.patient});

//   final PatientModel patient;

//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   final RxList<PrescriptionMedicineEntry> medicineEntries =
//       <PrescriptionMedicineEntry>[].obs;

//   final RxSet<String> invalidEntryIds = <String>{}.obs;

//   final TextEditingController notesController = TextEditingController();

//   @override
//   void onInit() {
//     super.onInit();
//     medicineEntries.add(PrescriptionMedicineEntry());
//   }

//   void addMedicineEntry() {
//     medicineEntries.add(PrescriptionMedicineEntry());
//   }

//   void removeMedicineEntry(String entryId) {
//     if (medicineEntries.length <= 1) return;
//     medicineEntries.removeWhere((e) => e.id == entryId);
//     invalidEntryIds.remove(entryId);
//   }

//   void selectMedicine(String entryId, String? value) {
//     final entry = medicineEntries.firstWhereOrNull((e) => e.id == entryId);
//     if (entry == null) return;
//     entry.medicineName.value = value;
//     if (value != null) invalidEntryIds.remove(entryId);
//     medicineEntries.refresh();
//   }

//   bool get isFormValid {
//     invalidEntryIds.clear();
//     for (final entry in medicineEntries) {
//       if (entry.medicineName.value == null) {
//         invalidEntryIds.add(entry.id);
//       }
//     }
//     return invalidEntryIds.isEmpty;
//   }

//   // ─── ✅ التعديل: async + await ───
//   Future<void> sendPrescription() async {
//     if (!isFormValid) {
//       invalidEntryIds.refresh();
//       customSnackBar(
//         title: 'تنبيه',
//         message: 'يرجى اختيار جميع الأدوية قبل الإرسال',
//         color: constRed,
//         messageColor: Colors.white,
//       );
//       return;
//     }

//     final medicines = medicineEntries
//         .map((e) => e.medicineName.value!)
//         .toList();

//     // ✅ التعديل: null إذا كان فارغاً
//     final notes = notesController.text.trim().isEmpty
//         ? null
//         : notesController.text.trim();

//     // كل دواء بسطر منفصل
//     final medicationsText = medicines.join('\n');

//     final archiveController = ArchiveController.to;

//     // ✅ التعديل: await لضمان اكتمال الحفظ قبل الانتقال
//     await archiveController.addPrescriptionToArchive(
//       patientName: patient.name,
//       medications: medicationsText,
//       notes: notes,
//     );

//     // TODO: إرسال الوصفة إلى الباك اند لاحقاً

//     if (Get.isRegistered<PatientsController>()) {
//       Get.find<PatientsController>().completeConsultation(patient.id);
//     }

//     customSnackBar(
//       title: 'تم الإرسال',
//       message: 'تم إرسال الوصفة الطبية لـ ${patient.name}',
//       color: constGreen,
//       messageColor: Colors.white,
//     );

//     Get.back();
//   }

//   @override
//   void onClose() {
//     notesController.dispose();
//     super.onClose();
//   }
// }
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/ArchiveController.dart';
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
        medicineName = Rxn<String>(medicineName);

  final String id;
  final Rxn<String> medicineName;
}

class SendNewPrescriptionController extends GetxController {
  SendNewPrescriptionController({required this.patient});

  final PatientModel patient;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// الحد الأقصى لعدد الأدوية في الوصفة الواحدة
  static const int maxMedicines = 10;

  final RxList<PrescriptionMedicineEntry> medicineEntries =
      <PrescriptionMedicineEntry>[].obs;

  final RxSet<String> invalidEntryIds = <String>{}.obs;

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
    invalidEntryIds.remove(entryId);
  }

  void selectMedicine(String entryId, String? value) {
    final entry = medicineEntries.firstWhereOrNull((e) => e.id == entryId);
    if (entry == null) return;
    entry.medicineName.value = value;
    if (value != null) invalidEntryIds.remove(entryId);
    medicineEntries.refresh();
  }

  bool get isFormValid {
    invalidEntryIds.clear();
    for (final entry in medicineEntries) {
      if (entry.medicineName.value == null) {
        invalidEntryIds.add(entry.id);
      }
    }
    return invalidEntryIds.isEmpty;
  }

  Future<void> sendPrescription() async {
    if (!isFormValid) {
      invalidEntryIds.refresh();
      customSnackBar(
        title: 'تنبيه',
        message: 'يرجى اختيار جميع الأدوية قبل الإرسال',
        color: constRed,
        messageColor: Colors.white,
      );
      return;
    }

    final medicines = medicineEntries
        .map((e) => e.medicineName.value!)
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

    Get.back();
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}