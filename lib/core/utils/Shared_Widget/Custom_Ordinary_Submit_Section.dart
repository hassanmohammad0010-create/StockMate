import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/AddOrdinaryOrder_Controller.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';

class OrdinarySubmitSection extends GetView<AddOrdinaryOrderController> {
  const OrdinarySubmitSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02,top: MediaQuery.of(context).size.height * 0.01),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color:  Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            final count = controller.orders.length;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'عدد الطلبات: ',
                  style:
                      TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
                ...List.generate(
                  AddOrdinaryOrderController.maxOrders,
                  (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: 8, height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i < count ? constBlue : Colors.grey.shade200,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '$count / ${AddOrdinaryOrderController.maxOrders}',
                  style: TextStyle(
                    fontSize:   12,
                    fontWeight: FontWeight.w600,
                    color:      constBlue,
                  ),
                ),
              ],
            );
          }),

          const SizedBox(height: 10),

          Obx(() {
            final loading = controller.isLoading.value;
            final count   = controller.orders.length;
            return CustomMainButtom(
              title:     loading
                  ? 'جاري الإرسال ...'
                  : 'تأكيد الإرسال ($count)',
              color:     constBlue,
              fontcolor: Colors.white,
              onPressed: loading ? () {} : controller.submitOrders,
            );
          }),
        ],
      ),
    );
  }
}