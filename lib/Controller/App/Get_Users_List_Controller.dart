// lib/Controller/App/Get_Users_List_Controller.dart
// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Boss/Get_All_User_Service.dart';
import 'package:stock_mate_project/core/models/User_Model.dart';

class GetUsersListController extends GetxController {
  final GetUsersListService _service = GetUsersListService();

  List<UserItem>? users; // null = لسا عم يحمّل
  int total = 0;
  int page = 1;
  int totalPages = 1;

  @override
  void onInit() {
    super.onInit();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final result = await _service.getUsers(page: page);

    if (result != null) {
      users = result.items;
      total = result.total;
      totalPages = result.totalPages;
    } else {
      users =
          []; // فشل الطلب → لستة فاضية بدل ما تضل null للأبد (بتفعّل empty state)
    }

    update();
  }

  /// لإعادة التحميل من جديد (مثلاً بعد إنشاء مستخدم جديد أو Pull-to-refresh)
  Future<void> refreshUsers() async {
    users = null; // يرجع يظهر اللودينغ أثناء التحديث
    update();
    page = 1;
    await _loadUsers();
  }
}
