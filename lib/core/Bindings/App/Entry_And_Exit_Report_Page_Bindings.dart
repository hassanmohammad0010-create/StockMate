import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Logic/DatePicker_Controller.dart';

class EntryAndExitReportPageBindings extends Bindings {
  @override
  void dependencies() {
    final DatePickerController datePickerController = Get.put(
      DatePickerController(),
      tag: 'EntryAndExitReportPage',
    );
  }
}
