// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Token_Storage.dart';

class GetNameRollOfUserController extends GetxController {
  String? name, role;
  @override
  void onInit() async {
    super.onInit();
    role = await TokenStorage.getUserID();
    name = await TokenStorage.getUserName();
    update();
  }
}
