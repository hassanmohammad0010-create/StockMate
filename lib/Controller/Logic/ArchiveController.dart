// ignore_for_file: file_names
import 'dart:convert';
import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Logic/Cart_Controller.dart';
import 'package:stock_mate_project/core/models/Archive_Model.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/main.dart';

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

// class ArchiveController extends GetxController {
//   /// Singleton — يُستخدم من أي مكان بـ ArchiveController.to
//   static ArchiveController get to => Get.isRegistered<ArchiveController>()
//       ? Get.find<ArchiveController>()
//       : Get.put(ArchiveController(), permanent: true);

//   static const String _archiveKey = 'archive_items';

//   final RxList<ArchiveItem> archiveList = <ArchiveItem>[].obs;

//   // ─── Lifecycle ────────────────────────────────────────────────────────────

//   @override
//   void onInit() {
//     super.onInit();
//     _loadArchive();
//   }

//   // ─── Persistence ──────────────────────────────────────────────────────────

//   void _loadArchive() {
//     final json = shareprefs?.getString(_archiveKey);
//     if (json == null) return;
//     try {
//       final List<dynamic> list = jsonDecode(json);
//       archiveList.value = list
//           .map((e) => ArchiveItem.fromJson(e as Map<String, dynamic>))
//           .toList();
//     } catch (_) {}
//   }

//   void _saveArchive() {
//     shareprefs?.setString(
//       _archiveKey,
//       jsonEncode(archiveList.map((e) => e.toJson()).toList()),
//     );
//   }

//   // ─── Operations ───────────────────────────────────────────────────────────

//   /// يؤكد السلة الحالية وينقلها إلى الأرشيف ثم يفرغ السلة.
//   void confirmCart() {
//     final cartController = CartController.to;
//     if (cartController.cartItems.isEmpty) return;

//     // تنسيق التاريخ الحالي
//     final now = DateTime.now();
//     final date =
//         '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

//     // تحويل عناصر السلة إلى ArchiveMedicineModel
//     final medicines = cartController.cartItems.map((cartItem) {
//       String company = '';
//       try {
//         // ابحث عن المادة في allMaterial للحصول على اسم الشركة
//         final material =
//             allMaterial.firstWhere((m) => m.id == cartItem.materialId);
//         company = material.brand; // عدّل اسم الحقل إن اختلف في موديلك
//       } catch (_) {}

//       return ArchiveMedicineModel(
//         name: cartItem.materialName,
//         quantity: cartItem.quantity,
//         company: company,
//       );
//     }).toList();

//     // أضف إلى مقدمة الأرشيف (الأحدث أولاً)
//     archiveList.insert(0, ArchiveItem(date: date, medicines: medicines));
//     _saveArchive();

//     // افرغ السلة
//     cartController.clearCart();
//   }

//   void goToDetails(ArchiveItem item) {
//     Get.toNamed(AppRoutes.ArchiveDetailsPage, arguments: item);
//   }
// }

class ArchiveController extends GetxController {
  static ArchiveController get to => Get.isRegistered<ArchiveController>()
      ? Get.find<ArchiveController>()
      : Get.put(ArchiveController(), permanent: true);

  static const String _archiveKey = 'archive_items';

  final RxList<ArchiveItem> archiveList = <ArchiveItem>[].obs;
  
  // ✅ أضف هذا السطر الجديد
  final RxList<ArchiveItem> filteredArchiveList = <ArchiveItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadArchive();
  }

  void _loadArchive() {
    final json = shareprefs?.getString(_archiveKey);
    if (json == null) return;
    try {
      final List<dynamic> list = jsonDecode(json);
      archiveList.value = list
          .map((e) => ArchiveItem.fromJson(e as Map<String, dynamic>))
          .toList();
      // ✅ أضف هذا السطر
      filteredArchiveList.value = List.from(archiveList);
    } catch (_) {}
  }

  void _saveArchive() {
    shareprefs?.setString(
      _archiveKey,
      jsonEncode(archiveList.map((e) => e.toJson()).toList()),
    );
  }

  // ✅ أضف هذه الدالة الجديدة
  void filterByDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      filteredArchiveList.value = List.from(archiveList);
      return;
    }

    // تحويل التاريخ من YYYY-MM-DD إلى DD/MM/YYYY للمقارنة
    final parts = dateString.split('-');
    if (parts.length != 3) return;
    
    final searchDate = '${parts[2]}/${parts[1]}/${parts[0]}';
    
    filteredArchiveList.value = archiveList
        .where((item) => item.date == searchDate)
        .toList();
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
        final material =
            allMaterial.firstWhere((m) => m.id == cartItem.materialId);
        company = material.brand;
      } catch (_) {}

      return ArchiveMedicineModel(
        name: cartItem.materialName,
        quantity: cartItem.quantity,
        company: company,
      );
    }).toList();

    archiveList.insert(0, ArchiveItem(date: date, medicines: medicines));
    _saveArchive();
    
    // ✅ أضف هذا السطر
    filteredArchiveList.value = List.from(archiveList);

    cartController.clearCart();
  }

  void goToDetails(ArchiveItem item) {
    Get.toNamed(AppRoutes.ArchiveDetailsPage, arguments: item);
  }
}

