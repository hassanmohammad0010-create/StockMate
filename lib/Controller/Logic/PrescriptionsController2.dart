// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/core/models/Prescriptions_Model.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';

class PrescriptionsController extends GetxController {
  static PrescriptionsController get to =>
      Get.isRegistered<PrescriptionsController>()
      ? Get.find<PrescriptionsController>()
      : Get.put(PrescriptionsController());

  final RxList<Prescription> prescriptions = allPrescriptions.obs;

  int get newCount =>
      prescriptions.where((p) => p.status == PrescriptionStatus.newRx).length;

  int get processedCount => prescriptions
      .where((p) => p.status == PrescriptionStatus.processed)
      .length;

  void goToDetails(Prescription prescription) {
    Get.toNamed(AppRoutes.PrescriptionDetailsPage, arguments: prescription);
  }
}
