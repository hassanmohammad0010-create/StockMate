// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/Service/App/Get_Roles_Servvice.dart';
import 'package:stock_mate_project/core/models/Role_Model.dart';

class Createuserpagecontroller extends GetxController {
  List<RoleModel> rolesModel = [];
  List<String> roleNames = [];

  @override
  void onInit() async {
    super.onInit();
    await _loadRoles();
  }

  Future<void> _loadRoles() async {
    rolesModel = await RoleService.getRoles();

    if (rolesModel.isNotEmpty) {
      roleNames = rolesModel.map((role) => role.name.arabicLabel).toList();
      update();
    }
  }

  /// يرجع الـ id الخاص بالرول اعتمادًا على اسمه العربي
  /// يرجع null إذا ما لقى الاسم (بدل ما يرمي exception)
  String? getRoleId({required String roleName}) {
    for (int i = 0; i < rolesModel.length; i++) {
      if (rolesModel[i].name.arabicLabel == roleName) {
        return rolesModel[i].id;
      }
    }
    return null;
  }
}
