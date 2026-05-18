import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DatePickerController extends GetxController {
  var fromDate = Rxn<DateTime>();
  var toDate = Rxn<DateTime>();

  // أضف TextEditingController لكل حقل
  final fromDateTextController = TextEditingController();
  final toDateTextController = TextEditingController();

  bool get hasFromDate => fromDate.value != null;
  bool get hasToDate => toDate.value != null;

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> pickFromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: fromDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      fromDate.value = picked;
      fromDateTextController.text = formatDate(picked); // ← هنا المهم
    }
  }

  Future<void> pickToDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: toDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      toDate.value = picked;
      toDateTextController.text = formatDate(picked); // ← هنا المهم
    }
  }

  void clearFromDate() {
    fromDate.value = null;
    fromDateTextController.clear(); // ← امسح النص
  }

  void clearToDate() {
    toDate.value = null;
    toDateTextController.clear(); // ← امسح النص
  }

  @override
  void onClose() {
    fromDateTextController.dispose();
    toDateTextController.dispose();
    super.onClose();
  }
}
