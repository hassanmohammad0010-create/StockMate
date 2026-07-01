// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Logic/DepartmentOrdersFilterController%20.dart';

class DepartmentOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DepartmentOrdersFilterController>(
      () => DepartmentOrdersFilterController(),
    );
  }
}