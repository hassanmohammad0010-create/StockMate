// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Token_Storage.dart';

class GetNameRollOfUserController extends GetxController {
  String? name, role, id, departmentName;
  @override
  void onInit() async {
    super.onInit();
    id = await TokenStorage.getDepartmentID();
    name = await TokenStorage.getUserName();
    role = await TokenStorage.getUserRole();
    departmentName = await TokenStorage.getDepartmentName();
    update();
  }
}
