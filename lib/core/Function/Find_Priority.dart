import 'package:stock_mate_project/core/models/Request_Model.dart';

class FindRequestPriority {
  findRequestPriority({required RequestPriority requestPriority}) {
    if (requestPriority == RequestPriority.normal) {
      return 'عادي';
    } else if (requestPriority == RequestPriority.urgent) {
      return 'ضروري';
    }
  }
}
