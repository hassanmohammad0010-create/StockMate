// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/core/models/Archive_Model.dart';

class ArchiveItem {
  final String date;
  final List<ArchiveMedicineModel> medicines;

  ArchiveItem({required this.date, required this.medicines});
}

class ArchiveController extends GetxController {
  final List<ArchiveItem> archiveList = [
    ArchiveItem(
      date: '12/09/2024',
      medicines: [
        ArchiveMedicineModel(
          name: 'باراسيتامول',
          quantity: 20,
          company: 'شركة المتحدة للأدوية',
        ),
        ArchiveMedicineModel(
          name: 'أموكسيسيلين',
          quantity: 10,
          company: 'شركة الحكمة',
        ),
      ],
    ),
    ArchiveItem(
      date: '13/09/2024',
      medicines: [
        ArchiveMedicineModel(
          name: 'إيبوبروفين',
          quantity: 15,
          company: 'شركة بيت جالا',
        ),
      ],
    ),
    ArchiveItem(date: '14/09/2024', medicines: []),
    ArchiveItem(date: '15/09/2024', medicines: []),
  ];

  void goToDetails(ArchiveItem item) {
    Get.toNamed('/ArchiveDetailsPage', arguments: item);
  }
}