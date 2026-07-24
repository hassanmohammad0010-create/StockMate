// // ignore_for_file: file_names
// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:stock_mate_project/Controller/Logic/Cart_Controller.dart';
// import 'package:stock_mate_project/core/models/Archive_Model.dart';
// import 'package:stock_mate_project/core/models/Material_Model.dart';
// import 'package:stock_mate_project/core/router/app_routes.dart';
// import 'package:stock_mate_project/main.dart';

// class ArchiveItem {
//   final String date;
//   final List<ArchiveMedicineModel> medicines;

//   ArchiveItem({required this.date, required this.medicines});

//   Map<String, dynamic> toJson() => {
//     'date': date,
//     'medicines': medicines.map((m) => m.toJson()).toList(),
//   };

//   factory ArchiveItem.fromJson(Map<String, dynamic> json) => ArchiveItem(
//     date: json['date'] as String,
//     medicines: (json['medicines'] as List)
//         .map((m) => ArchiveMedicineModel.fromJson(m as Map<String, dynamic>))
//         .toList(),
//   );
// }

// class ArchiveController extends GetxController {
//   static ArchiveController get to => Get.isRegistered<ArchiveController>()
//       ? Get.find<ArchiveController>()
//       : Get.put(ArchiveController(), permanent: true);

//   static const String _archiveKey = 'archive_items';

//   final RxList<ArchiveItem> archiveList = <ArchiveItem>[].obs;

//   // ✅ أضف هذا السطر الجديد
//   final RxList<ArchiveItem> filteredArchiveList = <ArchiveItem>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _loadArchive();
//   }

//   void _loadArchive() {
//     final json = shareprefs?.getString(_archiveKey);
//     if (json == null) return;
//     try {
//       final List<dynamic> list = jsonDecode(json);
//       archiveList.value = list
//           .map((e) => ArchiveItem.fromJson(e as Map<String, dynamic>))
//           .toList();
//       // ✅ أضف هذا السطر
//       filteredArchiveList.value = List.from(archiveList);
//     } catch (_) {}
//   }

//   void _saveArchive() {
//     shareprefs?.setString(
//       _archiveKey,
//       jsonEncode(archiveList.map((e) => e.toJson()).toList()),
//     );
//   }

//   // ✅ أضف هذه الدالة الجديدة
//   void filterByDate(String? dateString) {
//     if (dateString == null || dateString.isEmpty) {
//       filteredArchiveList.value = List.from(archiveList);
//       return;
//     }

//     // تحويل التاريخ من YYYY-MM-DD إلى DD/MM/YYYY للمقارنة
//     final parts = dateString.split('-');
//     if (parts.length != 3) return;

//     final searchDate = '${parts[2]}/${parts[1]}/${parts[0]}';

//     filteredArchiveList.value = archiveList
//         .where((item) => item.date == searchDate)
//         .toList();
//   }

//   void confirmCart() {
//     final cartController = CartController.to;
//     if (cartController.cartItems.isEmpty) return;

//     final now = DateTime.now();
//     final date =
//         '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

//     final medicines = cartController.cartItems.map((cartItem) {
//       String company = '';
//       try {
//         final material = allMaterial.firstWhere(
//           (m) => m.id == cartItem.materialId,
//         );
//         company = material.brand ?? '---';
//       } catch (_) {}

//       return ArchiveMedicineModel(
//         name: cartItem.materialName,
//         quantity: cartItem.quantity,
//         company: company,
//       );
//     }).toList();

//     archiveList.insert(0, ArchiveItem(date: date, medicines: medicines));
//     _saveArchive();

//     // ✅ أضف هذا السطر
//     filteredArchiveList.value = List.from(archiveList);

//     cartController.clearCart();
//   }

//   void goToDetails(ArchiveItem item) {
//     Get.toNamed(AppRoutes.ArchiveDetailsPage, arguments: item);
//   }
// }


// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Logic/Cart_Controller.dart';
import 'package:stock_mate_project/core/models/Archive_Model.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';
import 'package:stock_mate_project/core/models/PrescriptionModel.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';

// ─────────────────────────────────────────────
// ArchiveItem (أرشيف سلة المشتريات)
// ─────────────────────────────────────────────
class ArchiveItem {
  final String date;
  final List<ArchiveMedicineModel> medicines;

  ArchiveItem({required this.date, required this.medicines});

  Map<String, dynamic> toJson() => {
        'date': date,
        'medicines': medicines.map((m) => m.toJson()).toList(),
      };

  factory ArchiveItem.fromJson(Map<String, dynamic> json) => ArchiveItem(
        date: json['date'] as String,
        medicines: (json['medicines'] as List)
            .map((m) => ArchiveMedicineModel.fromJson(m as Map<String, dynamic>))
            .toList(),
      );
}

// ─────────────────────────────────────────────
// ArchiveController (المدمج)
// ─────────────────────────────────────────────
class ArchiveController extends GetxController {
  static ArchiveController get to => Get.isRegistered<ArchiveController>()
      ? Get.find<ArchiveController>()
      : Get.put(ArchiveController(), permanent: true);

  // ─── Storage ───
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static const String _archiveKey = 'archive_items';
  static const String _prescriptionsKey = 'archived_prescriptions';

  // ─── أرشيف السلة ───
  final RxList<ArchiveItem> archiveList = <ArchiveItem>[].obs;
  final RxList<ArchiveItem> filteredArchiveList = <ArchiveItem>[].obs;

  // ─── أرشيف الوصفات الطبية ───
  final RxList<PrescriptionModel> archivedPrescriptions =
      <PrescriptionModel>[].obs;
  final RxString searchQuery = ''.obs;

  // ─────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _loadArchive();
    _loadPrescriptions();
  }

  // ─────────────────────────────────────────────
  //  أرشيف السلة (Archive Items)
  // ─────────────────────────────────────────────

  Future<void> _loadArchive() async {
    final raw = await _secureStorage.read(key: _archiveKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final List<dynamic> list = jsonDecode(raw);
      archiveList.value = list
          .map((e) => ArchiveItem.fromJson(e as Map<String, dynamic>))
          .toList();
      filteredArchiveList.value = List.from(archiveList);
    } catch (_) {}
  }

  Future<void> _saveArchive() async {
    final encoded = jsonEncode(archiveList.map((e) => e.toJson()).toList());
    await _secureStorage.write(key: _archiveKey, value: encoded);
  }

  void filterByDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      filteredArchiveList.value = List.from(archiveList);
      return;
    }

    final parts = dateString.split('-');
    if (parts.length != 3) return;

    final searchDate = '${parts[2]}/${parts[1]}/${parts[0]}';

    filteredArchiveList.value =
        archiveList.where((item) => item.date == searchDate).toList();
  }

  void confirmCart() {
    final cartController = CartController.to;
    if (cartController.cartItems.isEmpty) return;

    final now = DateTime.now();
    final date =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

    final medicines = cartController.cartItems.map((cartItem) {
      String company = '';
      try {
        final material = allMaterial.firstWhere(
          (m) => m.id == cartItem.materialId,
        );
        company = material.brand ?? '---';
      } catch (_) {}

      return ArchiveMedicineModel(
        name: cartItem.materialName,
        quantity: cartItem.quantity,
        company: company,
      );
    }).toList();

    archiveList.insert(0, ArchiveItem(date: date, medicines: medicines));
    _saveArchive();

    filteredArchiveList.value = List.from(archiveList);
    cartController.clearCart();
  }

  void goToDetails(ArchiveItem item) {
    Get.toNamed(AppRoutes.ArchiveDetailsPage, arguments: item);
  }

  // ─────────────────────────────────────────────
  //  أرشيف الوصفات الطبية (Prescriptions)
  // ─────────────────────────────────────────────

  Future<void> _loadPrescriptions() async {
    final raw = await _secureStorage.read(key: _prescriptionsKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final List decoded = jsonDecode(raw);
      archivedPrescriptions.assignAll(
        decoded.map((e) => PrescriptionModel.fromJson(e)).toList(),
      );
    } catch (_) {}
  }

  Future<void> _savePrescriptions() async {
    final encoded = jsonEncode(
      archivedPrescriptions.map((e) => e.toJson()).toList(),
    );
    await _secureStorage.write(key: _prescriptionsKey, value: encoded);
  }

  Future<void> addPrescriptionToArchive({
    String? id,
    required String patientName,
    required String medications,
    String? notes,
    String? doctorName,
    String? condition,
    DateTime? date,
    PrescriptionStatus status = PrescriptionStatus.newRx,
  }) async {
    final newPrescription = PrescriptionModel(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      patientName: patientName,
      doctorName: doctorName,
      medications: medications,
      notes: (notes != null && notes.trim().isNotEmpty) ? notes.trim() : null,
      date: date ?? DateTime.now(),
      status: status,
    );

    archivedPrescriptions.insert(0, newPrescription);
    await _savePrescriptions();
  }

  Future<void> deletePrescription(String id) async {
    archivedPrescriptions.removeWhere((p) => p.id == id);
    await _savePrescriptions();
  }

  // ─────────────────────────────────────────────
  //  البحث في الوصفات
  // ─────────────────────────────────────────────

  String _normalizeArabic(String text) {
    return text
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي');
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  List<PrescriptionModel> get filteredPrescriptions {
    if (searchQuery.value.trim().isEmpty) return archivedPrescriptions;
    final query = _normalizeArabic(searchQuery.value.trim().toLowerCase());
    return archivedPrescriptions
        .where(
          (p) => _normalizeArabic(p.patientName.toLowerCase()).contains(query),
        )
        .toList();
  }
}