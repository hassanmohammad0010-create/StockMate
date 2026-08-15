// lib/Controller/App/Get_Department_Header_Without_Postion_Controller.dart
import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Boss/Get_Department_Header_Without_Postion_Service.dart';
import 'package:stock_mate_project/core/models/User_Model.dart';

class GetDepartmentHeaderWithoutPostionController extends GetxController {
  final GetDepartmentHeaderWithoutPostionService _service =
      GetDepartmentHeaderWithoutPostionService();

  final RxBool isLoading = false.obs;
  final RxList<UserItem> managers = <UserItem>[].obs;
  final Rxn<UserItem> selectedManager = Rxn<UserItem>();

  @override
  void onInit() {
    super.onInit();
    fetchManagers();
  }

  Future<void> fetchManagers() async {
    isLoading.value = true;

    final result = await _service.getDepartmentHeaderWithoutPostion();

    if (result != null) {
      managers.assignAll(result.items);
    }

    isLoading.value = false;
  }
}
