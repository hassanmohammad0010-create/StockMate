// lib/Controller/App/Get_All_Doctors_Controller.dart
import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Boss/Get_All_Doctors_Service.dart';
import 'package:stock_mate_project/core/models/User_Model.dart';

class GetAllDoctorsController extends GetxController {
  final GetAllDoctorsService _service = GetAllDoctorsService();

  final RxBool isLoading = false.obs;
  final RxList<UserItem> doctors = <UserItem>[].obs;
  final Rxn<UserItem> selectedDoctor = Rxn<UserItem>();

  @override
  void onInit() {
    super.onInit();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    isLoading.value = true;

    final result = await _service.getAllDoctors();

    if (result != null) {
      doctors.assignAll(result.items);
    }

    isLoading.value = false;
  }
}
