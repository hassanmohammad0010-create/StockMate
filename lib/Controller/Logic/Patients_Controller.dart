// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/core/models/Patient_Model.dart';

class PatientsController extends GetxController {
  final RxList<PatientModel> patients = <PatientModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyPatients();
  }

  void _loadDummyPatients() {
    final now = DateTime.now();

    final dummyList = <PatientModel>[
      PatientModel(
        id: '1',
        name: 'أحمد محمد علي',
        nationalNumber: '1990010112345',
        arrivalTime: now.subtract(const Duration(hours: 2, minutes: 15)),
        status: 'في الانتظار',
      ),
      PatientModel(
        id: '2',
        name: 'سارة خالد أحمد',
        nationalNumber: '1992030587654',
        arrivalTime: now.subtract(const Duration(hours: 1, minutes: 40)),
        status: 'في الانتظار',
      ),
      PatientModel(
        id: '3',
        name: 'محمود يوسف حسن',
        nationalNumber: '1985071223456',
        arrivalTime: now.subtract(const Duration(hours: 1, minutes: 10)),
        status: 'في الانتظار',
      ),
      PatientModel(
        id: '4',
        name: 'فاطمة عبدالله',
        nationalNumber: '1998112298765',
        arrivalTime: now.subtract(const Duration(minutes: 55)),
        status: 'في الانتظار',
      ),
      PatientModel(
        id: '5',
        name: 'عمر إبراهيم',
        nationalNumber: '1988040433221',
        arrivalTime: now.subtract(const Duration(minutes: 40)),
        status: 'في الانتظار',
      ),
      PatientModel(
        id: '6',
        name: 'ليلى سعيد',
        nationalNumber: '1995062211223',
        arrivalTime: now.subtract(const Duration(minutes: 30)),
        status: 'في الانتظار',
      ),
      PatientModel(
        id: '7',
        name: 'خالد ناصر',
        nationalNumber: '1991090999887',
        arrivalTime: now.subtract(const Duration(minutes: 22)),
        status: 'في الانتظار',
      ),
      PatientModel(
        id: '8',
        name: 'مريم طارق',
        nationalNumber: '1997051166554',
        arrivalTime: now.subtract(const Duration(minutes: 15)),
        status: 'في الانتظار',
      ),
      PatientModel(
        id: '9',
        name: 'يوسف كمال',
        nationalNumber: '1993081277889',
        arrivalTime: now.subtract(const Duration(minutes: 8)),
        status: 'في الانتظار',
      ),
      PatientModel(
        id: '10',
        name: 'هدى وليد',
        nationalNumber: '1999122344556',
        arrivalTime: now.subtract(const Duration(minutes: 3)),
        status: 'في الانتظار',
      ),
    ];

    patients.assignAll(dummyList);
    sortPatientsByWaitTime();
  }

  void sortPatientsByWaitTime() {
    patients.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
  }

  /// دالة لتحديث حالة المريض (تدعم التبديل بين الحالتين)
  void updatePatientStatus(String id, String newStatus) {
    final index = patients.indexWhere((p) => p.id == id);
    if (index != -1) {
      patients[index] = patients[index].copyWith(status: newStatus);
      patients.refresh(); // إشعار الواجهة بالتحديث فوراً
    }
  }

  /// دالة لإنهاء المعاينة (تغيير الحالة إلى "تمت المعاينة" بدلاً من الحذف)
  void completeConsultation(String id) {
    updatePatientStatus(id, 'تمت المعاينة');
  }

  /// دالة مساعدة لإزالة المريض من القائمة (موجودة لاستخدامات مستقبلية إذا احتجتها)
  void removePatient(String id) {
    patients.removeWhere((p) => p.id == id);
  }
}