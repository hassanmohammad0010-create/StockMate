// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';

class DepartmentHeadsInventoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FilterController>(
      () => FilterController()
        ..initFilters(['الكل', 'ثابتة', 'مستهلكة', 'ادوية']),
      tag: AppRoutes.DepartmentHeadsInventoryPage,
    );
  }
}