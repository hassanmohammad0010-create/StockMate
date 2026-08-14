// // ignore_for_file: file_names

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:stock_mate_project/Constant/Const.dart';
// import 'package:stock_mate_project/Service/Head%20of%20department/Complete_Medical_Visit_Service.dart';
// import 'package:stock_mate_project/Service/Head%20of%20department/Get_Patient_History_Service.dart';
// import 'package:stock_mate_project/core/models/Patient_Details_Info.dart';
// import 'package:stock_mate_project/Controller/Service/Send_Prescription_Controller.dart';
// import 'package:stock_mate_project/Service/Head%20of%20department/Release_Queue_Entry_Service.dart';
// import 'package:stock_mate_project/Service/Head%20of%20department/Select_Patient_For_Consultation_Service.dart';
// import 'package:stock_mate_project/Controller/Service/Patients_Controller.dart';
// import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
// import 'package:stock_mate_project/core/models/Patient_Model.dart';
// import 'package:stock_mate_project/core/router/app_routes.dart';

// class PatientDetailsController extends GetxController {
//   PatientDetailsController({required this.patient});

//   final PatientListItem patient;

//   final GetPatientHistoryService _historyService = GetPatientHistoryService();
//   final SelectPatientForConsultationService _selectService =
//       SelectPatientForConsultationService();
//   final ReleaseQueueEntryService _releaseService = ReleaseQueueEntryService();
//   final CompleteMedicalVisitService _completeService =
//       CompleteMedicalVisitService();

//   // ─── Reactive state ───────────────────────────────────────────────
//   final Rxn<PatientDetailsResponse> details = Rxn<PatientDetailsResponse>();
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;

//   // ─── حالة الحجز ───────────────────────────────────────────────────
//   final RxBool isBooking = false.obs;
//   final RxBool isBooked = false.obs;
//   final RxBool isReleasing = false.obs;

//   // ─── ✅ حالة إنهاء المعاينة ────────────────────────────────────────
//   final RxBool isCompleting = false.obs;

//   // ─── TextEditingControllers ──────────────────────────────────────
//   final TextEditingController diagnosisController = TextEditingController();
//   final TextEditingController clinicalNotesController = TextEditingController();
//   final TextEditingController externalMedicationsController =
//       TextEditingController();

//   @override
//   void onInit() {
//     super.onInit();
//     _ensurePrescriptionController();
//     fetchHistory();
//   }

//   @override
//   void onClose() {
//     diagnosisController.dispose();
//     clinicalNotesController.dispose();
//     externalMedicationsController.dispose();
//     super.onClose();
//   }

//   /// ✅ التأكد من أن PrescriptionController مسجل (مشترك مع صفحة الوصفات)
//   void _ensurePrescriptionController() {
//     if (!Get.isRegistered<SendPrescriptionController>()) {
//       Get.put(SendPrescriptionController());
//     }
//   }

//   SendPrescriptionController get prescriptionController =>
//       Get.find<SendPrescriptionController>();

//   // ─── جلب السجل الطبي ──────────────────────────────────────────────
//   Future<void> fetchHistory() async {
//     isLoading.value = true;
//     errorMessage.value = '';

//     try {
//       final result = await _historyService.getPatientHistory(
//         patientId: patient.id,
//       );

//       if (result == null) {
//         errorMessage.value = 'تعذر تحميل السجل الطبي';
//       } else {
//         details.value = result;
//       }
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // ─── حجز المريض ───────────────────────────────────────────────────
//   Future<void> bookPatient() async {
//     final entryId = patient.queueEntryId;
//     if (entryId == null || entryId.isEmpty) {
//       customSnackBar(
//         title: 'خطأ',
//         message: 'لا يمكن الحجز: معرف الطابور غير متوفر',
//         color: constRed,
//         messageColor: Colors.white,
//       );
//       return;
//     }
//     if (isBooking.value || isBooked.value) return;

//     isBooking.value = true;
//     try {
//       final success = await _selectService.selectPatient(queueEntryId: entryId);
//       if (success) {
//         isBooked.value = true;
//         customSnackBar(
//           title: 'تم الحجز',
//           message: 'تم حجز ${patient.name} — الحالة الآن: قيد المعاينة',
//           color: constGreen,
//           messageColor: Colors.white,
//         );
//         if (Get.isRegistered<PatientsController>()) {
//           Get.find<PatientsController>().markInConsultation(patient.id);
//         }
//       } else {
//         customSnackBar(
//           title: 'فشل الحجز',
//           message: 'تعذر حجز المريض، حاول مرة أخرى',
//           color: constRed,
//           messageColor: Colors.white,
//         );
//       }
//     } finally {
//       isBooking.value = false;
//     }
//   }

//   // ─── إلغاء الحجز ──────────────────────────────────────────────────
//   Future<void> releasePatient() async {
//     final entryId = patient.queueEntryId;
//     if (entryId == null || entryId.isEmpty) {
//       customSnackBar(
//         title: 'خطأ',
//         message: 'لا يمكن إلغاء الحجز: معرف الطابور غير متوفر',
//         color: constRed,
//         messageColor: Colors.white,
//       );
//       return;
//     }
//     if (isReleasing.value || !isBooked.value) return;

//     isReleasing.value = true;
//     try {
//       final success = await _releaseService.releaseQueueEntry(
//         queueEntryId: entryId,
//       );
//       if (success) {
//         isBooked.value = false;
//         customSnackBar(
//           title: 'تم إلغاء الحجز',
//           message: 'أُعيد ${patient.name} إلى قائمة الانتظار',
//           color: constOrange,
//           messageColor: Colors.white,
//         );
//         if (Get.isRegistered<PatientsController>()) {
//           await Get.find<PatientsController>().fetchPatients();
//         }
//         Get.offNamed(AppRoutes.PatientsPage); // العودة إلى صفحة قائمة المرضى
//       } else {
//         customSnackBar(
//           title: 'فشل إلغاء الحجز',
//           message: 'تعذر إلغاء الحجز، حاول مرة أخرى',
//           color: constRed,
//           messageColor: Colors.white,
//         );
//       }
//     } finally {
//       isReleasing.value = false;
//     }
//   }

//   // ─── ✅✅✅ إنهاء المعاينة ─ POST /medical-visits/complete ─────────
//   Future<void> completeConsultation() async {
//     final entryId = patient.queueEntryId;
//     if (entryId == null || entryId.isEmpty) {
//       customSnackBar(
//         title: 'خطأ',
//         message: 'لا يمكن الإنهاء: معرف الطابور غير متوفر',
//         color: constRed,
//         messageColor: Colors.white,
//       );
//       return;
//     }

//     if (isCompleting.value) return;

//     isCompleting.value = true;
//     try {
//       final success = await _completeService.completeVisit(
//         queueEntryId: entryId,
//         diagnosis: diagnosisController.text.trim(),
//         clinicalNotes: clinicalNotesController.text.trim(),
//         externalMedications: externalMedicationsController.text.trim(),
//         prescriptions: prescriptionController.prescriptions.toList(),
//       );

//       if (success) {
//         customSnackBar(
//           title: 'تم إنهاء المعاينة',
//           message: 'تم إنهاء معاينة ${patient.name} بنجاح',
//           color: constGreen,
//           messageColor: Colors.white,
//         );

//         // ✅ تنظيف الوصفات للاستخدام القادم
//         prescriptionController.clearAll();

//         // ✅ إعادة جلب قائمة الانتظار
//         if (Get.isRegistered<PatientsController>()) {
//           await Get.find<PatientsController>().fetchPatients();
//         }

//         Get.offNamed(AppRoutes.PatientsPage); // العودة إلى صفحة قائمة المرضى
//       } else {
//         customSnackBar(
//           title: 'فشل الإنهاء',
//           message: 'تعذر إنهاء المعاينة، حاول مرة أخرى',
//           color: constRed,
//           messageColor: Colors.white,
//         );
//       }
//     } finally {
//       isCompleting.value = false;
//     }
//   }

//   // void attachPrescription() {
//   //   // هذا الزر سيستبدل بزر "إنهاء المعاينة" الذي يفتح bottom sheet
//   // }
// }
