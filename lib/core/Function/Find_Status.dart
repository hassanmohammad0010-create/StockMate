import 'package:stock_mate_project/core/models/Request_Model.dart';

class FindREquestStatus {
  findRequestStatus({required RequestStatus requestStatus}) {
    if (requestStatus == RequestStatus.pending) {
      return 'قيد الانتظار';
    } else if (requestStatus == RequestStatus.deliveried) {
      return 'تم التسليم';
    } else if (requestStatus == RequestStatus.in_progress) {
      return 'قيد التنفيذ';
    } else if (requestStatus == RequestStatus.ready_for_delivery) {
      return 'جاهز للتسليم ';
    } else if (requestStatus == RequestStatus.rejected) {
      return 'مرفوض';
    }
  }
}
