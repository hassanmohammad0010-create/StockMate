import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Token_Storage.dart';

class GetNameRollOfUserController extends GetxController {
  final RxnString id = RxnString();
  final RxnString name = RxnString();
  final RxnString role = RxnString();
  final RxnString departmentName = RxnString();

  @override
  void onInit() async {
    super.onInit();
    id.value = await TokenStorage.getDepartmentID();
    name.value = await TokenStorage.getUserName();
    role.value = await TokenStorage.getUserRole();
    departmentName.value = await TokenStorage.getDepartmentName();
  }
}