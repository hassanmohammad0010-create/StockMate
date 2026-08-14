import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Boss/Get_All_Department_Service.dart';
import 'package:stock_mate_project/core/models/Department_Model.dart';

class GetDepartmentsController extends GetxController {
  List<DepartmentModel>? department;

  @override
  void onInit() {
    super.onInit();
    fetchDepartments();
  }

  /// جلب/تحديث قائمة الأقسام — قابلة للاستدعاء من برا الكنترولر
  /// (متلاً بعد نجاح إنشاء قسم جديد)
  Future<void> fetchDepartments() async {
    department = await GetAllDepartmentSer.getAllDepartments();
    update();
  }
}
