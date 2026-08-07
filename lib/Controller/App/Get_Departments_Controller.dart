import 'package:get/get.dart';
import 'package:stock_mate_project/Service/App/Get_All_Department_Service.dart';
import 'package:stock_mate_project/core/models/Department_Model.dart';

class GetDepartmentsController extends GetxController {
  List<DepartmentModel>? department;
  @override
  void onInit() async {
    super.onInit();
    department = await GetAllDepartmentSer.getAllDepartments();
    update();
  }
}
