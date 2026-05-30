// ignore_for_file: file_names

import 'package:get/get.dart';

// ============ Controller ============
class RecurringController extends GetxController {
  var selectedRecurring = ''.obs;

  void selectRecurring(String value) {
    selectedRecurring.value = value;
  }

  String get recurringValue => selectedRecurring.value;
}