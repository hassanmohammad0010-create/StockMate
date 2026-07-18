import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Boss/Get_urgent_Department_Requests_Service.dart';
import 'package:stock_mate_project/core/models/Request_Model.dart';

class GetUrgentDepartmentRequestsController extends GetxController {
  List<RequestModel>? requests;

  @override
  void onInit() async {
    super.onInit();
    requests = await GetUrgentDepartmentRequestsService()
        .getUrgentDepartmentRequestsService();
    update();
  }

  refresh() async {
    requests = await GetUrgentDepartmentRequestsService()
        .getUrgentDepartmentRequestsService();
    update();
  }
}
