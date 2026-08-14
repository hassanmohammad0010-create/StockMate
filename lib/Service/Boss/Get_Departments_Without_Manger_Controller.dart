// lib/Controller/App/Get_Departments_Controller.dart
import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Boss/Get_Filtered_Departments_Service.dart';
import 'package:stock_mate_project/core/models/Department_Model.dart';

class GetDepartmentsWithoutMangerController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<DepartmentModel> departments = <DepartmentModel>[].obs;
  final Rxn<DepartmentModel> selectedDepartment = Rxn<DepartmentModel>();

  @override
  void onInit() {
    super.onInit();
    fetchDepartments();
  }

  Future<void> fetchDepartments() async {
    isLoading.value = true;
    final result = await GetFilteredDepartmentsService.getFilteredDepartments();
    departments.assignAll(result);
    isLoading.value = false;
  }
}
