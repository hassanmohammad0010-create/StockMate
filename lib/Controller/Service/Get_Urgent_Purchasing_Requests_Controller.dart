import 'package:get/get.dart';
import 'package:stock_mate_project/Service/Boss/Get_urgent_Purchase_Requests_Service.dart';
import 'package:stock_mate_project/core/models/Purchase_Request_Model.dart';

class GetUrgentPurchasingRequestsController extends GetxController {
  List<PurchaseRequest>? requests;

  @override
  void onInit() async {
    super.onInit();
    requests = await GetUrgentPurchaseRequestsService()
        .getUrgentPurchaseRequestsService();
    update();
  }

  refresh() async {
    requests = await GetUrgentPurchaseRequestsService()
        .getUrgentPurchaseRequestsService();
    update();
  }
}
